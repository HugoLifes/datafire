import 'package:datafire/src/services/proyectos.service.dart';
import 'package:flutter/material.dart';

class EditarProyectosForm extends StatefulWidget {
  final Map<String, dynamic>? proyecto;

  EditarProyectosForm({Key? key, required this.proyecto}) : super(key: key);

  @override
  _EditarProyectosFormState createState() => _EditarProyectosFormState();
}

class _EditarProyectosFormState extends State<EditarProyectosForm> {
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  DateTime? _inicioDate;
  DateTime? _finDate;
  final _costoController = TextEditingController();
  final _abonadoController = TextEditingController();
  final _remainingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.proyecto?['name'] ?? '';
    _costoController.text = widget.proyecto?["costo"].toString() ?? "Sin costo total";
    _abonadoController.text = widget.proyecto?["abonado"].toString() ?? "sin abonos";
        _remainingController.text = widget.proyecto?["remaining"].toString() ?? "sin abonos";
    _inicioDate = widget.proyecto?['fecha_inicio'] != null
        ? DateTime.parse(widget.proyecto?['fecha_inicio'])
        : null;
    _finDate = widget.proyecto?['fecha_fin'] != null
        ? DateTime.parse(widget.proyecto?['fecha_fin'])
        : null;
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(
  key: _scaffoldKey,
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: formView(context),
    ),
  ),
);

  }

  Form formView(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _nombreController,
            decoration: const InputDecoration(
              labelText: 'Nombre del Proyecto',
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, ingresa el nombre del proyecto';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          _buildDateTimePicker(
            labelText: 'Fecha de inicio',
            selectedDate: _inicioDate,
            onDateSelected: (date) {
              setState(() {
                _inicioDate = date;
              });
            },
          ),
          const SizedBox(height: 16.0),
          _buildDateTimePicker(
            labelText: 'Fecha de finalización',
            selectedDate: _finDate,
            onDateSelected: (date) {
              setState(() {
                _finDate = date;
              });
            },
          ),
          const SizedBox(height: 32.0),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String nombre = _nombreController.text;
                  String fechaInicio = _inicioDate?.toString() ?? '';
                  String fechaFinalizada = _finDate?.toString() ?? '';
    
                  try {
                    await updateProyecto(widget.proyecto?["id"], nombre, fechaInicio, fechaFinalizada);
                    print('Proyecto actualizado: $nombre');
                    // Muestra el Snackbar al actualizar el proyecto
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Proyecto actualizado correctamente'),
                      ),
                    );
                  } catch (error) {
                    print('Error al actualizar el proyecto: $error');
                  }
                }
              },
              child: const Text('Sobreescribir'),
            ),
          ),
          const SizedBox(height: 6.0),
    SizedBox(
      width: double.infinity,
      child: IconButton.filled(
        icon: const Icon(Icons.delete_forever),
        style: IconButton.styleFrom(
    backgroundColor: Colors.red,
        ),
    onPressed: () async {
      // Mostrar un diálogo de confirmación antes de eliminar
      showDialog(
        context: context,
        builder: (BuildContext context) {
    return AlertDialog(
      title: const Text('Eliminar Proyecto'),
      content: const Text('¿Seguro que quieres eliminar este proyecto?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
TextButton(
  onPressed: () async {
    try {
      deleteProyecto(widget.proyecto?["id"]);
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
  const SnackBar(
    content: Text('Proyecto Eliminado...'),
  ),
);


      // Agregar un pequeño retraso para dar tiempo al Snackbar de mostrarse
      await Future.delayed(const Duration(seconds: 1));

      Navigator.of(context).pop();

      await deleteProyecto(widget.proyecto?["id"]);
      print('Proyecto eliminado');
    } catch (error) {
      print('Error al eliminar el proyecto: $error');
    }
  },
  child: const Text('Confirmar'),
),

      ],
    );
        },
      );
    },
    
      ),
    ),
    const SizedBox(height: 10),
    Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
    Container(
      width: 150.0,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.lightBlueAccent, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Total:",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
    Text(
      "\$${_costoController.text}",
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    
        ],
      ),
    ),
    Container(
      width: 150.0,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.amber, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Abonado:",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
      "\$${_abonadoController.text}",
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
        ],
      ),
    ),
    Container(
      width: 150.0,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepOrange, Colors.red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Restante:",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            "\$${_remainingController.text}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    ),
        ],
      ),
    ),
    
    
    
        ],
      ),
    );
  }

  Widget _buildDateTimePicker({
    required String labelText,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    DateTime initialDate = selectedDate ?? DateTime.now();

    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null && pickedDate != selectedDate) {
          onDateSelected(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          fillColor: Colors.white,
          filled: true,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              selectedDate != null
                  ? "${selectedDate.toLocal()}".split(' ')[0]
                  : 'Seleccione una fecha',
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}
