import 'package:datafire/src/app.dart';
import 'package:datafire/src/model/data.dart';
import 'package:datafire/src/view/successScreen.dart';
import 'package:flutter/material.dart';

class EditarClienteForm extends StatefulWidget {
  final Map<String, dynamic>? cliente;

  const EditarClienteForm({Key? key, required this.cliente}) : super(key: key);

  @override
  _EditarClienteFormState createState() => _EditarClienteFormState();
}

class _EditarClienteFormState extends State<EditarClienteForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _empresaController = TextEditingController();

  // instancia de clientes
  Clientes clienteActual = Clientes();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.cliente?['name'] ?? '';
    _apellidosController.text = widget.cliente?['last_name'] ?? '';
    _empresaController.text = widget.cliente?['company'] ?? '';
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
              controller: _empresaController,
              decoration: const InputDecoration(
                labelText: 'Empresa',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la empresa del cliente';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Logica para actualizar un cliente
                    try {
                      await clienteActual.actualizarCliente(
                        id: widget.cliente?['id'],
                        nombre: _nombreController.text,
                        apellido: _apellidosController.text,
                        company: _empresaController.text,
                      );
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuccessfulScreen(),
                        ),
                      );
                    // ignore: empty_catches
                    } catch (error) {
                      
                    }
                  }
                },
                child: const Text(
                  'Sobreescribir',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 6.0),
            SizedBox(
              width: double.infinity,
              child: IconButton.filled(
                icon: const Icon(Icons.delete_forever),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Eliminar Cliente'),
                        content: const Text(
                            '¿Seguro que quieres eliminar este Cliente?'),
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
                                await clienteActual.eliminarCliente(
                                    widget.cliente?['id']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyApp(),
                                  ),
                                );
                              // ignore: empty_catches
                              } catch (error) {
                                
                              }
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
