import 'package:flutter/material.dart';
import 'myText.dart';

myRoundButton(String txt,
    {IconData icon,
    void Function() onTap,
    double height = 60,
    double size,
    double width,
    double radius,
    Color colorText = Colors.black,
    Color colorBack = const Color(0xFFf4f5fa)}) {
  return GestureDetector(
    onTap: onTap ??
        () {
          print('点击了$txt');
        },
    child: Container(
        //弹窗布局
        width: width ?? height * 2 / 0.7,
        height: height,
        decoration: BoxDecoration(
            color: colorBack,
            borderRadius: BorderRadiusDirectional.all(
                Radius.circular(radius ?? height / 2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon != null
                ? Icon(icon, color: colorText, size: size ?? height / 3)
                : SizedBox(width: 0, height: 0),
            myText(txt, color: colorText, size: size ?? height / 3),
          ],
        )),
  );
}

myRoundText(String txt,
    {IconData icon,
    void Function() onTap,
    double height = 60,
    double width,
    double radius,
    double size,
    Color colorText = Colors.black,
    Color colorBack = Colors.white,
    List<Color> gradient}) {
  return GestureDetector(
    onTap: onTap ??
        () {
          print('点击了$txt');
        },
    child: Container(
      //弹窗布局
      width: width ?? height * 2 / 0.7,
      height: height,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: radius ?? height / 2),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient ?? [colorBack, colorBack],
          ),
          borderRadius: BorderRadiusDirectional.all(
              Radius.circular(radius ?? height / 2))),
      child: myText(txt, color: colorText, size: size ?? height / 3),
    ),
  );
}

myIcon(IconData icon,
    {void Function() onTap,
    double sizeBack = 40,
    double sizeIcon = 20,
    Color colorIcon = Colors.black,
    Color colorBack = Colors.transparent}) {
  return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap ?? () {},
      child: Container(
        width: sizeBack,
        height: sizeBack,
        decoration: BoxDecoration(
            color: colorBack,
            borderRadius:
                BorderRadiusDirectional.all(Radius.circular(sizeBack / 2))),
        child: Icon(
          icon,
          size: sizeIcon,
          color: colorIcon,
        ),
      ));
}
