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
    webSocketService = WebSocketService('ws://192.168.100.83:81');
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
                setState((){
                  light = !light;
                });
                if (light){
                    webSocketService.sendMessage('LightOn');
                  }
                else{
                    webSocketService.sendMessage('LightOff');
                }
              },
              child: Text(light ? 'Led Off' : 'Led On'),
            ),
          ],
        ),
      ),
    );
  }
}
