import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:datafire/src/view/success.dart';
import 'package:flutter/material.dart';

import '../widgets/colors.dart';

class AltaTrabajadorPage extends StatefulWidget {
  @override
  _AltaTrabajadorPageState createState() => _AltaTrabajadorPageState();
}

class _AltaTrabajadorPageState extends State<AltaTrabajadorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _edadController = TextEditingController();
  final _posicionController = TextEditingController();
  final _salarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 5, left: 15),
            width: size.width > 600 ? size.width * 0.8 : 500,
            child: const Text(
              'Agregar nuevo Trabajador',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 45, left: 15),
            width: size.width > 600 ? size.width * 0.8 : 500,
            child: const Text(
              'Complete cada uno de los campos para dar de alta un nuevo trabajador',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          formview(context),
        ],
      ),
    );
  }

  Container formview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 110, left: 15, right: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del trabajador',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa el nombre del Trabajador';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _apellidosController,
              decoration: const InputDecoration(
                labelText: 'Apellidos',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa los apellidos del cliente';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _edadController,
              decoration: const InputDecoration(
                labelText: 'Edad',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la edad del empleado';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _posicionController,
              decoration: const InputDecoration(
                labelText: 'Posicion',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la posicion del empleado';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _salarioController,
              decoration: const InputDecoration(
                labelText: 'Salario',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingrese el salario del empleado';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity, // Ocupar todo el ancho disponible
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String nombreWorker = _nombreController.text;
                    String apellidoWorker = _apellidosController.text;
                    String edadWorker = _edadController.text;
                    String positionWorker = _posicionController.text;
                    String salarioWorker = _salarioController.text;
                    // Lógica para dar de alta el cliente
                    postTrabajador(nombreWorker, apellidoWorker, edadWorker,
                        positionWorker, salarioWorker);
                    // Puedes llamar a una función o realizar cualquier otra acción aquí
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

  void validation(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String nombreCliente = _nombreController.text;
      // Lógica para dar de alta el cliente
      // Puedes llamar a una función o realizar cualquier otra acción aquí
      print('Trabajador dado de alta: $nombreCliente');
      Navigator.pop(context);
    }
  }
}
