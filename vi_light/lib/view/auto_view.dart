import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';
import 'package:flutter/material.dart';

class AutoView extends StatefulWidget {
  const AutoView({super.key});

  @override
  State<AutoView> createState() => _AutoViewState();
}

class _AutoViewState extends State<AutoView> {
  late SunriseSunsetResult sunriseSunset;
  late bool light;

  @override
  void initState() {
    super.initState();
    sunriseSunset = getSunriseSunset(36.8065, 10.1815, Duration(hours: 1), DateTime.now());
    light = DateTime.now().isBefore(DateTime.parse(sunriseSunset.sunrise.toString())) || DateTime.now().isAfter(DateTime.parse(sunriseSunset.sunset.toString())) ;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            light
                ? const Icon(
                    Icons.lightbulb,
                    size: 170,
                    color: Colors.amber,
                  )
                : const Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 170,
                    color: Color.fromARGB(255, 0, 48, 143),
                  ),
          ],
        ),
      ),
    );
  }
}
