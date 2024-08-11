import 'package:flutter/material.dart';


class AutoView extends StatefulWidget {
  const AutoView({super.key});

  @override
  State<AutoView> createState() => _AutoViewState();
}

class _AutoViewState extends State<AutoView> {
  bool on = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            on?const Icon(
              Icons.lightbulb,
              size: 170,
              color: Colors.amber,
            ):
            const Icon(
              Icons.lightbulb_outline_rounded,
              size: 170,
              color: Color.fromARGB(255, 0	, 48, 143),
            ),
          ]
        ),
      ),
    );
  }

}