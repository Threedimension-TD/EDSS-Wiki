/// 底部信息栏组件
/// 展示开发团队信息和服务器 QQ 群号，作为页脚使用

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

/// 底部信息栏（无状态组件）
/// 包含 Logo、开发人员列表和 QQ 群信息
class MyBottomBavigationBar extends StatelessWidget {
  const MyBottomBavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240, // 固定高度 240 像素
      width: double.infinity, // 宽度撑满父容器
      decoration: BoxDecoration(
        color: Colors.black, // 黑色背景
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      child: Stack(
        children: [
          // 居中显示的 Logo 图片
          Center(child: Image.asset("assets/images/logo.png")),

          // "开发人员" 标题文字
          Padding(
            padding: EdgeInsets.only(left: 43, top: 10),
            child: SelectableText(
              "开发人员",
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),

          // 开发人员 1：作者 Threedimension
          Padding(
            padding: EdgeInsets.only(left: 30, top: 25),
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/images/Author.png"),
              ),
              title: SelectableText(
                "作者：Threedimension",
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              subtitle: SelectableText(
                "联系我们：535061705@qq.com",
                style: TextStyle(
                  color: const Color.fromARGB(255, 100, 100, 100),
                ),
              ),
            ),
          ),

          // 开发人员 2：主要设计 Trappist-1c
          Padding(
            padding: EdgeInsets.only(left: 30, top: 95),
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/images/Tr1c.png"),
              ),
              title: SelectableText(
                "主要设计：Trappist-1c",
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              subtitle: SelectableText(
                "一只可爱的小1c",
                style: TextStyle(
                  color: const Color.fromARGB(255, 100, 100, 100),
                ),
              ),
            ),
          ),

          // 开发人员 3：素材提供 洛雨稠Netflight
          Padding(
            padding: EdgeInsets.only(left: 30, top: 165),
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/images/noneuwu.jpg"),
              ),
              title: SelectableText(
                "素材提供：NoneUwU",
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              subtitle: SelectableText(
                "一只并不可爱的小None",
                style: TextStyle(
                  color: const Color.fromARGB(255, 100, 100, 100),
                ),
              ),
            ),
          ),

          // QQ 群邀请信息（固定定位在右侧）
          Positioned(
            top: 50,
            left: 1200,
            child: Text('''加入服务器：QQ群742834377

永昼生存服务器随时欢迎您的到来！
            ''', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
