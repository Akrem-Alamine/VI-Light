import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vi_light/websocket_view.dart';
import 'firebase_options.dart';
enum MenuAction{reset,disconnectWifi}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VI Lights',
      theme: ThemeData.dark(),
      home: new WebSocketView(),
    ),);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool on = false;
  bool auto = true;
  bool reset = false;
  bool disconnectWifi = false;
  final dbR = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("VI Lights") ,
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async{
              switch (value){
              case MenuAction.reset:
                dbR.child("Menu").set({"Reset":true,"DisconnectWiFi":false});
 
                break;
              case MenuAction.disconnectWifi:
              dbR.child("Menu").set({"Reset":false,"DisconnectWiFi":true});

                break;
            }
          },
          itemBuilder: (context) {
            return const[
              const PopupMenuItem<MenuAction>(
                value: MenuAction.reset , 
                child: const Text("Reset")
              ),
              const PopupMenuItem<MenuAction>(
                value: MenuAction.disconnectWifi , 
                child: const Text("Disconnect WiFi")
              ),
            ];
          },)
        ],
      
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: auto?[
            on?const Icon(
              Icons.lightbulb,
              size: 170,
              color: Colors.amber,
            ):
            const Icon(
              Icons.lightbulb,
              size: 170,
              color: Colors.white,
            ),
            ElevatedButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                dbR.child("Light").set({"Switch":false,"ModeAuto":!auto});
                setState(() {
                  auto = !auto;
                  on = false;
                });
              }, 
              child: const Text('Manuelle'),
            ),
          ]:[
            on?const Icon(
              Icons.lightbulb,
              size: 170,
              color: Colors.amber,
            ):
            const Icon(
              Icons.lightbulb,
              size: 170,
              color: Colors.white,
            ),
            ElevatedButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                dbR.child("Light").set({"Switch":!on, "ModeAuto":auto});
                setState(() {
                  on = !on;
                });
              }, 
              child: on? const Text('Led Off'):const Text('Led On') ,
            ),
            ElevatedButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                dbR.child("Light").set({"Switch":false,"ModeAuto":!auto});
                setState(() {
                  auto = !auto;
                });
              }, 
              child: const Text('Automatique'),
            ),
          ],
        ),
      ),
    );
  }
}