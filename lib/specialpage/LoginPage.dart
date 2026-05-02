/// 登录页面组件
/// 提供用户名/邮箱和密码的输入表单，调用认证服务完成登录

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:web_of_edss/MyAppBar.dart';
import 'package:web_of_edss/MyBottomNavigationBar.dart';
import 'package:web_of_edss/componets/Widget.dart';
import 'package:web_of_edss/services/auth_service.dart';

/// 登录页面（有状态组件）
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

/// LoginPage 的状态管理类
class _LoginPageState extends State<LoginPage> {
  /// 用户名输入控制器
  final TextEditingController _usernameController = TextEditingController();

  /// 密码输入控制器
  final TextEditingController _passwordController = TextEditingController();

  /// 输入框标签和提示文字的颜色
  final Color color = Color.fromARGB(170, 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),  // 顶部导航栏
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 设置背景图片
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            ListView(
              physics: ClampingScrollPhysics(),  // 禁止回弹效果
              cacheExtent: 500.0,                // 预缓存区域大小
              children: [
                Column(
                  children: [
                    // 登录表单卡片
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(100),
                        child: SizedBox(
                          height: 400,
                          width: 500,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            // 半透明白色背景
                            color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
                            child: IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 页面标题
                                  Center(
                                    child: TitleText("登录"),
                                  ),

                                  // 温馨提示
                                  Center(
                                    child: Text(
                                      '''温馨提示：若要登录请先确保您至少一次进入过服务器
                                ''',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),

                                  // 用户名/邮箱输入框
                                  Center(
                                    child: SizedBox(
                                      width: 300,
                                      height: 40,
                                      child: TextField(
                                        controller: _usernameController,
                                        decoration: InputDecoration(
                                          labelText: '用户名/邮箱',
                                          labelStyle: TextStyle(color: color),
                                          focusColor: Color.fromARGB(170, 0, 0, 0),
                                          hintText: '请输入用户名或邮箱',
                                          hintStyle: TextStyle(color: color),
                                          prefixIcon: Icon(Icons.person),
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(170, 0, 0, 0),
                                              width: 2.0,
                                            ),
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                        ),
                                        // 实时监听输入变化
                                        onChanged: (value) {
                                          print('用户名输入: $value');
                                        },
                                      ),
                                    ),
                                  ),

                                  // 透明分割线（间距用）
                                  Divider(color: Colors.transparent),

                                  // 密码输入框
                                  Center(
                                    child: SizedBox(
                                      width: 300,
                                      height: 40,
                                      child: TextField(
                                        controller: _passwordController,
                                        obscureText: true,  // 隐藏密码
                                        decoration: InputDecoration(
                                          labelText: '密码',
                                          labelStyle: TextStyle(color: color),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(170, 0, 0, 0),
                                              width: 2.0,
                                            ),
                                          ),
                                          prefixIcon: Icon(Icons.lock),
                                          border: OutlineInputBorder(),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                              width: 2.0,
                                            ),
                                          ),
                                          hintText: "密码",
                                          hintStyle: TextStyle(color: color),
                                          fillColor: Colors.white,
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // 透明分割线（间距用）
                                  Divider(
                                    color: Colors.transparent,
                                    height: 40,
                                  ),

                                  // 登录按钮
                                  Center(
                                    child: SizedBox(
                                      height: 40,
                                      width: 300,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                            Color.fromARGB(170, 0, 0, 0),
                                          ),
                                        ),
                                        onPressed: _handleLogin,  // 绑定登录处理函数
                                        child: Text('登录', style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ),

                                  // 注册链接
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          children: [
                                            const TextSpan(text: '还没注册账号？'),
                                            TextSpan(
                                              text: '点此注册',
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                decoration: TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  // 点击跳转到注册页面
                                                  Navigator.pushNamed(context, '/register');
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 底部信息栏
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      child: MyBottomBavigationBar(),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  /// 处理登录逻辑
  /// 1. 获取输入值
  /// 2. 前端验证（非空检查）
  /// 3. 调用后端 API 进行登录
  /// 4. 根据结果跳转或显示错误信息
  Future<void> _handleLogin() async {
    // 获取输入值
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    // 前端验证：用户名和密码不能为空
    if (username.isEmpty || password.isEmpty) {
      _showError('请输入用户名和密码');
      return;
    }

    try {
      // 调用认证服务的登录方法
      final result = await AuthService.login(username, password);

      if (result['success'] == true) {
        // 登录成功：刷新登录状态并跳转到首页
        setState(() {
          AuthService.isLoggedIn();
        });
        Navigator.pushReplacementNamed(context, '/');
      } else {
        // 登录失败：显示后端返回的错误信息
        _showError(result['message']);
      }
    } catch (e) {
      // 网络错误
      _showError('网络连接失败: $e');
    }
  }

  /// 显示错误提示信息（通过 SnackBar）
  /// [message] 要显示的错误消息
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }

  /// 验证邮箱格式
  /// [value] 邮箱字符串
  /// 返回 null 表示验证通过，返回字符串表示错误信息
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '邮箱不能为空';
    }
    if (!value.contains('@')) {
      return '请输入有效的邮箱地址';
    }
    return null;
  }

  /// 销毁时清理控制器，防止内存泄漏
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
