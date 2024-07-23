import 'package:datafire/src/bloc/login_auth_bloc.dart';
import 'package:datafire/src/view/finances/financesView.dart';
import 'package:datafire/src/view/geminiChat/geminiChatView.dart';
import 'package:datafire/src/view/home.dart';
import 'package:datafire/src/view/login/new_login_view.dart';
import 'package:datafire/src/view/motherView.dart';
import 'package:datafire/src/widgets/side_bar.dart';
import 'package:datafire/src/widgets/theme.dart';
import 'package:datafire/src/widgets/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
import 'dart:io';

class MyApp extends StatelessWidget {
  dynamic token;
  MyApp({this.token});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(context, "GoogleSans", "GoogleSans");
    MaterialTheme theme = MaterialTheme(textTheme);
    return GlobalLoaderOverlay(
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
        create: (context) {
          return LoginBloc();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: brightness == Brightness.light ? theme.light() : theme.dark(),
          initialRoute: token != null ? '/home' : '/login',
          routes: {
            '/login': (context) => LoginScreen(),
            '/home': (context) => const MainView(),
          },
        ),
      ),
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  // This widget is the root of your application.
  final _controller = SidebarXController(selectedIndex: 0);
  int _selectIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Home(),
    FinancesView(),
    GeminiChatView(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Platform.isAndroid
          ? BottomNavigationBar(
              currentIndex: _selectIndex,
              onTap: _onItemTap,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard), label: 'Dashboard'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance_rounded),
                    label: 'Balance'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.local_fire_department), label: 'FireIA')
              ],
            )
          : Container(),
      body: Platform.isAndroid
          ? Center(
              child: _widgetOptions.elementAt(_selectIndex),
            )
          : Row(
              children: [
                // la barra lateral y su controller, que sirve para detectar acciones dentro
                SideBar(
                  controller: _controller,
                ),
                //permite adaptar la vista en ciertas ocasiones
                Expanded(
                  child: MotherView(
                    controller: _controller,
                  ),
                ),
              ],
            ),
    );
  }
}
