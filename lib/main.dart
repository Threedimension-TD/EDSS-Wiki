
/// 应用入口文件
/// 负责启动 Flutter 应用并配置路由系统

import 'package:dynamic_path_url_strategy/dynamic_path_url_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:web_of_edss/componets/WikiCard.dart';
import 'package:web_of_edss/normalpage/NormalCreatePage.dart';
import 'package:web_of_edss/normalpage/NotFoundPage.dart';
import 'package:web_of_edss/normalpage/PageTemplate.dart';
import 'package:web_of_edss/normalpage/UpdatePage.dart';
import 'package:web_of_edss/specialpage/CreatePage.dart';
import 'package:web_of_edss/specialpage/LoginPage.dart';
import 'package:web_of_edss/specialpage/RegisterPage.dart';
import 'MainPage.dart';

/// 应用入口函数
/// 设置 URL 策略为动态路径模式（去除 URL 中的 # 号），然后启动应用
void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

/// 应用根组件
/// 配置应用的主题、路由等全局设置
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(

      // 关闭调试模式下的各种标识和覆盖层
      debugShowCheckedModeBanner: false,  // 隐藏右上角 DEBUG 标签
      debugShowMaterialGrid: false,       // 隐藏调试网格
      showPerformanceOverlay: false,      // 隐藏性能覆盖层

      // 应用标题
      title: "永昼生存服务器 | Eternal Dawn Survival Server",

      // 应用主题配置
      theme: ThemeData(
        fontFamily: null,  // 使用默认字体

        // 基于种子色生成配色方案，主色调为蓝色
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 52, 194, 255),
          primary: Color(0xFF4A90E2),
          )
      ),

      // 初始路由为首页
      initialRoute: '/',

      /// 路由生成器
      /// 根据路由名称动态生成对应的页面路由
      onGenerateRoute: (settings) {
        final name = settings.name ?? '/';

        // 首页路由："/" -> MainPage
        if (name == '/') {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => MainPage(pageId: "主页",),
          );
        }

        // 创建页路由："/create" -> NormalCreatePage
        if (name == '/create') {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => NormalCreatePage(),
          );
        }

        // 登录页路由："/login" -> LoginPage
        if(name == '/login') {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => LoginPage()
            );
        }

        // 注册页路由："/register" -> RegisterPage
        if(name == '/register') {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => RegisterPage()
            );
        }

        // 更新日志页路由："/update" -> UpdatePage
        if(name == '/update') {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => UpdatePage()
            );
        }

        // Wiki 页面动态路由："/wiki/{pageId}" -> PageTemplate 包裹 WikiCard
        // 从 URL 中提取 pageId 参数，加载对应的 Wiki 页面内容
        if (name.startsWith('/wiki/')) {
          final pageId = name.replaceFirst('/wiki/', '');
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => PageTemplate(
              bodyContent: WikiCard(pageId: pageId),
            ),
          );
        }

        // 未匹配到任何路由时，显示 404 页面
        return MaterialPageRoute(
          builder: (_) => NotFoundPage(),
        );
      });
  }
}
