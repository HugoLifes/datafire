import 'package:datafire/src/view/motherView.dart';
import 'package:datafire/src/widgets/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sidebarx/sidebarx.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final _controller = SidebarXController(selectedIndex: 0);
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayColor: Colors.grey.withOpacity(0.8),
      useDefaultLoading: false,
      overlayWidgetBuilder: (_) {
        //ignored progress for the moment
        return Center(
          child: SpinKitRotatingCircle(
            color: Colors.blue,
            size: 50.0,
          ),
        );
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DataFire',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Row(
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
        ),
      ),
    );
  }
}
