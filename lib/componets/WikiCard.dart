import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:markdown/markdown.dart' as md;
import 'package:web_of_edss/services/auth_service.dart';
import 'package:web_of_edss/specialpage/LoginPage.dart';

enum WikiMode { view, edit } //使用枚举切换模式

class WikiCard extends StatefulWidget {
  final String? pageId;
  final double width;
 

  const WikiCard({
    super.key,
    required this.pageId,
    this.width = 2000,
    
  });

  @override
  State<WikiCard> createState() => _WikiCardState();
}

class _WikiCardState extends State<WikiCard> {
  late TextEditingController _controller;
  WikiMode _mode = WikiMode.view;//默认设置为阅读模式
  bool isLoggedIn = false;
  String baseUrl = "http://localhost:8080";//https://krystin-unshippable-eloise.ngrok-free.dev
  double _currentFontSize = 20;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();//控制编辑功能
    _checkLoginStatus();//检查是否登录
    _loadFromServer();//从数据库加载文本
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          color: Colors.white.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const Divider(),
                _buildBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          _mode == WikiMode.view ? "阅读模式" : "编辑模式",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),

        // 编辑模式
        if (_mode == WikiMode.view)
          TextButton.icon(
            icon: const Icon(Icons.edit, color: Color.fromARGB(170, 0, 0, 0)),
            label: const Text("编辑", style: TextStyle(color: Color.fromARGB(170, 0, 0, 0))),
            onPressed: () {
              if (isLoggedIn) {
                setState(() => _mode = WikiMode.edit);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              }
            },
          ),

        // 编辑模式按钮
        if (_mode == WikiMode.edit) ...[
          TextButton(
            onPressed: () => setState(() => _mode = WikiMode.view),
            child: const Text("取消",style: TextStyle(color: Color.fromARGB(170, 0, 0, 0)),),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Color.fromARGB(170, 0, 0, 0)),
            ),
            onPressed: () async {
              await _saveToServer(_controller.text);
              setState(() => _mode = WikiMode.view);
            },
            child: const Text("保存",style: TextStyle(color: Colors.white),),
          ),
        ],
      ],
    );
  }

  
  Widget _buildBody() {
    if (_mode == WikiMode.edit) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditorToolbar(),
          const SizedBox(height: 8),
          TextField(

            controller: _controller,
            maxLines: null,
            style: TextStyle(fontSize: _currentFontSize,fontWeight: FontWeight.w100),
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(170, 0, 0, 0), width: 2.0), // 设置选中时的边框颜色
              ),
              border: OutlineInputBorder(),
              hintText: "支持HTML",
            ),
          ),
        ],
      );
    }

    //阅读模式
    final html = md.markdownToHtml(_controller.text);
    final htmlContent = html.isNotEmpty ? html : "<p>暂无内容</p>";

    return Html(
      data: htmlContent,
      style: {
        "body": Style(fontSize: FontSize(_currentFontSize)),
        "h1": Style(fontSize: FontSize(52),fontWeight: FontWeight.normal),
        "h2": Style(fontSize: FontSize(36),fontWeight: FontWeight.normal),
        "h3":Style(fontSize: FontSize(30),fontWeight: FontWeight.normal),
        "b": Style(fontWeight: FontWeight.bold),
        "i": Style(fontStyle: FontStyle.italic),
        "hr": Style(color: Colors.grey),
        
        
      },
    );
  }

  
  Widget _buildEditorToolbar() {
    return const Text(
      "使用html进行编辑，示例：<h1>Page Content</h1>",
      style: TextStyle(color: Colors.black54),
    );
  }

  //保存
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
//加载
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
