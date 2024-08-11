import 'package:flutter/material.dart';
import '../service/web_socket_service.dart';

class WebSocketView extends StatefulWidget {
  @override
  _WebSocketViewState createState() => _WebSocketViewState();
}

class _WebSocketViewState extends State<WebSocketView> {
  final webSocketService = WebSocketService('ws://192.168.100.83:81');
  String _response = '';
  bool lightOn = false;

  @override
  void initState() {
    super.initState();
    webSocketService.stream.listen((message) {
      setState(() {
        _response = message;
        lightOn = message.contains("Light On"); // Example condition to control the light state
      });
    });
  }

  void _sendWebSocketMessage() {
    webSocketService.send('Toggle Light');
    setState(() {
      lightOn = !lightOn;
    });
  }

  void _resetWiFi() {
    webSocketService.send('Reset WiFi');
  }

  void _disconnectWiFi() {
    webSocketService.send('Disconnect WiFi');
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
        title: const Text("VI Lights"),
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.reset:
                  _resetWiFi();
                  break;
                case MenuAction.disconnectWifi:
                  _disconnectWiFi();
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.reset,
                  child: Text("Reset"),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.disconnectWifi,
                  child: Text("Disconnect WiFi"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            lightOn
                ? const Icon(
                    Icons.lightbulb,
                    size: 170,
                    color: Colors.amber,
                  )
                : const Icon(
                    Icons.lightbulb,
                    size: 170,
                    color: Colors.white,
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              onPressed: _sendWebSocketMessage,
              child: lightOn ? const Text('Turn Off') : const Text('Turn On'),
            ),
            const SizedBox(height: 20),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Connection State',
                hintText: _response.isEmpty ? 'No response yet' : _response,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum MenuAction { reset, disconnectWifi }
