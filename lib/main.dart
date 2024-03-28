import 'package:datafire/src/app.dart';
import 'package:datafire/src/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: token != null ? '/home' : '/login',
    routes: {
      '/login': (context) => const LoginView(),
      '/home': (context) => const MyApp(),
    },
  ));
}
