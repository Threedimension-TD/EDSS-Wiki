/// 创建新 Wiki 页面的表单组件
/// 提供输入框让用户输入页面名称，调用后端 API 创建页面后自动跳转

import 'package:flutter/material.dart';
import 'package:web_of_edss/services/wiki_service.dart';

/// 创建页面组件（有状态组件）
/// 包含页面名称输入框和创建按钮
class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

/// CreatePage 的状态管理类
class _CreatePageState extends State<CreatePage> {
  /// 页面名称输入控制器
  final TextEditingController _pageIdController = TextEditingController();

  /// 创建页面并跳转
  /// 验证输入不为空后，调用 WikiService 创建页面，成功后跳转到新页面
  void _createPage() async {
    final pageId = _pageIdController.text.trim();

    // 验证页面名称不为空
    if (pageId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('页面名称不能为空')),
      );
      return;
    }

    try {
      // 调用后端 API 创建页面
      await WikiService.createPage(pageId);

      // 创建成功后跳转到新页面（替换当前路由）
      await Navigator.pushReplacementNamed(context, '/wiki/$pageId');
    } catch (e) {
      // 创建失败，显示错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('创建页面失败，请重试')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 420,
        height: 260,
        child: Card(
          elevation: 8,  // 阴影高度
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          // 半透明白色背景
          color: Colors.white.withOpacity(0.7),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 标题文字
                const Text(
                  "创建新页面",
                  style: TextStyle(
                    fontSize: 32,
                    color: Color.fromARGB(170, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 24),

                // 页面名称输入框
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _pageIdController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(170, 0, 0, 0),
                          width: 2.0,
                        ),
                      ),
                      isDense: true,
                      labelText: '输入页面名称',
                      labelStyle: TextStyle(color: Color.fromARGB(170, 0, 0, 0)),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // 创建按钮
                ElevatedButton(
                  onPressed: _createPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(170, 0, 0, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  child: const Text("创建页面", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
