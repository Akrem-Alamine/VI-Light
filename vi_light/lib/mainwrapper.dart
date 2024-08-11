import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vi_light/view/auto_view.dart';
import 'package:vi_light/view/manual_view.dart';
import 'package:vi_light/view/settings_view.dart';

class Mainwrapper extends StatefulWidget {
  const Mainwrapper({super.key});

  @override
  State<Mainwrapper> createState() => _MainwrapperState();
}

class _MainwrapperState extends State<Mainwrapper> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        break;
      case 1:
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VI Lights"),
        actions: <Widget>[
          IconButton(
            onPressed: () { 
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingRoute()),
            );},
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            AutoView(),
            ManualView(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          _onItemTapped;
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.auto_mode),
            label: 'Auto Mode',
          ),
          NavigationDestination(
            icon: Icon(Icons.touch_app_outlined),
            label: 'Manual Mode',
          ),
        ],
      ),
    );
  }
}
