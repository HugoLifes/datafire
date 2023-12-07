import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import '../model/data.dart';
import '../widgets/colors.dart';
import 'package:http/http.dart' as http;

//Por hacer
//Seguir agregando los campos para guardar

class AltaClientePage extends StatefulWidget {
  @override
  _AltaClientePageState createState() => _AltaClientePageState();
}

class _AltaClientePageState extends State<AltaClientePage> {
  final _formKey = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _nombre = TextEditingController();
  final _apellido = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _companyController = TextEditingController();

  List<Clientes> clientes = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
              margin: EdgeInsets.all(5),
              height: 100,
              decoration: const BoxDecoration(
                  color: accentCanvasColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)))),
          Container(
              padding: const EdgeInsets.all(15),
              child: const Text(
                'Clientes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              )),
          Container(
            padding: const EdgeInsets.only(top: 55, left: 15),
            width: size.width > 600 ? size.width * 0.8 : 500,
            child: const Text(
              'Complete cada uno de los campos para dar de alta un nuevo cliente',
              style: TextStyle(fontSize: 16),
            ),
          ),
          formview(context)
        ],
      ),
    );
  }

  Container formview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 150, left: 15, right: 20),
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
                  filled: true),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa el nombre del cliente';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _apellidoController,
              decoration: const InputDecoration(
                  labelText: 'Apellidos',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa los apellidos del cliente';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _companyController,
              decoration: const InputDecoration(
                  labelText: 'Compañia',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la comapañia a la que pertenece el cliente';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(),
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
                }
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  //Future para el post
  Future<void> postCliente(
      String nombre, String apellido, String company) async {
    final url = "https://datafire-production.up.railway.app/api/v1/clientes";

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"name": nombre, "last_name": apellido, "company": company}),
      );
      if (res.statusCode == 200) {
        print("Cliente Guardado Exitosamente");
      } else {
        print("Error al guardar el cliente");
      }
    } catch (err) {
      print("Error al realizar la solicitud http: $err");
    }
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
