import 'package:datafire/src/model/data.dart';
import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:datafire/src/view/success.dart';
import 'package:flutter/material.dart';

class EditarTrabajadoresForm extends StatefulWidget {
  final Map<String, dynamic>? trabajador;

  EditarTrabajadoresForm({Key? key, required this.trabajador})
      : super(key: key);

  @override
  _EditarTrabajadoresFormState createState() =>
      _EditarTrabajadoresFormState();
}

class _EditarTrabajadoresFormState extends State<EditarTrabajadoresForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _edadController = TextEditingController();
  final _cargoController = TextEditingController();
  final _salarioController = TextEditingController();

  Trabajadores trabajadorInstance = Trabajadores();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.trabajador?['name'] ?? '';
    _apellidosController.text = widget.trabajador?['last_name'] ?? '';
    _edadController.text = widget.trabajador?['age'].toString() ?? '';
    _cargoController.text = widget.trabajador?['position'] ?? '';
    _salarioController.text = widget.trabajador?['salary'].toString() ?? '';
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
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Trabajador',
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
                  return 'Por favor, ingresa los apellidos del trabajador';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _edadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Edad',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la edad del trabajador';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _cargoController,
              decoration: const InputDecoration(
                labelText: 'Posicion',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la posición del trabajador';
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
                  return 'Por favor, ingresa el salario del trabajador';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String name = _nombreController.text;
                    String last_name = _apellidosController.text;
                    String age = _edadController.text;
                    String cargo = _cargoController.text;
                    String salary = _salarioController.text;

                    try {
                      await trabajadorInstance.actualizarTrabajador(
                        id: widget.trabajador?["id"],
                        nombre: name,
                        apellido: last_name,
                        edad: int.parse(age),
                        position: cargo,
                        salario: int.parse(salary),
                      );

                      print('Trabajador actualizado: $name');
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuccessfulScreen(),
                        ),
                      );
                      print(
                          'Datos a enviar para actualizar trabajador: ${widget.trabajador?["id"]} $name, $last_name, $cargo, $salary, $age');
                    } catch (error) {
                      print('Error al actualizar el trabajador: $error');
                    }
                  }
                },
                child: const Text('Sobreescribir'),
              ),
            ),
            const SizedBox(height: 6.0),
            Container(
              width: double.infinity,
              child: IconButton.filled(
                icon: Icon(Icons.delete_forever),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Eliminar Trabajador'),
                        content: Text(
                            '¿Seguro que quieres eliminar este Trabajador?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                Navigator.of(context)
                                    .pop(); 
                                await trabajadorInstance.eliminarTrabajador(
                                    widget.trabajador?['id']);
                                print('Trabajador eliminado');
                                Navigator.pop(context);
                              } catch (error) {
                                print(
                                    'Error al eliminar el trabajador: $error');
                              }
                            },
                            child: Text('Confirmar'),
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
