// ignore: file_names
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
  final TextEditingController _ipController = TextEditingController();
  String _ipAddress = '';

  void _connect() async {
    setState(() {
      _isConnecting = true;
    });

    // Set a timeout for the connection attempt
    Future.delayed(const Duration(seconds: 10), () {
      if (_isConnecting) {
        setState(() {
          _isConnecting = false;
        });
        _showConnectionErrorDialog();
      }
    });

    final serverUrl = 'ws://$_ipAddress:81';
    final webSocketService = WebSocketService(serverUrl);

    try {
      // Attempt to connect and send a ping message
      final response = await webSocketService.sendMessage('ping');
      // ignore: avoid_print
      print(response);
      // Navigate to the MainWrapper based on response
      if (response.contains('Mode: Auto')) {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const MainWrapper(selectedIndex: 1),
          ),
        );
      } else if (response.contains('Mode: Manual')) {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const MainWrapper(selectedIndex: 0),
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
        _showConnectionErrorDialog();
      });
    }
  }

  void _showConnectionErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connection Failed'),
          content: const Text(
              'Unable to connect to the WebSocket server. Please check the IP address and try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect to WebSocket'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome to the VI Lights App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple, // Custom color for the text
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // IP Address Input Field
              TextField(
                controller: _ipController,
                decoration: const InputDecoration(
                  labelText: 'Enter ESP IP Address',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _ipAddress = value;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isConnecting ? null : _connect,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.deepPurple, // Custom button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  elevation: 5, // Shadow for the button
                ),
                child: _isConnecting
                    ? const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Connect',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Button text color
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }
}
