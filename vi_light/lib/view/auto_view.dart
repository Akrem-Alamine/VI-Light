import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vi_light/service/web_socket_service.dart';

class AutoView extends StatefulWidget {
  const AutoView({super.key});

  @override
  State<AutoView> createState() => _AutoViewState();
}

class _AutoViewState extends State<AutoView> {
  bool light = false;
  late WebSocketService webSocketService;
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    webSocketService = WebSocketService('ws://192.168.100.83:81');
    _listenToWebSocket();
    _startStatusTimer();
  }

  void _listenToWebSocket() {
    webSocketService.messages.listen((message) {
      setState(() {
        light = message.contains("lightON");
        print(message);
      });
    }, onError: (error) {
      print('Error listening to WebSocket: $error');
    });
  }

  void _startStatusTimer() {
    _statusTimer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      _sendStatusRequest();
    });
  }

  Future<void> _sendStatusRequest() async {
    try {
      await webSocketService.sendMessage("AutoMode");
    } catch (error) {
      print('Error sending status request: $error');
    }
  }

  @override
  void dispose() {
    _statusTimer?.cancel(); // Cancel the timer when disposing
    webSocketService.dispose(); // Close the WebSocket connection when disposing
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
