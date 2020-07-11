import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

import 'myBottomSheet.dart';
import 'myRoundButton.dart';

myBottomTip(context, {String title, String desp}) async => await Navigator.push(
    context, MyBottomSheet(child: MyBottomTip(title, desp)));

class MyBottomTip extends StatefulWidget {
  final String title, desp;
  MyBottomTip(this.title, this.desp);
  @override
  _MyBottomTipState createState() => _MyBottomTipState();
}

class _MyBottomTipState extends State<MyBottomTip> {
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
            myBottomTipLayout(context),
          ],
        ));
  }

  myBottomTipLayout(context) {
    double radius = ScreenUtil.getInstance().screenWidth / 20 * 1.5;
    return Container(
        //弹窗布局
        width: ScreenUtil.getInstance().screenWidth,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(radius),
                topEnd: Radius.circular(radius))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [ 
            myHead(radius),
            Container(
              padding: EdgeInsets.only(
                  left: radius, right: radius, bottom: radius, top: radius / 2),
              child: Text(
                widget.desp,
                maxLines: 20,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
            )
          ],
        ));
  }

  myHead(radius) => Container(
        padding: EdgeInsets.only(
            left: radius / 2, right: radius / 2, top: radius / 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            myRoundButton('',
                colorBack: Colors.transparent,
                width: ScreenUtil.getInstance().screenWidth / 20 * 2,
                height: ScreenUtil.getInstance().screenWidth / 20 * 2),
            Text(
              widget.title,
              maxLines: 10,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            myRoundButton('',
                width: ScreenUtil.getInstance().screenWidth / 20 * 2,
                height: ScreenUtil.getInstance().screenWidth / 20 * 2,
                icon: Icons.close,
                colorBack: const Color(0xFFf4f5fa), onTap: () {
              Navigator.pop(context);
            })
          ],
        ),
      );
}
 