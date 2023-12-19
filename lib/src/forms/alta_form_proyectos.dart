import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:datafire/src/services/proyectos.service.dart';
import 'package:datafire/src/view/success.dart';
import 'package:flutter/material.dart';

import '../widgets/colors.dart';

class AltaProyectoPage extends StatefulWidget {
  @override
  _AltaProyectoPageState createState() => _AltaProyectoPageState();
}

class _AltaProyectoPageState extends State<AltaProyectoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  DateTime? _inicioDate;
  DateTime? _finDate;
  final _costoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
        constraints: BoxConstraints(maxWidth: 600), //este es el max width
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
              TextFormField(
                controller: _costoController,
                decoration: const InputDecoration(
                  labelText: 'Costo',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el costo total';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String nombre = _nombreController.text;
                      String fechaInicio = _inicioDate.toString();
                      String fechaFinalizada = _finDate.toString();
                      String costo = _costoController.text;

                      postProyecto(nombre, fechaInicio, fechaFinalizada, costo);

                      print('Proyecto dado de alta: $nombre');
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuccessfulScreen(),
                        ),
                      );
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
          border: OutlineInputBorder(),
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
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}
