import 'package:flutter/material.dart';

class ChartInfoBox extends StatelessWidget {
  final Color color;
  final String title;
  const ChartInfoBox({super.key, required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 10,
          height: 10,
          color: color,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          title,
          style: TextStyle(fontFamily: 'GoogleSans'),
        )
      ],
    );
  }
}
