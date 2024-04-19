import 'package:datafire/src/services/costos.servicio.dart';
import 'package:flutter/material.dart';

class EditarCostoDialog extends StatefulWidget {
  final Map<String, dynamic> costo;

  const EditarCostoDialog({super.key, required this.costo});

  @override
  _EditarCostoDialogState createState() => _EditarCostoDialogState();
}

class _EditarCostoDialogState extends State<EditarCostoDialog> {
  final _id = TextEditingController();
  final _amountController = TextEditingController();
  final _serviceController = TextEditingController();
  final _costController = TextEditingController();
  final _dateController = TextEditingController(); // Nuevo controlador para la fecha

  @override
  void initState() {
    super.initState();
    _id.text = widget.costo["id"].toString();
    _amountController.text = widget.costo['amount'].toString();
    _serviceController.text = widget.costo['service'] ?? '';
    _costController.text = widget.costo['cost'].toString();

    _dateController.text = widget.costo['fecha_costo'].toString();
  }

Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.parse(_dateController.text),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (picked != null) {
    setState(() {
      _dateController.text = picked.toLocal().toString();
    });
  }
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
            controller: _dateController,
            keyboardType: TextInputType.datetime,
            decoration: const InputDecoration(labelText: 'Fecha del Costo'),
            onTap: () => _selectDate(context),
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
            String fechaCosto = _dateController.text;

            // Llama a la función de actualización con la nueva fecha
            updateCostos(id, amount, description, cost, fechaCosto);

            Navigator.of(context).pop();
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
