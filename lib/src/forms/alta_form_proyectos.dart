import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:datafire/src/view/success.dart';
import 'package:flutter/material.dart';

import '../widgets/colors.dart';

class AltaProyectoPage extends StatefulWidget {
  @override
  _AltaProyectoPageState createState() => _AltaProyectoPageState();
}

class _AltaProyectoPageState extends State<AltaProyectoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _inicioController = TextEditingController();
  final _finController = TextEditingController();
  final _costoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar nuevo cliente"),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15, left: 15),
            width: size.width > 600 ? size.width * 0.8 : 500,
            child: const Text(
              'Complete cada uno de los campos para dar de alta un nuevo cliente',
              style: TextStyle(
                  fontSize: 18, color: Color.fromARGB(255, 45, 45, 45)),
            ),
          ),
          formview(context),
        ],
      ),
    );
  }

  Container formview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 70, left: 15, right: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Proyecto',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa el nombre del proyecto';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _inicioController,
              decoration: const InputDecoration(
                labelText: 'Fecha de inicio',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la fecha en la que comenzo el proyecto';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _finController,
              decoration: const InputDecoration(
                labelText: 'Fecha de finalizacion',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la compañía a la que Finalizo el proyecto';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _costoController,
              decoration: const InputDecoration(
                labelText: 'Costo',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa el costo total';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity, // Ocupar todo el ancho disponible
              child: FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String nombre = _nombreController.text;
                    String fechaInicio = _inicioController.text;
                    String fechaFinalizada = _finController.text;
                    String costo = _costoController.text;
                    // Lógica para dar de alta el cliente
                    postCliente(nombre, fechaInicio, fechaFinalizada, costo);

                    print('Cliente dado de alta: $nombre');
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SuccessfulScreen()),
                    );
                  }
                },
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
