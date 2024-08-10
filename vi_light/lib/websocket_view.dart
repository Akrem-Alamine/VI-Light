// lib/websocket_view.dart
import 'package:flutter/material.dart';
import 'web_socket_service.dart';

class WebSocketView extends StatefulWidget {
  @override
  _WebSocketViewState createState() => _WebSocketViewState();
}

class _WebSocketViewState extends State<WebSocketView> {
  final webSocketService = WebSocketService('ws://192.168.206.50:81'); // Adjust the IP and port accordingly
  String _response = '';

  @override
  void initState() {
    super.initState();
    webSocketService.stream.listen((message) {
      setState(() {
        _response = message;
      });
    });
  }

  void _sendWebSocketMessage() {
    webSocketService.send('Hello from Taher!');
  }

  @override
  void dispose() {
    webSocketService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Communication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _sendWebSocketMessage,
              child: Text('Send WebSocket Message'),
            ),
            SizedBox(height: 20),
            Text('Response: $_response'),
          ],
        ),
      ),
    );
  }
}
