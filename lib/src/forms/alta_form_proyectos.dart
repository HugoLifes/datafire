import 'package:flutter/material.dart';

import '../widgets/colors.dart';

class AltaProyectoPage extends StatefulWidget {
  @override
  _AltaProyectoPageState createState() => _AltaProyectoPageState();
}

class _AltaProyectoPageState extends State<AltaProyectoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Container(
                child: BackButton(onPressed: () {
                  Navigator.pop(context);
                }),
              ),
              Container(
                  height: 100,
                  decoration: const BoxDecoration(
                      color: accentCanvasColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20)))),
            ],
          ),
          Container(
              padding: const EdgeInsets.all(15),
              child: const Text(
                'Proyectos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              )),
          Container(
            padding: const EdgeInsets.only(top: 55, left: 15),
            width: size.width > 600 ? size.width * 0.8 : 500,
            child: const Text(
              'Aqui dara de alta sus proyectos',
              style: TextStyle(fontSize: 20),
            ),
          ),
          formview(context)
        ],
      ),
    );
  }

  Container formview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 100, left: 15),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre del Proyecto',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa el nombre del proyecto';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String nombreCliente = _nombreController.text;
                  // Lógica para dar de alta el cliente
                  // Puedes llamar a una función o realizar cualquier otra acción aquí
                  print('Proyecto dado de alta: $nombreCliente');
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
}
