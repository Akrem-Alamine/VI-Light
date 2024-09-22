import 'package:flutter/material.dart';
import 'package:vi_light/theme/theme_const.dart';
import 'package:vi_light/view/connect_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VI Lights',
      theme: lightTheme,
      home: const ConnectView(),
    ),
  );
}
