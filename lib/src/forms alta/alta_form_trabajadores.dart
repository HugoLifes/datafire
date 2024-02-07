import 'package:datafire/src/model/data.dart';
import 'package:datafire/src/view/successScreen.dart';
import 'package:flutter/material.dart';

class AltaTrabajadorPage extends StatefulWidget {
  const AltaTrabajadorPage({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar nuevo trabajador"),
      ),
      body: Stack(
        children: [
          formview(context),
        ],
      ),
    );
  }

  Center formview(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.only(top: 110, left: 15, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ingresa todos los datos del nuevo Trabajador",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
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
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveTrabajador,
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTrabajador() {
  if (_formKey.currentState!.validate()) {
    String nombreWorker = _nombreController.text;
    String apellidoWorker = _apellidosController.text;
    String edadWorker = _edadController.text;
    String positionWorker = _posicionController.text;
    String salarioWorker = _salarioController.text;

    // Create a new Trabajador instance
    Trabajadores trabajador = Trabajadores(
      nombre: nombreWorker,
      apellido: apellidoWorker,
      edad: double.parse(edadWorker),
      position: positionWorker,
      salario: double.parse(salarioWorker),
    );

    // Lógica para dar de alta el trabajador
    trabajador.nuevoTrabajador(
      nombreWorker,
      apellidoWorker,
      edadWorker,
      positionWorker,
      salarioWorker,
    );

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SuccessfulScreen()),
    );
  }
}

}
