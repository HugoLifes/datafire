import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:datafire/src/app.dart';

class SuccessfulScreen extends StatelessWidget {
  const SuccessfulScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: greenSuccess, // Color de fondo del círculo
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(
                  Icons.check_box,
                  size: 120.0, // Tamaño del icono
                  color: Colors.white, // Color del icono
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            const Text(
              "SUCCESS!",
              style: TextStyle(
                  fontFamily: 'GoogleSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: greenSuccess,
                  letterSpacing: 2),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Felicidades! Solicitud al servidor \n hecha correctamente!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'GoogleSans',
                color: Color.fromARGB(255, 113, 109, 109),
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              child: FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: greenSuccess,
                    padding: const EdgeInsets.symmetric(vertical: 20)),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text(
                  "DONE",
                  style: TextStyle(
                      fontFamily: 'GoogleSans',
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
