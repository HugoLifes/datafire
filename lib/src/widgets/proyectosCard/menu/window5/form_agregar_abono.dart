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
  String? selectedCustomer;
  List<Map<String, dynamic>> customerData = []; // Lista para almacenar la información de los clientes

@override
void initState() {
  super.initState();
  // Llama al servicio para obtener la lista de clientes relacionados con el proyecto
  fetchCustomerProjects().then((List<dynamic> result) {
    setState(() {
      // Realiza el cast de List<dynamic> a List<Map<String, dynamic>>
      customerData = result
          .where((cp) => cp['project_id'] == int.parse(widget.id_proyecto))
          .map<Map<String, dynamic>>((dynamic item) => item as Map<String, dynamic>)
          .toList();
    });
  });
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

          // DropdownButton para seleccionar el cliente
          DropdownButton(
            value: selectedCustomer,
            items: customerData
                .map<DropdownMenuItem<String>>((dynamic customer) {
              return DropdownMenuItem<String>(
                value: customer['customer_name'].toString(),
                child: Text(customer['customer_name'].toString()),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedCustomer = value;
              });
            },
            hint: Text('Seleccionar Cliente'),
          ),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                String idProyecto = widget.id_proyecto;
                String amountCosto = _amountController.text;

                // Ahora puedes utilizar 'selectedCustomer' para obtener el cliente seleccionado

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