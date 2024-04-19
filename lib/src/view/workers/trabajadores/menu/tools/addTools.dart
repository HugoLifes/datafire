import 'package:datafire/src/services/abonos.service.dart';
import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:datafire/src/widgets/TextField.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:datafire/src/services/proyectos-clientes.service.dart';

class AddToolForm extends StatefulWidget {
  final String workerId;

  const AddToolForm({Key? key, required this.workerId}) : super(key: key);

  @override
  _AddToolFormState createState() => _AddToolFormState();
}

class _AddToolFormState extends State<AddToolForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _toolNameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _toolNameController,
            decoration: const InputDecoration(
              labelText: 'Nombre de la Herramienta',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa el nombre de la herramienta';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _costController,
            decoration: const InputDecoration(
              labelText: 'Costo',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa el costo';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            onTap: () => _selectDate(context),
            decoration: const InputDecoration(
              labelText: 'Fecha de Adquisición',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, selecciona una fecha';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Aquí asumimos que tienes una forma de obtener y mostrar trabajadores
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                postTools(
                  _toolNameController.text,
                  _costController.text,
                  widget.workerId.toString(),  // Asegúrate de gestionar la selección del trabajador
                  _dateController.text,
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Guardar Herramienta'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}