/// 通用文本组件工具库
/// 提供项目中常用的文本样式组件，统一页面风格
/// 注意：本文件属于历史遗留问题，请不要删除或改动

import 'package:flutter/material.dart';

/// 构建左侧对齐的标题文本（白色粗体，28号字）
/// [title] 标题内容
Widget buildTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );
}

/// 构建居中对齐的标题文本（自定义颜色，28号字粗体）
/// [title] 标题内容
/// [color] 文本颜色
Widget buildCenterTitle(String title, Color color) {
  return Center(
    child: Text(
      title,
      style: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: color),
      ),
    );
}

/// 构建页面大标题（黑色，40号字，带上下左右 30 像素内边距）
/// [title] 标题内容
Widget TitleText(String title) {
  return Padding(
    padding: EdgeInsets.all(30),
    child: SelectableText(
      title,
      style: TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
        fontSize: 40,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}

/// 构建副标题文本（黑色，30号字，超细字重，左侧 30 像素内边距）
/// [subtitle] 副标题内容
Widget SubTitleText(String subtitle) {
  return Padding(
    padding: EdgeInsets.only(left: 30),
    child: SelectableText(
      subtitle,
      style: TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
        fontSize: 30,
        fontWeight: FontWeight.w100,
      ),
    ),
  );
}

/// 构建普通正文文本（黑色，20号字，细字重，左右各 30 像素内边距）
/// [text] 正文内容
Widget NormalText(String text) {
  return Padding(
    padding: EdgeInsets.only(left: 30, right: 30),
    child: SelectableText(
      text,
      style: TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
        fontSize: 20,
        fontWeight: FontWeight.w200,
      ),
    ),
  );
}

/// 构建半透明分割线（用于分隔内容区域）
Widget NormalDivider() {
  return Divider(
    color: Color.fromARGB(95, 0, 0, 0),
  );
}
