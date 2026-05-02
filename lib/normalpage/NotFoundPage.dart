/// 404 页面
/// 当用户访问不存在的路由时显示此页面

import 'package:flutter/material.dart';
import 'package:web_of_edss/MyAppBar.dart';
import 'package:web_of_edss/MyBottomNavigationBar.dart';

/// 404 页面（无状态组件）
/// 显示 404 错误信息，包含顶部导航栏和底部信息栏
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

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
                    // 404 错误信息卡片
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(100),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          // 半透明白色背景
                          color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
                          child: SizedBox(
                            width: 2000,
                            height: 400,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 顶部透明分割线（用于间距）
                                Divider(
                                  color: Colors.transparent,
                                  height: 10,
                                ),
                                // 大号 404 文字
                                Center(
                                  child: SelectableText(
                                    "404",
                                    style: TextStyle(
                                      color: Color.fromARGB(170, 0, 0, 0),
                                      fontSize: 200,
                                    ),
                                  ),
                                ),
                                // "Not Found Page" 提示文字
                                Center(
                                  child: SelectableText(
                                    "Not Found Page",
                                    style: TextStyle(
                                      color: Color.fromARGB(170, 0, 0, 0),
                                      fontSize: 40,
                                    ),
                                  ),
                                ),
                              ],
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
}
