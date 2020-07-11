

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void myToast(String name) {
    Fluttertoast.showToast(
        msg: name,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 12.0);
  }