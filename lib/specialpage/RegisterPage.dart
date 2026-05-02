/// 注册页面组件
/// 提供用户名、邮箱、密码、确认密码的注册表单，调用认证服务完成注册

import 'package:flutter/material.dart';
import 'package:web_of_edss/MyAppBar.dart';
import 'package:web_of_edss/MyBottomNavigationBar.dart';
import 'package:web_of_edss/componets/Widget.dart';
import 'package:web_of_edss/services/auth_service.dart';

/// 注册页面（有状态组件）
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

/// RegisterPage 的状态管理类
class _RegisterPageState extends State<RegisterPage> {
  /// 用户名输入控制器
  final TextEditingController _usernameController = TextEditingController();

  /// 邮箱输入控制器
  final TextEditingController _emailController = TextEditingController();

  /// 密码输入控制器
  final TextEditingController _passwordController = TextEditingController();

  /// 确认密码输入控制器
  final TextEditingController _confirmPasswordController = TextEditingController();

  /// 输入框标签和提示文字的颜色
  final Color color = Color.fromARGB(170, 0, 0, 0,);

  /// 是否正在提交注册请求
  bool _isLoading = false;

  /// 错误提示信息
  String? _errorMessage;

  /// 密码是否可见（切换明文/密文显示）
  bool _passwordVisible = false;

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
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(80),
                child: SizedBox(
                  width: 500,
                  height: 550,
                  child: Card(
                    // 半透明白色背景
                    color: Colors.white.withOpacity(0.75),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // 页面标题
                          TitleText("注册"),

                          // 温馨提示
                          Center(
                            child: Text(
                              '''温馨提示：若要注册请先确保您至少一次进入过服务器
                                ''',
                              style: TextStyle(
                                color: Colors.red,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),

                          // 用户名输入框
                          _buildInput(
                            controller: _usernameController,
                            label: "用户名",
                            icon: Icons.person,
                          ),

                          // 邮箱输入框
                          _buildInput(
                            controller: _emailController,
                            label: "邮箱",
                            icon: Icons.email,
                          ),

                          // 密码输入框（带显示/隐藏切换按钮）
                          _buildInput(
                            controller: _passwordController,
                            label: "密码",
                            icon: Icons.lock,
                            obscure: !_passwordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(_passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),

                          // 确认密码输入框（始终隐藏）
                          _buildInput(
                            controller: _confirmPasswordController,
                            label: "确认密码",
                            icon: Icons.lock_outline,
                            obscure: true,
                          ),

                          SizedBox(height: 30),

                          // 注册按钮（加载中时禁用）
                          SizedBox(
                            width: 300,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              child: Text("注册", style: TextStyle(color: Colors.white)),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(170, 0, 0, 0),
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
            MyBottomBavigationBar(),
          ],
        ),
      ),
    );
  }

  /// 构建统一风格的输入框组件
  /// [controller] 文本控制器
  /// [label] 输入框标签文字
  /// [icon] 前缀图标
  /// [obscure] 是否隐藏输入内容（默认 false）
  /// [suffixIcon] 后缀图标（可选，如密码显示/隐藏按钮）
  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: 300,
        height: 45,
        child: TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: color),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(170, 0, 0, 0),
                width: 2.0,
              ),
            ),
            prefixIcon: Icon(icon),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  /// 处理注册逻辑
  /// 验证所有输入字段后，调用认证服务进行注册
  Future<void> _handleRegister() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // 验证所有字段不为空
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showError("请填写完整注册信息");
      return;
    }

    // 验证邮箱格式
    if (!_isValidEmail(email)) {
      _showError("邮箱格式不正确");
      return;
    }

    // 验证密码长度
    if (password.length < 6) {
      _showError("密码长度至少 6 位");
      return;
    }

    // 验证两次密码输入一致
    if (password != confirmPassword) {
      _showError("两次输入的密码不一致");
      return;
    }

    // 设置加载状态
    setState(() => _isLoading = true);

    // 调用认证服务进行注册
    final result = await AuthService.register(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    // 取消加载状态
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      // 注册成功：提示并跳转到登录页
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("注册成功，请登录")));
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // 注册失败：显示错误信息
      _showError(result['message']);
    }
  }

  /// 验证邮箱格式是否合法
  /// [email] 邮箱字符串
  /// 返回 true 表示格式正确
  bool _isValidEmail(String email) {
    final reg = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return reg.hasMatch(email);
  }

  /// 显示错误提示信息（通过 SnackBar）
  /// [message] 要显示的错误消息
  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
