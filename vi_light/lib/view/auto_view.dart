import 'package:flutter/material.dart';
import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';

class AutoView extends StatefulWidget {
  const AutoView({super.key});

  @override
  State<AutoView> createState() => _AutoViewState();
}

class _AutoViewState extends State<AutoView> {
  @override
  Widget build(BuildContext context) {
    String sunriseSunset = getSunriseSunset(
            36.75869, 10.2042388, Duration(hours: 1), DateTime.now())
        .toString();
    var sunrise = DateTime.parse(
        '${DateTime.now().toString().substring(0, 10)} ${sunriseSunset.substring(20, 28)}');
    var sunset = DateTime.parse(
        '${DateTime.now().toString().substring(0, 10)} ${sunriseSunset.substring(54, 62)}');
    var timeNow =
        DateTime.parse('${DateTime.now().toString().substring(0, 19)}');
    bool on = timeNow.isBefore(sunrise) || sunset.isBefore(timeNow);
    return Scaffold(
      backgroundColor: Colors.white,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            on
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
          ]),
        ),
    );
  }
}

class BarIndicator extends StatelessWidget {
  const BarIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        width: 40,
        height: 3,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 48, 143),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
