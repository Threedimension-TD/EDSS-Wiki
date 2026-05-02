/// Wiki 页面服务模块
/// 提供 Wiki 页面的 CRUD 操作（创建、读取、删除）
/// 通过 HTTP 请求与后端 API 交互

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Wiki 服务类
/// 封装所有与 Wiki 页面相关的后端 API 调用
class WikiService {
  /// 后端 Wiki API 的基础 URL
  static const String baseUrl = 'http://localhost:8080/api/wiki';

  /// 获取所有 Wiki 页面的 ID 列表
  /// 返回页面 ID 的字符串列表，用于导航菜单展示
  static Future<List<String>> getAllPageIds() async {
    final url = Uri.parse('$baseUrl/pages');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // 成功：将 JSON 数组解析为字符串列表
      return List<String>.from(jsonDecode(response.body));
    } else {
      throw Exception('加载页面列表失败');
    }
  }

  /// 创建新的 Wiki 页面
  /// [pageId] 新页面的 ID（页面名称）
  static Future<void> createPage(String pageId) async {
    final url = Uri.parse('$baseUrl');

    // 构建请求体
    final body = jsonEncode({
      'pageId': pageId,
    });

    // 发送 POST 请求创建页面
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    // 201 表示创建成功
    if (response.statusCode != 201) {
      throw Exception('页面创建失败：${response.body}');
    }
  }

  /// 删除指定的 Wiki 页面
  /// [pageId] 要删除的页面 ID
  static Future<void> deletePage(String pageId) async {
    final url = Uri.parse('$baseUrl/$pageId');

    // 发送 DELETE 请求删除页面
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // 200 或 204 均表示删除成功
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('删除页面失败：${response.body}');
    }
  }

  /// 获取指定 Wiki 页面的内容
  /// [pageId] 要获取的页面 ID
  /// 返回页面内容字符串（Markdown 格式）
  static Future<String> getPageContent(String pageId) async {
    final url = Uri.parse('$baseUrl/$pageId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // 请求成功，解析 JSON 并返回 content 字段
      final data = jsonDecode(response.body);
      return data['content'] ?? '';
    } else {
      // 请求失败，抛出异常
      throw Exception('加载页面失败：${response.body}');
    }
  }
}
