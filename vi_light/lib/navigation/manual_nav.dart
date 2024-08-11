import 'package:flutter/material.dart';
import 'package:vi_light/view/auto_view.dart';
import 'package:vi_light/view/manual_view.dart';

class ManualNav extends StatefulWidget {
  const ManualNav({super.key});

  @override
  State<ManualNav> createState() => _ManualNavState();
}

class _ManualNavState extends State<ManualNav> {
  GlobalKey<NavigatorState> manualnavigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: manualnavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (context) {
              if (settings.name == '') {
                return const AutoView();
              }
              return const ManualView();
            });
      },
    );
  }
}