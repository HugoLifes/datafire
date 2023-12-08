import 'package:datafire/src/app.dart';
import 'package:flutter/material.dart';

class SuccessfulScreen extends StatelessWidget {
  const SuccessfulScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green, // Color de fondo del círculo
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
            SizedBox(height: 18.0),
            Text(
              "Subido!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: 4.0),
            Text(
              "Se ha almacenado en la base de datos correctamente!",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyApp(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 20.0), // Ajusta el relleno aquí
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8.0), // Ajusta el radio de borde aquí
            ), // Cambia el color del botón a rojo
          ),
          child: const Text('Inicio'),
        ),
      ),
    );
  }
}
