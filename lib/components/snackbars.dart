import 'package:flutter/material.dart';

class ShowMessage {
  static void show(BuildContext context,int type, String message) {
    late Color clr;
    late Color bg;

    switch (type) {
      case 200:
        bg = Colors.green;
        clr = Colors.white;
        break;
      case 300:
        bg = Colors.orange;
        clr = Colors.white;
        break;
      case 400:
        bg = Colors.red;
        clr = Colors.white;
        break;
      default:
        bg = Colors.black;
        clr = Colors.white;
    }
    
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text(message, style: TextStyle(fontFamily: "poppins", color: clr)),
      backgroundColor: bg,
    ));
  }

  static void close(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
