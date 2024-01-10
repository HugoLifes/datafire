import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:datafire/src/services/proyectos-clientes.service.dart';

class addAbonoForm extends StatefulWidget {
  final String id_proyecto;

  const addAbonoForm({
    Key? key,
    required this.id_proyecto,
  }) : super(key: key);

  @override
  _addAbonoFormState createState() => _addAbonoFormState();
}

class _addAbonoFormState extends State<addAbonoForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  int? selectedCustomerId;
  List<Map<String, dynamic>> customerData = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchCustomerProjects().then((List<dynamic> result) {
      setState(() {
        customerData = result
            .where((cp) => cp['project_id'] == int.parse(widget.id_proyecto))
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
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Cantidad',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, ingresa una cantidad';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            onTap: () {
              _selectDate(context);
            },
            decoration: InputDecoration(
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
          SizedBox(height: 20),
          DropdownButton<int>(
            value: selectedCustomerId,
            items: buildDropdownMenuItems(),
            onChanged: (int? value) {
              setState(() {
                selectedCustomerId = value;
              });
            },
            hint: Text('Seleccionar Cliente'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && selectedCustomerId != null) {
                String idProyecto = widget.id_proyecto;
                String amountCosto = _amountController.text;
                int customerId = selectedCustomerId!;
                String selectedDateString = _dateController.text;

                print('ID Proyecto: $idProyecto');
                print('Cantidad: $amountCosto');
                print('ID Cliente: $customerId');
                print('Fecha Seleccionada: $selectedDateString');

                // Aquí puedes realizar la acción deseada con los datos recolectados.

                Navigator.of(context).pop(); // Cerrar el formulario
              }
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
