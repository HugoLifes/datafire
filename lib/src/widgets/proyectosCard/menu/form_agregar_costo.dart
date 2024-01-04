import 'package:flutter/material.dart';

class TuFormularioCosto extends StatefulWidget {
  @override
  _TuFormularioCostoState createState() => _TuFormularioCostoState();
}

class _TuFormularioCostoState extends State<TuFormularioCosto> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _costoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _costoController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Costo'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, ingresa un costo';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Puedes acceder al valor del campo de texto con _costoController.text
                // Aquí puedes realizar acciones con los datos del formulario
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