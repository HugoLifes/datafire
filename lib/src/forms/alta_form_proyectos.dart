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
          Container(
            padding: const EdgeInsets.only(top: 15, left: 15),
            width: size.width > 600 ? size.width * 0.8 : 500,
            child: const Text(
              'Complete cada uno de los campos para dar de alta un nuevo proyecto',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 45, 45, 45),
              ),
            ),
          ),
          formview(context),
        ],
      ),
    );
  }

  Container formview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 70, left: 15, right: 20),
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
