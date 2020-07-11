import 'package:flutter/material.dart';

class MyBottomSheet extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  MyBottomSheet({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}


