import 'package:flutter/material.dart';
import 'package:todo/app/database/connection.dart';

class AdmConnection with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    var connection = Connection();
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        connection.closeConncetion();
        break;
      case AppLifecycleState.paused:
        connection.closeConncetion();
        break;
      case AppLifecycleState.detached:
        connection.closeConncetion();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}
