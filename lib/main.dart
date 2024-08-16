import 'package:datafire/src/app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';
import 'package:flutter_acrylic/flutter_acrylic.dart';

const api_Key = "AIzaSyAlCIhMdJxrsAdt39Ie1eJv1ofa6feu2r4";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    await Window.initialize();
    await Window.setEffect(
        effect: WindowEffect.acrylic, dark: true, color: Colors.transparent);
    //config windows para vista inicial
    WindowOptions windowOptions = const WindowOptions(
        size: Size(1350, 850),
        center: true,
        windowButtonVisibility: false,
        backgroundColor: Colors.black,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.normal);

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  String? token = prefs.getString('token');
  runApp(MyApp(
    token: token,
  ));
}
