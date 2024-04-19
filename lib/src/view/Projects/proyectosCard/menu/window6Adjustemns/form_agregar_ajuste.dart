import 'package:datafire/src/services/Ajustes.service.dart';
import 'package:datafire/src/widgets/TextField.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:datafire/src/services/proyectos-clientes.service.dart';


class AddAdjustmentForm extends StatefulWidget {
  final String idProyecto;

  const AddAdjustmentForm({
    Key? key,
    required this.idProyecto,
  }) : super(key: key);

  @override
  _AddAdjustmentFormState createState() => _AddAdjustmentFormState();
}

class _AddAdjustmentFormState extends State<AddAdjustmentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _motiveController = TextEditingController();
  bool operation = true; // Default value for operation
  List<Map<String, dynamic>> customerData = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchCustomerProjects().then((List<dynamic> result) {
      setState(() {
        customerData = result
            .where((cp) => cp['project_id'] == int.parse(widget.idProyecto))
            .map<Map<String, dynamic>>((dynamic item) => item as Map<String, dynamic>)
            .toList();
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _amountController,
            labelText: 'Importe',
            validationMessage: 'Por favor, ingresa una cantidad'
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _motiveController,
            labelText: 'Motivo',
            validationMessage: 'Por favor, ingresa un motivo'
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            onTap: () {
              _selectDate(context);
            },
            decoration: const InputDecoration(
              labelText: 'Fecha',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, selecciona una fecha';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Operación'),
            value: operation,
            onChanged: (bool value) {
              setState(() {
                operation = value;
              });
            },
            subtitle: Text(operation ? 'Sumar' : 'Restar'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                postAjuste(
                  _amountController.text,
                  _dateController.text,
                  widget.idProyecto,
                  _motiveController.text,
                  operation
                );
                Navigator.of(context).pop(); // Cerrar el formulario
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}