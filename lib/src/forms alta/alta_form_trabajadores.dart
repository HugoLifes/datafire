import 'package:datafire/src/model/data.dart';
import 'package:datafire/src/view/successScreen.dart';
import 'package:datafire/src/widgets/TextField.dart';
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
  final _salaryHourController = TextEditingController();
  final _semanalHoursController = TextEditingController();

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
              CustomTextField(
                  controller: _nombreController,
                  labelText: 'Nombre del trabajador',
                  validationMessage:
                      'Por favor, ingresa el nombre del Trabajador'),
              const SizedBox(height: 16.0),
              CustomTextField(
                  controller: _apellidosController,
                  labelText: 'Apellidos',
                  validationMessage:
                      'Por favor, ingresa los apellidos del cliente'),
              const SizedBox(height: 16.0),
              CustomTextField(
                  controller: _edadController,
                  labelText: 'Edad',
                  validationMessage: 'Por favor, ingresa la edad del empleado'),
              const SizedBox(height: 16.0),
              CustomTextField(
                  controller: _posicionController,
                  labelText: 'Posicion',
                  validationMessage:
                      'Por favor, ingresa la posicion del empleado'),
              const SizedBox(height: 16.0),
              CustomTextField(
                  controller: _salaryHourController,
                  labelText: 'Salario',
                  validationMessage:
                      'Por favor, ingrese el salario del trabajador'),
              const SizedBox(height: 16.0),
              CustomTextField(
                  controller: _semanalHoursController,
                  labelText: 'Horas que trabaja a la semana',
                  validationMessage:
                      'Por favor, ingrese la cantidad de horas que el trabajador trabaja a la semana'),
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
      String salarioHora = _salaryHourController.text;
      String semanalHours = _salaryHourController.text;

      // Create a new Trabajador instance
      Trabajadores trabajador = Trabajadores(
        nombre: nombreWorker,
        apellido: apellidoWorker,
        edad: double.parse(edadWorker),
        position: positionWorker,
        salario: int.parse(salarioHora),
        semanalHours: double.parse(semanalHours),
      );

      // Lógica para dar de alta el trabajador
      trabajador.nuevoTrabajador(nombreWorker, apellidoWorker, edadWorker,
          positionWorker, salarioHora, semanalHours);

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SuccessfulScreen()),
      );
    }
  }
}
