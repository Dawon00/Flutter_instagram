import 'package:flutter/material.dart';

var theme = ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
      color: Colors.white,
      elevation: 1,
      actionsIconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: TextTheme(bodyText2: TextStyle(color: Colors.black)));
