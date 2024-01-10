import 'package:datafire/src/services/costos.servicio.dart';
import 'package:flutter/material.dart';

class EditAbonoDialog extends StatefulWidget {
  final Map<String, dynamic> costo;

  EditAbonoDialog({required this.costo});

  @override
  _EditAbonoDialogState createState() => _EditAbonoDialogState();
}

class _EditAbonoDialogState extends State<EditAbonoDialog> {
  final _id = TextEditingController();
  final _amountController = TextEditingController();
  final _serviceController = TextEditingController();
  final _costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _id.text = widget.costo["id"].toString();
    _amountController.text = widget.costo['amount'].toString();
    _serviceController.text = widget.costo['service'] ?? '';
    _costController.text = widget.costo['cost'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Editar Costo"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Cantidad'),
          ),
          TextFormField(
            controller: _serviceController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Servicio'),
          ),
          TextFormField(
            controller: _costController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Costo'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            // Realizar la actualización aquí utilizando el servicio
            // Puedes llamar a la función updateCliente con los nuevos valores
            // _amountController.text, _serviceController.text, _costController.text
            String id = _id.text;
            String amount = _amountController.text;
            String description = _serviceController.text;
            String cost = _costController.text;
            updateCostos(id, amount, description, cost);
            print("id, amount, description, cost");
            Navigator.of(context).pop();
          },
          child: Text("Guardar"),
        ),
      ],
    );
  }
}
