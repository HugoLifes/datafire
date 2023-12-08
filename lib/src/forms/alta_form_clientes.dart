import 'package:datafire/src/view/exito_alta.dart';
import 'package:flutter/material.dart';
import '../model/data.dart';

import "../services/cliente.servicio.dart";

class AltaClientePage extends StatefulWidget {
  @override
  _AltaClientePageState createState() => _AltaClientePageState();
}

class _AltaClientePageState extends State<AltaClientePage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _companyController = TextEditingController();

  List<Clientes> clientes = [];
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
              'Agregar nuevo cliente',
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
              'Complete cada uno de los campos para dar de alta un nuevo cliente',
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
                labelText: 'Nombre del Cliente',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa el nombre del cliente';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _apellidoController,
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
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Compañia',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la compañía a la que pertenece el cliente';
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
                    String nombreCliente = _nombreController.text;
                    String apellidoCliente = _apellidoController.text;
                    String companyCliente = _companyController.text;
                    // Lógica para dar de alta el cliente
                    postCliente(nombreCliente, apellidoCliente, companyCliente);
                    // Puedes llamar a una función o realizar cualquier otra acción aquí
                    print('Cliente dado de alta: $nombreCliente');
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

  void crearClienteConProyecto(
      String nombreP, String descripcion, String nombreC) {
    int id = Proyecto().crearId();
    var proyecto = Proyecto();
    var cliente = Clientes(nombreP, id);
    clientes.add(cliente);
  }

  void crearCliente() {}
}
