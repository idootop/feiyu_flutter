import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final Null Function(String) onSubmit;
  final Null Function(String) onChanged;
  final Function() focused;
  final Function() nofocus;
  final String hintText;
  final String value;
  final double height;
  final double width;
  final Color colorText;
  final Color colorBack;
  final bool autofocus;
  final TextAlign textAlign;
  final TextEditingController controller;

  MyTextField(
      {this.onSubmit,
      this.onChanged,
      this.focused,
      this.nofocus,
      this.hintText = '请输入...',
      this.height,
      this.width,
      this.textAlign = TextAlign.center,
      this.colorBack = const Color(0xFFf4f5fa),
      this.colorText = const Color(0xFFa8b3cf),
      this.autofocus = false,
      this.value,
      this.controller});

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  double height;
  double width;
  TextEditingController controller = TextEditingController();
  bool isFocused = false;
  FocusNode focusNode = FocusNode();
  bool firstBuild = true;
  String nowValue;

  @override
  void initState() {
    super.initState();
    height = widget.height ?? ScreenUtil.getInstance().screenWidth/20 * 3;
    width = widget.width ?? ScreenUtil.getInstance().screenWidth - ScreenUtil.getInstance().screenWidth/20 * 2;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isFocused = true;
        if (widget.focused != null) widget.focused();
        print('聚焦');
        setState(() {});
      } else {
        isFocused = false;
        print('失焦');
        if (widget.nofocus != null) widget.nofocus();
        setState(() {});
      }
    });
    if (widget.controller == null && widget.value != null) {
      controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    // widget.controller?.dispose();
    controller?.dispose(); 
    focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: widget.colorBack,
        borderRadius: BorderRadius.all(Radius.circular(height / 2)),
      ),
      padding: EdgeInsets.symmetric(horizontal: height / 2),
      child: TextField(
        controller: widget.controller ?? controller,
        textAlign: widget.textAlign ?? TextAlign.center, //文字居中
        autofocus: widget.autofocus, //自动打开软键盘
        focusNode: focusNode,
        onChanged: widget.onChanged ??
            (String txt) async {
              print(txt);
            },
        onSubmitted: widget.onSubmit ??
            (String txt) async {
              print(txt);
            },
        keyboardType: TextInputType.text,
        obscureText: false, //是否输入密码
        textInputAction: TextInputAction.done, //完成
        style: TextStyle(
            //输入文字样式，决定光标的高度
            fontSize: height / 3,
            fontWeight: FontWeight.w500,
            color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none, //无边框
          hintText: isFocused ? '' : widget.hintText,
          hintStyle: TextStyle(
              fontSize: height / 3,
              fontWeight: FontWeight.w400,
              color: widget.colorText),
        ),
        //光标颜色
        cursorColor: Colors.black,
      ),
    );
  }
}
