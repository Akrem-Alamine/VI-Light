
import 'package:flutter/material.dart';
import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';
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
  String sunriseSunset = getSunriseSunset(36.75869, 10.2042388, Duration(hours: 1), DateTime.now()).toString();
   var sunrise = DateTime.parse('${DateTime.now().toString().substring(0,10)} ${sunriseSunset.substring(20,28)}');
   var sunset = DateTime.parse('${DateTime.now().toString().substring(0,10)} ${sunriseSunset.substring(54,62)}');
   var timeNow = DateTime.parse('${DateTime.now().toString().substring(0,19)}');
   print(timeNow.isBefore(sunrise) || sunset.isBefore(timeNow));
  
}