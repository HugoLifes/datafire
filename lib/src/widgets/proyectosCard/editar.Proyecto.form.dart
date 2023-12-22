import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:datafire/src/services/proyectos.service.dart';
import 'package:datafire/src/view/success.dart';
import 'package:flutter/material.dart';

class editarProyectosForm extends StatefulWidget {
  final Map<String, dynamic>? proyecto;

  editarProyectosForm({Key? key, required this.proyecto}) : super(key: key);

  @override
  _editarProyectosFormState createState() => _editarProyectosFormState();
}

class _editarProyectosFormState extends State<editarProyectosForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _inicioController = TextEditingController();
  final _finController = TextEditingController();
  final _costoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.proyecto?['name'] ?? '';
    _inicioController.text = widget.proyecto?['fecha_inicio'] ?? '';
    _finController.text = widget.proyecto?['fecha_fin'] ?? '';
    _costoController.text = widget.proyecto?["costo"].toString() ?? "Sin costo total";

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
                labelText: 'Nombre del Proyecto',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa el nombre del proyecto';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _inicioController,
              decoration: const InputDecoration(
                labelText: 'Fecha de inicio',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la fecha en la que comenzó el proyecto';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _finController,
              decoration: const InputDecoration(
                labelText: 'Fecha de finalización',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la fecha en la que finalizó el proyecto';
                }
                return null;
              },
            ),
                        const SizedBox(height: 16.0),
            TextFormField(
              controller: _costoController,
              decoration: const InputDecoration(
                labelText: 'costo total del proyecto',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa el costo del proyecto';
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
                    String nombre = _nombreController.text;
                    try {
                      print('Proyecto actualizado: $nombre');
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuccessfulScreen(),
                        ),
                      );
                    } catch (error) {
                      print('Error al actualizar el proyecto: $error');
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
                        title: Text('Eliminar Proyecto'),
                        content:
                            Text('¿Seguro que quieres eliminar este proyecto?'),
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
                                await deleteProyecto(widget.proyecto?['id']);
                                print('Proyecto eliminado');
                                Navigator.pop(context);
                                // Puedes agregar más lógica aquí si es necesario
                              } catch (error) {
                                print('Error al eliminar el proyecto: $error');
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
