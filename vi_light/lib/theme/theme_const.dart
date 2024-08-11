import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
  backgroundColor: Color.fromARGB(255, 0	, 48, 143),
  shadowColor: Colors.transparent,
  elevation: 0.0,
  centerTitle: false,
  scrolledUnderElevation: 10.0,
  toolbarHeight: 80.0,
  titleTextStyle: TextStyle(
      color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.normal),
// round corners
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
  ),
// icons button theme
  actionsIconTheme: IconThemeData(color: Colors.white, size: 32.0),
));
