import 'package:flutter/material.dart';
import '../service/web_socket_service.dart';

class ManualView extends StatefulWidget {
  const ManualView({super.key});

  @override
  State<ManualView> createState() => _ManualViewState();
}

class _ManualViewState extends State<ManualView> {
  bool light = false;
  late WebSocketService webSocketService;

  @override
  void initState() {
    super.initState();
    // Initialize WebSocket service and connect
    webSocketService = WebSocketService('ws://192.168.100.83:81');
    
    // Send initial message to get the status of the light
    
    
    // Listen to WebSocket messages
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
            Icon(
              light ? Icons.lightbulb : Icons.lightbulb_outline_rounded,
              size: 170,
              color: light ? Colors.amber : const Color.fromARGB(255, 0, 48, 143),
            ),
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 48, 143),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  light = !light;
                });
              },
              child: Text(light ? 'Led Off' : 'Led On'),
            ),
          ],
        ),
      ),
    );
  }
}
