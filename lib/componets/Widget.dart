import 'package:flutter/material.dart';

//本文件属于是历史遗留问题，请不要删除或改动
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

Widget buildCenterTitle(String title,Color color) {
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

Widget TitleText(String title) {
  return Padding(padding: EdgeInsets.all(30),
                child: SelectableText(title,style: TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontSize:40,fontWeight: FontWeight.normal),),
  );
}

Widget SubTitleText(String subtitle) {
  return Padding(padding: EdgeInsets.only(left: 30),
  child: SelectableText(subtitle,style: TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontSize: 30,fontWeight: FontWeight.w100),),
  );
}

Widget NormalText(String text) {
  return Padding(padding: EdgeInsets.only(left: 30,right: 30),
  child: SelectableText(text,style: TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontSize: 20,fontWeight: FontWeight.w200)),
  );
}

Widget NormalDivider() {
  return  Divider(
  color: Color.fromARGB(95, 0, 0, 0),
  );
}
