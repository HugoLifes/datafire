import 'package:datafire/src/view/exito_alta.dart';
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
  final _cargoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.trabajador?['name'] ?? '';
    _apellidosController.text = widget.trabajador?['last_name'] ?? '';
    _cargoController.text = widget.trabajador?['position'] ?? '';
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
                labelText: 'Nombre del Cliente',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa el nombre del Cliente';
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
                  return 'Por favor, ingresa la edad del cliente';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _cargoController,
              decoration: const InputDecoration(
                labelText: 'Compáñia',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la compañia del cliente';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String name = _nombreController.text;
                    String last_name = _apellidosController.text;
                    String cargo = _cargoController.text;

                    // Lógica para editar el proyecto existente
                    try {
                      // Llama a la función de actualización de trabajador aquí
                      print('Trabajador actualizado: $name');
                      // Puedes llamar a una función o realizar cualquier otra acción aquí
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuccessfulScreen(),
                        ),
                      );
                      print(
                          'Datos a enviar para actualizar trabajador: $name, $last_name, $cargo');
                    } catch (error) {
                      print('Error al actualizar el trabajador: $error');
                      // Puedes mostrar un mensaje de error al usuario si es necesario
                    }
                  }
                },
                child: const Text('Sobreescribir'),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              child: IconButton.filled(
                icon: Icon(Icons.delete_forever),
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
                                // Llama a la función de eliminación de trabajador aquí
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
