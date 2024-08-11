import 'package:flutter/material.dart';
import 'package:vi_light/mainwrapper.dart';
import 'package:vi_light/theme/theme_const.dart';

enum MenuAction { reset, disconnectWifi }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VI Lights',
      theme: lightTheme,
      home: new Mainwrapper(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const Banner(
        message: "test", 
        location: BannerLocation.bottomStart,
        child: Scaffold(),
      ),
    );
  }
}
