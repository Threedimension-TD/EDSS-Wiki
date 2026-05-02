/// Wiki 内容卡片组件
/// 核心组件，负责 Wiki 页面内容的展示、编辑、保存和加载
/// 支持 Markdown 编辑和 HTML 渲染展示

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:markdown/markdown.dart' as md;
import 'package:web_of_edss/services/auth_service.dart';
import 'package:web_of_edss/specialpage/LoginPage.dart';

/// Wiki 页面模式枚举
/// view: 阅读模式，展示渲染后的 HTML 内容
/// edit: 编辑模式，提供 Markdown 文本编辑器
enum WikiMode { view, edit }

/// Wiki 内容卡片（有状态组件）
/// 接收 pageId 用于标识页面，width 控制卡片宽度
class WikiCard extends StatefulWidget {
  /// 页面 ID，用于从后端加载和保存对应内容
  final String? pageId;

  /// 卡片宽度，默认 2000 像素
  final double width;

  const WikiCard({
    super.key,
    required this.pageId,
    this.width = 2000,
  });

  @override
  State<WikiCard> createState() => _WikiCardState();
}

/// WikiCard 的状态管理类
class _WikiCardState extends State<WikiCard> {
  /// 文本编辑控制器，用于编辑模式下的文本输入和阅读模式下的内容展示
  late TextEditingController _controller;

  /// 当前 Wiki 页面的模式（默认为阅读模式）
  WikiMode _mode = WikiMode.view;

  /// 用户是否已登录
  bool isLoggedIn = false;

  /// 后端 API 的基础 URL
  String baseUrl = "http://localhost:8080";

  /// 当前字体大小，支持用户调整
  double _currentFontSize = 20;

  /// 初始化状态：创建控制器、检查登录状态、从服务器加载内容
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _checkLoginStatus();  // 检查是否登录
    _loadFromServer();    // 从数据库加载文本
  }

  /// 销毁时释放控制器资源，防止内存泄漏
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 异步检查用户登录状态并更新 UI
  void _checkLoginStatus() async {
    final loggedIn = await AuthService.isLoggedIn();
    setState(() => isLoggedIn = loggedIn);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.width,
        margin: const EdgeInsets.symmetric(vertical: 0),
        child: Card(
          // 半透明白色背景卡片
          color: Colors.white.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),           // 顶部操作栏（模式切换、保存/取消按钮）
                const Divider(),          // 分割线
                _buildBody(),             // 内容区域（编辑器或渲染后的 HTML）
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建顶部操作栏
  /// 显示当前模式名称，以及编辑/保存/取消按钮
  Widget _buildHeader() {
    return Row(
      children: [
        // 当前模式标签
        Text(
          _mode == WikiMode.view ? "阅读模式" : "编辑模式",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),

        // 阅读模式下显示"编辑"按钮
        if (_mode == WikiMode.view)
          TextButton.icon(
            icon: const Icon(Icons.edit, color: Color.fromARGB(170, 0, 0, 0)),
            label: const Text("编辑", style: TextStyle(color: Color.fromARGB(170, 0, 0, 0))),
            onPressed: () {
              if (isLoggedIn) {
                // 已登录：切换到编辑模式
                setState(() => _mode = WikiMode.edit);
              } else {
                // 未登录：跳转到登录页
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              }
            },
          ),

        // 编辑模式下显示"取消"和"保存"按钮
        if (_mode == WikiMode.edit) ...[
          // 取消按钮：返回阅读模式
          TextButton(
            onPressed: () => setState(() => _mode = WikiMode.view),
            child: const Text("取消", style: TextStyle(color: Color.fromARGB(170, 0, 0, 0))),
          ),
          const SizedBox(width: 8),
          // 保存按钮：保存内容到服务器后返回阅读模式
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color.fromARGB(170, 0, 0, 0)),
            ),
            onPressed: () async {
              await _saveToServer(_controller.text);
              setState(() => _mode = WikiMode.view);
            },
            child: const Text("保存", style: TextStyle(color: Colors.white)),
          ),
        ],
      ],
    );
  }

  /// 构建内容展示区域
  /// 编辑模式：显示 Markdown 文本编辑器
  /// 阅读模式：将 Markdown 转换为 HTML 后渲染展示
  Widget _buildBody() {
    // 编辑模式：显示文本输入框
    if (_mode == WikiMode.edit) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditorToolbar(),  // 编辑器提示工具栏
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            maxLines: null,  // 支持多行输入
            style: TextStyle(fontSize: _currentFontSize, fontWeight: FontWeight.w100),
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(170, 0, 0, 0), width: 2.0),
              ),
              border: OutlineInputBorder(),
              hintText: "支持HTML",
            ),
          ),
        ],
      );
    }

    // 阅读模式：将 Markdown 转换为 HTML 并渲染
    final html = md.markdownToHtml(_controller.text);
    final htmlContent = html.isNotEmpty ? html : "<p>暂无内容</p>";

    return Html(
      data: htmlContent,
      // 自定义各 HTML 标签的样式
      style: {
        "body": Style(fontSize: FontSize(_currentFontSize)),
        "h1": Style(fontSize: FontSize(52), fontWeight: FontWeight.normal),
        "h2": Style(fontSize: FontSize(36), fontWeight: FontWeight.normal),
        "h3": Style(fontSize: FontSize(30), fontWeight: FontWeight.normal),
        "b": Style(fontWeight: FontWeight.bold),
        "i": Style(fontStyle: FontStyle.italic),
        "hr": Style(color: Colors.grey),
      },
    );
  }

  /// 构建编辑器工具栏提示
  /// 提示用户使用 HTML 语法进行编辑
  Widget _buildEditorToolbar() {
    return const Text(
      "使用html进行编辑，示例：<h1>Page Content</h1>",
      style: TextStyle(color: Colors.black54),
    );
  }

  /// 将内容保存到服务器
  /// [content] 要保存的 Markdown 文本内容
  /// 通过 PUT 请求发送到后端 API
  Future<void> _saveToServer(String content) async {
    final url = Uri.parse(
      '$baseUrl/api/wiki/${widget.pageId}',
    );

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'content': content}),
      );

      if (response.statusCode != 200) {
        debugPrint('保存失败：${response.statusCode}');
      }
    } catch (e) {
      debugPrint('保存异常: $e');
    }
  }

  /// 从服务器加载页面内容
  /// 通过 GET 请求获取指定 pageId 的 Wiki 内容并更新到编辑器
  Future<void> _loadFromServer() async {
    final url = Uri.parse(
      '$baseUrl/api/wiki/${widget.pageId}',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _controller.text = data['content'] ?? '';
        });
      }
    } catch (e) {
      debugPrint('加载异常: $e');
    }
  }
}
