import 'package:datafire/src/widgets/card.dart';
import 'package:flutter/material.dart';

import '../widgets/colors.dart';

class Home extends StatelessWidget {
  CardTempII? cardTempII;
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                height: 100,
                decoration: const BoxDecoration(
                    color: accentCanvasColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)))),
            Container(
                padding: const EdgeInsets.all(15),
                child: const Text(
                  'Gestión',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                )),
            Container(
              padding: const EdgeInsets.only(top: 55, left: 10),
              width: size.width > 600 ? size.width * 0.8 : 500,
              child: Text('Revisa tu flujo'),
            ),
            Container(
              margin: EdgeInsets.only(top: 110, left: 20),
              padding: EdgeInsets.all(10),
              decoration: CardTempII(blur: 3.0, of1: 0, of2: 3).getCard(),
              width: size.width < 800 ? size.width * 0.89 : size.width * 0.89,
              height: size.height < 800 ? size.height * 0.45 : 350,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 15, top: 6),
                        child: Text('Total')),
                    Container(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          'Ganancia',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ))
                  ]),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: size.height < 760 ? size.height * 0.67 : 480,
                  left: size.width > 1000 ? size.width * 0.038 : 20),
              padding: EdgeInsets.all(10),
              decoration: CardTempII(blur: 3.0, of1: 0, of2: 3).getCard(),
              width: size.width < 800 ? size.width * 0.45 : size.width * 0.40,
              height: size.height < 800 ? size.height * 0.45 : 350,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 15, top: 6),
                        child: Text('Nuevos')),
                    Container(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          'Proyectos',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ))
                  ]),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: size.height < 760 ? size.height * 0.67 : 480,
                  left: size.width > 1000 ? size.width * 0.47 : 560),
              padding: EdgeInsets.all(10),
              decoration: CardTempII(blur: 3.0, of1: 0, of2: 3).getCard(),
              width: size.width < 800 ? size.width * 0.45 : size.width * 0.40,
              height: size.height < 800 ? size.height * 0.45 : 350,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 15, top: 6),
                        child: Text('Total')),
                    Container(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          'Gastos',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ))
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
