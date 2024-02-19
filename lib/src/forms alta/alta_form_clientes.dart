import 'package:datafire/src/view/successScreen.dart';
import 'package:datafire/src/widgets/TextField.dart';
import 'package:flutter/material.dart';
import '../model/data.dart';

class AltaClientePage extends StatefulWidget {
  const AltaClientePage({super.key});

  @override
  _AltaClientePageState createState() => _AltaClientePageState();
}

class _AltaClientePageState extends State<AltaClientePage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _companyController = TextEditingController();

  List<Clientes> clientes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar nuevo cliente"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.only(top: 110, left: 15, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ingresa todos los datos del nuevo cliente",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: _nombreController,
                  labelText: 'Nombre del Cliente',
                  validationMessage: 'Por favor, ingresa el nombre del cliente',
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: _apellidoController,
                  labelText: 'Apellidos',
                  validationMessage: 'Por favor, ingresa los apellidos del cliente',
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: _companyController,
                  labelText: 'Compañia',
                  validationMessage: 'Por favor, ingresa la compañía a la que pertenece el cliente',
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saveCliente,
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


void _saveCliente() {
  if (_formKey.currentState!.validate()) {
    String nombreCliente = _nombreController.text;
    String apellidoCliente = _apellidoController.text;
    String companyCliente = _companyController.text;

    // Create a new Clientes instance
    Clientes cliente = Clientes(
      nombre: nombreCliente,
      apellido: apellidoCliente,
      company: companyCliente
    );

    // Lógica para dar de alta el cliente
    cliente.nuevoCliente();

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SuccessfulScreen()),
    );
  }
}

}
