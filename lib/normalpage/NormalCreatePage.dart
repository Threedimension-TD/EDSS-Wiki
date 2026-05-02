/// 普通创建页面
/// 包裹 CreatePage 组件，使用 PageTemplate 提供统一的页面布局

import 'package:flutter/material.dart';
import 'package:web_of_edss/normalpage/PageTemplate.dart';
import 'package:web_of_edss/specialpage/CreatePage.dart';

/// 创建页面的包装组件（无状态组件）
/// 使用页面模板作为外层容器，内部嵌入 CreatePage 表单
class NormalCreatePage extends StatelessWidget{
  NormalCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用页面模板包裹创建页面组件
    return PageTemplate(
      bodyContent: SizedBox(
        child: CreatePage()
      )
    );
  }
}
