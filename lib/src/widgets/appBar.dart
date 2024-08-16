import 'package:flutter/material.dart';

class AppBarDatafire extends StatelessWidget {
  final String title;
  final String description;

  const AppBarDatafire(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontFamily: 'GoogleSans',
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
          Text(
            description,
            style: const TextStyle(fontFamily: 'GoogleSans', fontSize: 15),
          ),
        ],
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
    );
  }
}
