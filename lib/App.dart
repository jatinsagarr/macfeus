import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppData {
  static final ThemeData themeLight = ThemeData(
      primarySwatch: Colors.deepPurple,
      fontFamily: 'poppins',
      appBarTheme: const AppBarTheme(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: Color(0xFFf1f5f9))),
      iconTheme: const IconThemeData(color: Colors.deepPurple));

  static final ThemeData themeDark = ThemeData(
    primarySwatch: Colors.grey,
    fontFamily: 'poppins',
    appBarTheme: const AppBarTheme(centerTitle: true),
  );

  static Color backgroundColor(context) =>
      (Theme.of(context).brightness == Brightness.light)
          ? const Color(0xFFf1f5f9)
          : Colors.black;
}
