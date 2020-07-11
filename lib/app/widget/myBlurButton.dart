import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

myBlurButton(IconData icon, {void Function() onTap}) {
  var screenWidth = ScreenUtil.getInstance().screenWidth;
  var size = screenWidth / 10*1.2;
  return GestureDetector(
      onTap: onTap ?? () {},
      behavior: HitTestBehavior.translucent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
                alignment: Alignment.center,
                width: size,
                height: size,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(size / 2)),
                child: Icon(icon, size: size / 2, color: Colors.white))),
      ));
}
