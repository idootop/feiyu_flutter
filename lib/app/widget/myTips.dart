import 'package:flutter/material.dart';

//弹窗-->消息提示

Future myTips(context, title, words) async {
  return showDialog(
    context: context,
    child: new AlertDialog(
      title: Text(title,style: TextStyle(color: Colors.red),),
      content: Text(words),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("确定",style: TextStyle(color: Colors.blue))),
      ],
    ));
}
