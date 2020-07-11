import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

import 'myBottomSheet.dart';
import 'myRoundButton.dart';
import 'myText.dart';
import 'myTextField.dart';

myBottomInput(context, {title = '请输入', hint = ':)', autoFocus = false}) async =>
    await Navigator.push(
        context,
        MyBottomSheet(
            child: BottomInput(
                title: title, hintText: hint, autoFocus: autoFocus)));

class BottomInput extends StatefulWidget {
  final String title;
  final String hintText;
  final bool autoFocus;

  BottomInput(
      {this.title = '请输入', this.hintText = ':)', this.autoFocus = false});

  @override
  _BottomInputState createState() => _BottomInputState();
}

class _BottomInputState extends State<BottomInput> {
  String myTxt;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Column(
        children: <Widget>[
          Expanded(
              child: GestureDetector(
            child: Container(
              color: Colors.transparent,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )),
          myRadiusBottom(context),
        ],
      ),
    );
  }

  myRadiusBottom(context, {double height}) {
    if (height == null) height = ScreenUtil.getInstance().screenWidth / 20 * 12;
    double radius = height / 12 * 1.5;
    return Container(
        //弹窗布局
        width: double.infinity,
        height: height, //弹窗高度不能超过屏幕的一半！！！
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(radius),
                topEnd: Radius.circular(radius))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            myText(widget.title, size: height / 12 * 1),
            mySearchBox(context,
                hintText: widget.hintText, height: height / 12 * 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                myRoundButton('取 消', onTap: () {
                  Navigator.pop(context); //传回空值
                }, height: height / 12 * 3, colorBack: const Color(0xFFf4f5fa)),
                myRoundButton('确 定', onTap: () {
                  Navigator.pop(context, myTxt); //传回输入值
                },
                    height: height / 12 * 3,
                    colorText: Colors.lightBlue,
                    colorBack: const Color(0xFFf4f5fa)),
              ],
            )
          ],
        ));
  }

  mySearchBox(context, {String hintText, double height}) {
    //底部搜索框
    return MyTextField(
      autofocus: widget.autoFocus,
      height: height,
      hintText: hintText,
      onSubmit: (txt) {
        Navigator.pop(context, txt); //传回输入值
      },
      onChanged: (txt) {
        myTxt = txt; //传回输入值
      },
    );
  }
}
