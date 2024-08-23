import 'package:flutter/material.dart';
import 'package:vi_light/service/web_socket_service.dart';
import 'package:vi_light/view/auto_view.dart';
import 'package:vi_light/view/manual_view.dart';
import 'package:vi_light/view/settings_view.dart';

class MainWrapper extends StatefulWidget {
  final int selectedIndex; // Add this parameter to initialize the selected tab
  const MainWrapper({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  WebSocketService? webSocketService;
  int _selectedIndex;  // Tracks the selected tab (Manual or Auto mode)
  String _response = '';   // Stores the response from WebSocket
  String connectionStatus = "Disconnected";

  _MainWrapperState() : _selectedIndex = 0; // Initialize with default value

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex; // Initialize selectedIndex with passed value
    webSocketService = WebSocketService('ws://192.168.100.83:81');
  }
  
  Widget _widgetOptions(int index) {
    switch (index) {
      case 0:
        return const ManualView();
      case 1:
        return const AutoView();
      default:
        return const ManualView();
    }
  }

  // Handle tab selection and WebSocket communication logic
  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    String message;
    switch (_selectedIndex) {
      case 1:  // Auto Mode
        message = "AutoMode";
        break;
      case 0:  // Manual Mode
        message = "ManualMode";
        break;
      default:
        message = "ManualMode"; // Default to Manual Mode if index is out of bounds
    }
    _response = await webSocketService!.sendMessage(message);
    print(_response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        title: const Text("VI Lights"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingRoute()),
              );
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _widgetOptions(_selectedIndex),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromARGB(10, 0, 48, 143),
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.touch_app_outlined),
            label: 'Manual Mode',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_mode),
            label: 'Auto Mode',
          ),
        ],
      ),
    );
  }
}
