import 'package:datafire/src/services/proyectos.service.dart';
import 'package:datafire/src/view/Projects/proyectosCard/cardTotals.dart';
import 'package:datafire/src/widgets/TextField.dart';
import 'package:flutter/material.dart';

class EditarProyectosForm extends StatefulWidget {
  final Map<String, dynamic>? proyecto;
  const EditarProyectosForm({Key? key, required this.proyecto})
      : super(key: key);

  @override
  _EditarProyectosFormState createState() => _EditarProyectosFormState();
}

class _EditarProyectosFormState extends State<EditarProyectosForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  DateTime? _inicioDate;
  DateTime? _finDate;

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.proyecto?['name'] ?? '';
    _inicioDate = widget.proyecto?['fecha_inicio'] != null
        ? DateTime.parse(widget.proyecto?['fecha_inicio'])
        : null;
    _finDate = widget.proyecto?['fecha_fin'] != null
        ? DateTime.parse(widget.proyecto?['fecha_fin'])
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: formView(context),
        ),
      ),
    );
  }

  Form formView(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          CustomTextField(
              controller: _nombreController,
              labelText: 'Nombre del Proyecto',
              validationMessage: 'Por favor, ingresa el nombre del proyecto'),
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
          const SizedBox(height: 32.0),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String nombre = _nombreController.text;
                  String fechaInicio = _inicioDate?.toString() ?? '';
                  String fechaFinalizada = _finDate?.toString() ?? '';

                  try {
                    await updateProyecto(widget.proyecto?["id"], nombre,
                            fechaInicio, fechaFinalizada)
                        .whenComplete(() {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (Route<dynamic> route) => false,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Proyecto actualizado correctamente'),
                        ),
                      );
                    });
                    // Muestra el Snackbar al actualizar el proyecto

                    // ignore: empty_catches
                  } catch (error) {}
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
              style: IconButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Eliminar Proyecto'),
                      content: const Text(
                          '¿Seguro que quieres eliminar este proyecto?'),
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
                              deleteProyecto(widget.proyecto?["id"]);
                              ScaffoldMessenger.of(_scaffoldKey.currentContext!)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text('Proyecto Eliminado...'),
                                ),
                              );
                              // Agregar un pequeño retraso para dar tiempo al Snackbar de mostrarse
                              await Future.delayed(const Duration(seconds: 1));

                              Navigator.of(context).pop();

                              await deleteProyecto(widget.proyecto?["id"]);
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
          const SizedBox(height: 10),
          Center(child: CardTotals(proyecto: widget.proyecto)),
        ],
      ),
    );
  }

  Widget _buildDateTimePicker({
    required String labelText,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    DateTime initialDate = selectedDate ?? DateTime.now();

    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
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
