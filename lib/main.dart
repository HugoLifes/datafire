import 'package:datafire/src/app.dart';
import 'package:datafire/src/bloc/login_auth_bloc.dart';
import 'package:datafire/src/view/login/login_view.dart';
import 'package:datafire/src/view/login/new_login_view.dart';
import 'package:datafire/src/widgets/colors.dart';
import 'package:datafire/src/widgets/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';

const api_Key = "AIzaSyAlCIhMdJxrsAdt39Ie1eJv1ofa6feu2r4";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    //config windows para vista inicial
    WindowOptions windowOptions = const WindowOptions(
        size: Size(1350, 850),
        center: true,
        windowButtonVisibility: true,
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
