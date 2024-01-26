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
            SideBar(
              controller: _controller,
            ),
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
