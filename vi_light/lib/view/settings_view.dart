import 'package:flutter/material.dart';

class SettingRoute extends StatefulWidget {
  const SettingRoute({super.key});

  @override
  State<SettingRoute> createState() => _SettingRouteState();
}

class _SettingRouteState extends State<SettingRoute> {
  bool _isSelected=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(

        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children :<Widget>[
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child:Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.portable_wifi_off, color: Color.fromARGB(255, 0, 48, 143),),
                    title: const Text("Disconnect"),
                    onTap: () {

                    },
                  
                  ),
                   ListTile(
                    leading: const Icon(Icons.restart_alt, color: Color.fromARGB(255, 0, 48, 143),),
                    title: const Text("Reset"),
                    onTap: () {
                      
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    activeColor:const Color.fromARGB(255,0,48,143),
                    title: const Text("Dark Mode"),
                    contentPadding: const EdgeInsets.fromLTRB(17, 0, 0, 0),
                    value: _isSelected, 
                    onChanged:(val){
                      setState(() {
                        _isSelected = !_isSelected;
                      });
                    },
                    secondary: _isSelected?const Icon(Icons.dark_mode, color: Color.fromARGB(255, 0, 48, 143)):const Icon(Icons.dark_mode_outlined, color: Color.fromARGB(255, 0, 48, 143)),
                    )
                ],
              )
            )
       
        ]
        ) 
      ),
    );
  }
}