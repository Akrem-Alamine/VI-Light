import 'package:flutter/material.dart';
import 'package:vi_light/view/auto_view.dart';
import 'package:vi_light/view/manual_view.dart';

class AutoNav extends StatefulWidget {
  const AutoNav({super.key});

  @override
  State<AutoNav> createState() => _AutoNavState();
}

class _AutoNavState extends State<AutoNav> {
  GlobalKey<NavigatorState> autoNavigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: autoNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              if (settings.name == '') {
                return const ManualView();
              }
              return const AutoView();
            });
      },
    );
  }
}
