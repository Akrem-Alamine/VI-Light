import 'package:flutter/material.dart';
import 'package:vi_light/service/web_socket_service.dart';
import 'package:vi_light/view/main_wrapper.dart';

class ConnectView extends StatefulWidget {
  const ConnectView({super.key});

  @override
  State<ConnectView> createState() => _ConnectViewState();
}

class _ConnectViewState extends State<ConnectView> {
  bool _isConnecting = false;

  void _connect() async {
    setState(() {
      _isConnecting = true;
    });

    final serverUrl = 'ws://192.168.100.83:81';
    final webSocketService = WebSocketService(serverUrl);

    try {
      // Attempt to connect and send a ping message
      final response = await webSocketService.sendMessage('ping');
      print(response);
      // Navigate to the MainWrapper based on response
      if (response.contains('Mode: Auto')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainWrapper(selectedIndex: 1),
          ),
        );
      } else if (response.contains('Mode: Manual')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainWrapper(selectedIndex: 0),
          ),
        );
      } else {
        // Handle unexpected response
        setState(() {
          _isConnecting = false;
          // Optionally show an error message or handle unexpected responses
        });
      }
    } catch (e) {
      setState(() {
        _isConnecting = false;
        // Optionally handle errors here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect to WebSocket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the VI Lights App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isConnecting ? null : _connect,
              child: _isConnecting
                  ? const CircularProgressIndicator()
                  : const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }
}
