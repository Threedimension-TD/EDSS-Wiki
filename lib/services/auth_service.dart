/// 认证服务模块
/// 提供用户登录、注册、登出、登录状态检查等功能
/// 通过 HTTP 请求与后端 API 交互，并使用 SharedPreferences 本地存储用户信息

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// 认证服务类
/// 所有方法均为静态方法，无需实例化即可调用
class AuthService {
  /// 后端 API 基础 URL
  static const String _baseUrl = 'http://localhost:8080';

  /// HTTP 客户端实例（复用连接，提升性能）
  static final http.Client _client = http.Client();

  /// 用户登录
  /// [username] 用户名
  /// [password] 密码
  /// 返回登录结果 Map：包含 success（是否成功）、message（提示信息）、user（用户数据）
  static Future<Map<String,dynamic>> login(String username, String password) async{
    try {
      // 发送 POST 登录请求到后端
      var response = await _client.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('登录响应状态: ${response.statusCode}');
      print('响应头: ${response.headers}');

      // 解析响应 JSON 数据
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // 登录成功，将用户信息保存到本地存储
        await _saveUserInfo(data['data']);
        return {'success': true, 'message': '登录成功', 'user': data['data']};
      } else {
        // 登录失败，返回后端的错误信息
        return {'success': false, 'message': data['message'] ?? '登录失败'};
      }
    } catch (e) {
      // 网络异常或请求失败
      print('登录请求异常: $e');
      return {'success': false, 'message': '网络错误: $e'};
    }
  }

  /// 获取当前登录用户信息
  /// 通过 session/cookie 向后端请求当前用户数据
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      var response = await _client.get(
        Uri.parse('/api/auth/me'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return {'success': true, 'user': data['data']};
        }
      }
      // 未登录或会话过期
      return {'success': false, 'message': '用户未登录'};
    } catch (e) {
      return {'success': false, 'message': '网络错误: $e'};
    }
  }

  /// 用户登出
  /// 向后端发送登出请求，并清除本地存储的用户信息
  static Future<void> logout() async {
    try {
      await _client.post(Uri.parse('$_baseUrl/api/auth/logout'));
    } catch (e) {
      print('登出请求异常: $e');
    } finally {
      // 无论请求是否成功，都清除本地用户信息
      await _clearUserInfo();
    }
  }

  /// 将用户信息保存到本地存储（SharedPreferences）
  /// [userInfo] 用户信息 Map，序列化为 JSON 字符串存储
  static Future<void> _saveUserInfo(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_info', json.encode(userInfo));
  }

  /// 从本地存储获取用户信息
  /// 返回用户信息 Map，未登录时返回 null
  static Future<Map<String, dynamic>?> getLocalUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user_info');
    if (userString != null) {
      return json.decode(userString);
    }
    return null;
  }

  /// 清除本地存储的用户信息
  static Future<void> _clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_info');
  }

  /// 检查用户是否已登录
  /// 通过检查本地存储中是否存在 user_info 键来判断
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_info');
  }

  /// 用户注册
  /// [username] 用户名
  /// [email] 邮箱地址
  /// [password] 密码
  /// [confirmPassword] 确认密码
  /// [nickname] 昵称（可选，默认使用用户名）
  /// 返回注册结果 Map：包含 success、message、data
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    String? nickname,
  }) async {
    try {
      print('开始注册: $username, $email');

      // 发送 POST 注册请求到后端
      var response = await _client.post(
        Uri.parse('$_baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'nickname': nickname ?? username,  // 如果没有昵称，默认使用用户名
        }),
      );

      print('注册响应状态: ${response.statusCode}');
      print('注册响应体: ${response.body}');

      // 解析响应数据
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // 注册成功
        return {'success': true, 'message': '注册成功', 'data': data['data']};
      } else {
        // 注册失败，返回后端的错误信息
        return {'success': false, 'message': data['message'] ?? '注册失败'};
      }
    } catch (e) {
      // 网络异常或请求失败
      print('注册请求异常: $e');
      return {'success': false, 'message': '网络错误: $e'};
    }
  }
}
