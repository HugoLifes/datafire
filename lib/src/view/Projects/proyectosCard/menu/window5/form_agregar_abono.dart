import 'package:datafire/src/services/abonos.service.dart';
import 'package:datafire/src/widgets/TextField.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:datafire/src/services/proyectos-clientes.service.dart';

class AddAbonoForm extends StatefulWidget {
  final String idProyecto;

  const AddAbonoForm({
    Key? key,
    required this.idProyecto,
  }) : super(key: key);

  @override
  _AddAbonoFormState createState() => _AddAbonoFormState();
}

class _AddAbonoFormState extends State<AddAbonoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  int? selectedCustomerId;
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

  List<DropdownMenuItem<int>> buildDropdownMenuItems() {
    List<int> uniqueCustomerIds = [];

    return customerData
        .where((customer) {
          int customerId = customer['customer_id'] as int;
          if (!uniqueCustomerIds.contains(customerId)) {
            uniqueCustomerIds.add(customerId);
            return true;
          }
          return false;
        })
        .map<DropdownMenuItem<int>>((dynamic customer) {
          return DropdownMenuItem<int>(
            value: customer['customer_id'] as int,
            child: Text(customer['customer_name'].toString()),
          );
        })
        .toList();
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
              validationMessage:'Por favor, ingresa una cantidad'
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
          DropdownButton<int>(
            value: selectedCustomerId,
            items: buildDropdownMenuItems(),
            onChanged: (int? value) {
              setState(() {
                selectedCustomerId = value;
              });
            },
            hint: const Text('Seleccionar Cliente'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && selectedCustomerId != null) {
                String idProyecto = widget.idProyecto;
                String amountCosto = _amountController.text;
                int customerId = selectedCustomerId!;
                String selectedDateString = _dateController.text;
                postAbono(amountCosto, selectedDateString, idProyecto, customerId);

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
