import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:datafire/src/services/proyectos-clientes.service.dart';
import 'package:datafire/src/services/proyectos.service.dart';
import 'package:datafire/src/view/successScreen.dart';
import 'package:datafire/src/widgets/TextField.dart';
import 'package:flutter/material.dart';

class AltaProyectoPage extends StatefulWidget {
  const AltaProyectoPage({super.key});

  @override
  _AltaProyectoPageState createState() => _AltaProyectoPageState();
}

class _AltaProyectoPageState extends State<AltaProyectoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  DateTime? _inicioDate;
  DateTime? _finDate;
  final _initialCostController = TextEditingController();
  final _presupuestoController = TextEditingController();
  final _anticipoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar nuevo proyecto"),
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
        padding: const EdgeInsets.only(top: 70, left: 40, right: 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ingresa todos los datos del nuevo proyecto",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _nombreController,
                  labelText: 'Nombre del Proyecto',
                  validationMessage:'Por favor, ingresa el nombre del proyecto'
              ),
              const SizedBox(height: 16.0),
              _buildDateTimePicker(
                labelText: 'Fecha de inicio',
                selectedDate: _inicioDate,
                onDateSelected: (date) {
                  setState(() {
                    _inicioDate = date;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              _buildDateTimePicker(
                labelText: 'Fecha de finalización',
                selectedDate: _finDate,
                onDateSelected: (date) {
                  setState(() {
                    _finDate = date;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _initialCostController,
                  labelText: 'Costo Inicial',
                 validationMessage: 'Por favor, ingresa el costo inicial'
              ),
              const SizedBox(height: 16.0),
                            CustomTextField(
                controller: _presupuestoController,
                  labelText: 'Presupuesto',
                 validationMessage: 'Por favor, ingresa El presupuesto'
              ),
              const SizedBox(height: 16.0),
                            CustomTextField(
                controller: _anticipoController,
                  labelText: 'Anticipo',
                 validationMessage: 'Por favor, ingresa la cantidad del anticipo'
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()  || _initialCostController.text == '0') {
                      String nombre = _nombreController.text;
                      String fechaInicio = _inicioDate.toString();
                      String fechaFinalizada = _finDate.toString();
                      String costo = _initialCostController.text;
                      String presupuesto = _presupuestoController.text;
                      String anticipo = _anticipoController.text;

                      String? projectId = await obtenerIdProyecto(nombre, fechaInicio, fechaFinalizada, costo, presupuesto, anticipo);

                      if (projectId != null) {
                        _selectClientsDialog(projectId);
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SuccessfulScreen(),
                          ),
                        );
                      } else {
                      }
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectClientsDialog(String projectId) async {
    List<dynamic> clientes = await fetchClientes();
    List<String> clientesSeleccionados = [];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Selecciona clientes"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: clientes.map((cliente) {
                    bool isSelected = clientesSeleccionados.contains(cliente["id"]?.toString() ?? "");

                    return CheckboxListTile(
                      title: Text(cliente["name"]?.toString() ?? ""),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            if (value) {
                              clientesSeleccionados.add(cliente["id"]?.toString() ?? "");
                            } else {
                              clientesSeleccionados.remove(cliente["id"]?.toString() ?? "");
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
               Navigator.of(context).pop();
                // Guarda la relación entre el proyecto y los clientes seleccionados
                for (var clienteId in clientesSeleccionados) {
                  PostCustomerProject().addCustomerProject(projectId, clienteId);
                }

                
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateTimePicker({
    required String labelText,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null && pickedDate != selectedDate) {
          onDateSelected(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          fillColor: Colors.white,
          filled: true,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              selectedDate != null
                  ? "${selectedDate.toLocal()}".split(' ')[0]
                  : 'Seleccione una fecha',
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}

