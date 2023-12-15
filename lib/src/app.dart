import 'package:datafire/src/view/vista_madre.dart';
import 'package:datafire/src/widgets/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final _controller = SidebarXController(selectedIndex: 0);

  ///[_key] se  usa para controlar o escuchar elementos como el sidebar o snackbars
  // en cualquier pagina que estes, solo hay que pasarla como parametro (no borrar)
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
