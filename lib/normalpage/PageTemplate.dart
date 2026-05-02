/// 页面模板组件
/// 为所有页面提供统一的布局结构：顶部导航栏 + 背景图片 + 内容区域 + 底部信息栏

import 'package:flutter/material.dart';
import 'package:web_of_edss/MyAppBar.dart';
import 'package:web_of_edss/MyBottomNavigationBar.dart';

/// 页面模板（无状态组件）
/// 作为所有页面的通用模板，接收 bodyContent 作为页面主体内容
class PageTemplate extends StatelessWidget {
  /// 页面主体内容组件
  final Widget bodyContent;

  /// 背景图片路径，默认使用 background.png
  final String backgroundImage;

  /// 内容卡片宽度，默认 2000 像素
  final double cardWidth;

  /// 文本编辑控制器（用于页面导航中的输入功能）
  final TextEditingController _controller = TextEditingController();

  /// 构造函数
  /// [bodyContent] 必传参数，页面的主要内容
  /// [backgroundImage] 可选参数，自定义背景图片路径
  /// [cardWidth] 可选参数，内容区域宽度
  PageTemplate({
    Key? key,
    required this.bodyContent,
    this.backgroundImage = "assets/images/background.png",
    this.cardWidth = 2000,
  }) : super(key: key);

  /// 创建新页面并跳转
  /// 从输入框获取页面名称，不为空则导航到对应页面
  void _createNewPage(BuildContext context) {
    String pageId = _controller.text.trim();
    if (pageId.isNotEmpty) {
      Navigator.pushNamed(context, '/page/$pageId');
    }
  }

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
            image: AssetImage(backgroundImage),
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
                    // 内容区域：居中显示，带 100 像素内边距
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(100),
                        child: Container(
                          width: cardWidth,
                          child: bodyContent,  // 传入的主体内容
                        ),
                      ),
                    ),
                    // 底部信息栏，顶部留 50 像素间距
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      child: MyBottomBavigationBar(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
