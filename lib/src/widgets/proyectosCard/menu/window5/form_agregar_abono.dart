import 'package:datafire/src/services/abonos.service.dart';
import 'package:datafire/src/services/costos.servicio.dart';
import 'package:datafire/src/services/proyectos-clientes.service.dart';
import 'package:flutter/material.dart';

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
  int? selectedCustomerId;
  List<Map<String, dynamic>> customerData = [];

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
                print(selectedCustomerId);
                

                Navigator.of(context).pop();
              }
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }
}