/// 更新日志页面
/// 展示网站的版本更新历史记录

import 'package:flutter/material.dart';
import 'package:web_of_edss/MyAppBar.dart';
import 'package:web_of_edss/MyBottomNavigationBar.dart';
import 'package:web_of_edss/componets/Widget.dart';

/// 更新日志页面（无状态组件）
/// 以卡片形式展示各版本的更新内容
class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

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
                    // 更新日志内容卡片
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
                            height: 600,  // 注意：需根据不同文本长度进行调整
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 页面标题："更新日志"
                                // 文本样式说明：普通文本统一 Padding:left 30，标题 Padding:all 30
                                Padding(
                                  padding: EdgeInsets.all(30),
                                  child: SelectableText(
                                    "更新日志",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 52,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),

                                // "最新更新" 子标题
                                Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: SelectableText(
                                    '''最新更新''',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 36,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Text(""),

                                // 最新版本号
                                Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: SelectableText(
                                    "v26.2.10",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 30,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),

                                // 最新版本更新内容
                                NormalText('''新增了删除页面功能

修复了一些已知问题并且解决了一些捣乱的用户'''),
                                Text(""),

                                // "历史更新" 子标题
                                Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: SelectableText(
                                    "历史更新",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 36,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                ),
                                Text(""),

                                // 历史版本 v26.2.6
                                SubTitleText("v26.2.6"),
                                NormalText("EDSSWiki正式上线（？）")
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
