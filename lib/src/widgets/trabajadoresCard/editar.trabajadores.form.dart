import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:datafire/src/view/success.dart';
import 'package:flutter/material.dart';

class editarTrabajadoresForm extends StatefulWidget {
  final Map<String, dynamic>? trabajador;

  editarTrabajadoresForm({Key? key, required this.trabajador})
      : super(key: key);

  @override
  _editarTrabajadoresFormState createState() => _editarTrabajadoresFormState();
}

class _editarTrabajadoresFormState extends State<editarTrabajadoresForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _edadController = TextEditingController();
  final _cargoController = TextEditingController();
  final _salarioController = TextEditingController();

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
    return formview(context);
  }

  Container formview(BuildContext context) {
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
                  return 'Por favor, ingresa los apéllidos del trabajador';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
TextFormField(
  controller: _edadController,
  keyboardType: TextInputType.number,  // Specify keyboard type for numeric input
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
                  return 'Por favor, ingresa la posicion del trabajador';
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
                  return 'Por favor, ingresa la el sueldo del trabajador';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              child: FilledButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {

                    String name = _nombreController.text;
                    String last_name = _apellidosController.text;
                    String age = _edadController.text;
                    String cargo = _cargoController.text;
                    String salary = _salarioController.text;

                    // Lógica para editar el proyecto existente
                    try {
                      updateTrabajador(widget.trabajador?["id"],name, last_name,int.parse(age), cargo, int.parse(salary));
                      print('Trabajador actualizado: $name');
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuccessfulScreen(),
                        ),
                      );
                      print(
                          'Datos a enviar para actualizar trabajador: ${widget.trabajador?["id"]} $name, $last_name, $cargo, $salary, $age' );
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
                style: IconButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  // Mostrar un diálogo de confirmación antes de eliminar
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
                                    .pop(); // Cerrar el diálogo antes de la eliminación
                                await deleteTrabajador(
                                    widget.trabajador?['id']);
                                print('Trabajador eliminado');
                                Navigator.pop(context);
                                // Puedes agregar más lógica aquí si es necesario
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
