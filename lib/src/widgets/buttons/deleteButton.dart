import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/material.dart';

class AppBarDatafire extends StatelessWidget {
  final String title;
  final String description;

  AppBarDatafire({required this.title, required this.description});

  

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
             Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: accentCanvasColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      );
  }
}
