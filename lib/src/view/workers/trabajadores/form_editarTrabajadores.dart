import 'package:datafire/src/model/data.dart';
import 'package:datafire/src/view/successScreen.dart';
import 'package:datafire/src/widgets/TextField.dart';
import 'package:flutter/material.dart';

class EditarTrabajadoresForm extends StatefulWidget {
  final Map<String, dynamic>? trabajador;

  const EditarTrabajadoresForm({Key? key, required this.trabajador})
      : super(key: key);

  @override
  _EditarTrabajadoresFormState createState() => _EditarTrabajadoresFormState();
}

class _EditarTrabajadoresFormState extends State<EditarTrabajadoresForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _edadController = TextEditingController();
  final _cargoController = TextEditingController();
  final _salarioController = TextEditingController();
  final _salaryHourController = TextEditingController();
  final _semanalSalaryController = TextEditingController();

  Trabajadores trabajadorInstance = Trabajadores();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.trabajador?['name'] ?? '';
    _apellidosController.text = widget.trabajador?['last_name'] ?? '';
    _edadController.text = widget.trabajador?['age'].toString() ?? '';
    _cargoController.text = widget.trabajador?['position'] ?? '';
    _salarioController.text = widget.trabajador?['salary'].toString() ?? '';
    _salaryHourController.text =
        widget.trabajador?['salary_hour'].toString() ?? '';
    _semanalSalaryController.text =
        widget.trabajador?['semanal_hours'].toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return formView(context);
  }

  Container formView(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
                controller: _nombreController,
                labelText: 'Nombre del Trabajador',
                validationMessage:
                    'Por favor, ingresa el nombre del Trabajador'),
            const SizedBox(height: 16.0),
            CustomTextField(
                controller: _apellidosController,
                labelText: 'Apellidos',
                validationMessage:
                    'Por favor, ingresa los apellidos del trabajador'),
            const SizedBox(height: 16.0),
            CustomTextField(
                controller: _edadController,
                labelText: 'Edad',
                validationMessage: 'Por favor, ingresa la edad del trabajador'),
            const SizedBox(height: 16.0),
            CustomTextField(
                controller: _cargoController,
                labelText: 'Posicion',
                validationMessage:
                    'Por favor, ingresa la posición del trabajador'),
            const SizedBox(height: 16.0),
            CustomTextField(
                controller: _salarioController,
                labelText: 'Salario',
                validationMessage:
                    'Por favor, ingresa el salario del trabajador'),
            const SizedBox(height: 16.0),
            CustomTextField(
                controller: _semanalSalaryController,
                labelText: 'Horas semanales',
                validationMessage: 'Por favor, edita las horas del trabajador'),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String name = _nombreController.text;
                    String lastName = _apellidosController.text;
                    String age = _edadController.text;
                    String cargo = _cargoController.text;
                    String salary = _salarioController.text;
                    String salaryHour = _salaryHourController.text;
                    String semanalHour = _semanalSalaryController.text;

                    try {
                      await trabajadorInstance.actualizarTrabajador(
                          id: widget.trabajador?["id"],
                          nombre: name,
                          apellido: lastName,
                          edad: int.parse(age),
                          position: cargo,
                          salario: int.parse(salary),
                          salaryhour: double.parse(salaryHour),
                          semanahour: int.parse(semanalHour));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuccessfulScreen(),
                        ),
                      );
                      // ignore: empty_catches
                    } catch (error) {
                      print(error);
                    }
                  }
                },
                child: const Text('Sobreescribir'),
              ),
            ),
            const SizedBox(height: 6.0),
            SizedBox(
              width: double.infinity,
              child: IconButton.filled(
                icon: const Icon(Icons.delete_forever),
                style: IconButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Eliminar Trabajador'),
                        content: const Text(
                            '¿Seguro que quieres eliminar este Trabajador?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                await trabajadorInstance.eliminarTrabajador(
                                    widget.trabajador?['id']);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/home',
                                  (Route<dynamic> route) => false,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Trabajador eliminado correctamente'),
                                  ),
                                );
                                // ignore: empty_catches
                              } catch (error) {}
                            },
                            child: const Text('Confirmar'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
