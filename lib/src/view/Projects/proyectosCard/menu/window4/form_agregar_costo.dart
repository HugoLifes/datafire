import 'package:datafire/src/services/costos.servicio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TuFormularioCosto extends StatefulWidget {
  final String idProyecto;
  final Future<List<dynamic>> futureCosts;
  

   const TuFormularioCosto({
    Key? key,
    required this.idProyecto,
    required this.futureCosts
  }) : super(key: key);

  @override
  _TuFormularioCostoState createState() => _TuFormularioCostoState(futureCosts);
}

class _TuFormularioCostoState extends State<TuFormularioCosto> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costoController = TextEditingController();
   final TextEditingController _dateController = TextEditingController();
     DateTime selectedDate = DateTime.now();
  late Future<List<dynamic>> futureCosts;

  _TuFormularioCostoState(this.futureCosts);

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
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
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
          const SizedBox(height: 20),
          TextFormField(
            controller: _descriptionController,
            keyboardType: TextInputType.text, 
            decoration: const InputDecoration(
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
          const SizedBox(height: 20),
          TextFormField(
            controller: _costoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
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
          const SizedBox(height: 20),
FilledButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      String idProyecto = widget.idProyecto;
      String amountCosto = _amountController.text;
      String descriptionCosto = _descriptionController.text;
      String priceCosto = _costoController.text;
      String selectedDateString = _dateController.text;

      addCosto(idProyecto, amountCosto, descriptionCosto, priceCosto, selectedDateString)
        .then((_) {
          setState(() {
            futureCosts = fetchCostsByProjectId(idProyecto);
          });
          Navigator.of(context).pop();
        })
        .catchError((error) {
          // Handle error if necessary
        });
    }
  },
  child: const Text('Guardar'),
),
        ],
      ),
    );
  }
}
