import 'package:datafire/src/services/costos.servicio.dart';
import 'package:flutter/material.dart';

class EditarCostoDialog extends StatefulWidget {
  final Map<String, dynamic> costo;

  const EditarCostoDialog({Key? key, required this.costo}) : super(key: key);

  @override
  _EditarCostoDialogState createState() => _EditarCostoDialogState();
}

class _EditarCostoDialogState extends State<EditarCostoDialog> {
  final _id = TextEditingController();
  final _amountController = TextEditingController();
  final _serviceController = TextEditingController();
  final _costController = TextEditingController();
  final _fechaCostoController = TextEditingController(); // Nuevo controlador para la fecha

  @override
  void initState() {
    super.initState();
    _id.text = widget.costo["id"].toString();
    _amountController.text = widget.costo['amount'].toString();
    _serviceController.text = widget.costo['service'] ?? '';
    _costController.text = widget.costo['cost'].toString();
    _fechaCostoController.text = widget.costo['fecha_costo'].toString(); // Inicializa el campo de fecha
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar Costo"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Cantidad'),
          ),
          TextFormField(
            controller: _serviceController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(labelText: 'Servicio'),
          ),
          TextFormField(
            controller: _fechaCostoController, // Usa el nuevo controlador para la fecha
            keyboardType: TextInputType.datetime,
            decoration: const InputDecoration(labelText: 'Fecha del costo'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            String id = _id.text;
            String amount = _amountController.text;
            String description = _serviceController.text;
            String cost = _costController.text;
            String fechaCosto = _fechaCostoController.text; // Obtiene el valor del campo de fecha
            updateCostos(id, amount, description, cost, fechaCosto); // Actualiza el costo con la nueva fecha
            Navigator.of(context).pop();
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
