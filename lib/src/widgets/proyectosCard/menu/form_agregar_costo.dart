import 'package:datafire/src/services/costos.servicio.dart';
import 'package:flutter/material.dart';

class TuFormularioCosto extends StatefulWidget {
  final String id_proyecto;

  const TuFormularioCosto({
    Key? key,
    required this.id_proyecto,
  }) : super(key: key);

  @override
  _TuFormularioCostoState createState() => _TuFormularioCostoState();
}

class _TuFormularioCostoState extends State<TuFormularioCosto> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _costoController = TextEditingController();

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
            controller: _descriptionController,
            keyboardType: TextInputType.text, // Cambiado a TextInputType.text
            decoration: InputDecoration(
              labelText: 'Servicio',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, ingresa la descripción del costo';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _costoController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Costo',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, ingresa un costo';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                String idProyecto = widget.id_proyecto;
                String amountCosto = _amountController.text;
                String descriptionCosto = _descriptionController.text;
                String priceCosto = _costoController.text;
                postCosts().addCosto(idProyecto,amountCosto, descriptionCosto, priceCosto);

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
