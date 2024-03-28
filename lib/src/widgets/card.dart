import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/material.dart';

class CardTempII {
  double? blur;
  double? of1;
  double? of2;
  CardTempII({this.of1, this.of2, this.blur});

  BoxDecoration getCard() {
    return BoxDecoration(
      color: canvasColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
            color: Colors.grey, blurRadius: blur!, offset: Offset(of1!, of2!)),
      ],
    );
  }
}
