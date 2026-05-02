/// 主页面组件
/// 作为应用首页，展示指定 pageId 的 Wiki 内容

import 'package:flutter/material.dart';
import 'package:web_of_edss/componets/Widget.dart';
import 'package:web_of_edss/componets/WikiCard.dart';
import 'package:web_of_edss/normalpage/PageTemplate.dart';

/// 主页面（无状态组件）
/// 使用 PageTemplate 作为页面模板，内部嵌入 WikiCard 展示 Wiki 内容
class MainPage extends StatelessWidget{
  /// 构造函数，接收 pageId 参数用于指定要展示的 Wiki 页面
  const MainPage({super.key,required this.pageId});

  /// 要展示的 Wiki 页面 ID
  final String pageId;

  @override
  Widget build(BuildContext context) {
    // 使用页面模板包裹 Wiki 卡片组件
    return PageTemplate(
      bodyContent: WikiCard(
        pageId: pageId,
      )
    );
  }
}
