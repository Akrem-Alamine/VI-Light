import 'package:flutter/material.dart';

class ManualView extends StatefulWidget {
  const ManualView({super.key});

  @override
  State<ManualView> createState() => _ManualViewState();
}

class _ManualViewState extends State<ManualView> {
  bool on = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor:Color.fromARGB(255, 0	, 48, 143),
                foregroundColor:Colors.white),
              onPressed: () {
                setState(() {
                  on = !on;
                });
              }, 
              child: on? const Text('Led Off'):const Text('Led On') ,
            ),
        ],
      ),
      )
    );
  }
}