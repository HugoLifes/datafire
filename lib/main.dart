import 'package:datafire/src/app.dart';
import 'package:datafire/src/bloc/login_auth_bloc.dart';
import 'package:datafire/src/view/login/login_view.dart';
import 'package:datafire/src/view/login/new_login_view.dart';
import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

const api_Key = "AIzaSyAlCIhMdJxrsAdt39Ie1eJv1ofa6feu2r4";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
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

  String? token = prefs.getString('token');

  runApp(GlobalLoaderOverlay(
    overlayColor: Colors.grey.withOpacity(0.8),
    useDefaultLoading: false,
    overlayWidgetBuilder: (_) {
      //ignored progress for the moment
      return const Center(
        child: SpinKitRotatingCircle(
          color: Colors.blue,
          size: 50.0,
        ),
      );
    },
    child: BlocProvider(
      create: (context) => LoginBloc(),
      child: MaterialApp(
        theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            textTheme:
                TextTheme(displaySmall: TextStyle(color: materialPColor2))),
        debugShowCheckedModeBanner: false,
        initialRoute: token != null ? '/home' : '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => const MyApp(),
        },
      ),
    ),
  ));
}
