import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

Widget myText(String txt,
    {FontWeight big = FontWeight.w400,
    Color color = Colors.black,
    double size = 16,
    double lSpace = 1,
    double wSpace = 1,
    TextOverflow overflow = TextOverflow.ellipsis}) {
  return Text(txt,
      overflow: overflow,
      style: TextStyle(
        letterSpacing: lSpace,
        wordSpacing: wSpace,
        fontSize: size,
        color: color,
        fontWeight: big,
        decoration: TextDecoration.none, //禁用字体下划线
      ));
}

  Widget myLable(String lable) {
    return Row(
      children: <Widget>[
        SizedBox(width: ScreenUtil.getInstance().screenWidth / 20),
        Icon(
          Icons.label,
          color: Colors.yellow,
        ),
        SizedBox(width: ScreenUtil.getInstance().screenWidth / 20),
        myText(lable, color: Colors.black, size: 18, big: FontWeight.bold)
      ],
    );
  }

