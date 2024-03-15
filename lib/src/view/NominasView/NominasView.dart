import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NominasView extends StatefulWidget {
  const NominasView({Key? key}) : super(key: key);

  @override
  _NominasViewState createState() => _NominasViewState();
}

class _NominasViewState extends State<NominasView> {
  DateTime? fechaInicioSemana;
  DateTime? fechaFinSemana;
  Map<String, Map<String, dynamic>> trabajadoresDatos = {};

  @override
  void initState() {
    super.initState();
    // Inicializar los datos de los trabajadores como no completados y con horas a 0
    for (var trabajador in trabajadores) {
      trabajadoresDatos[trabajador] = {
        'completado': false,
        'horasTrabajadas': 0,
        'horasExtra': 0,
      };
    }
  }

  Future<void> _seleccionarFecha(BuildContext context, bool esFechaInicio) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaInicioSemana ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        if (esFechaInicio) {
          fechaInicioSemana = picked;
        } else {
          fechaFinSemana = picked;
        }
      });
    }
  }

  void _mostrarDialogoNomina(String trabajadorSeleccionado) {
    if (fechaInicioSemana == null || fechaFinSemana == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Por favor, selecciona primero las fechas de inicio y fin de la semana."),
      ));
      return;
    }

    final TextEditingController _horasTrabajadasController = TextEditingController();
    final TextEditingController _horasExtraController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ingresar Nómina para $trabajadorSeleccionado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Semana del ${DateFormat('dd/MM/yyyy').format(fechaInicioSemana!)} al ${DateFormat('dd/MM/yyyy').format(fechaFinSemana!)}'),
              TextField(
                controller: _horasTrabajadasController,
                decoration: const InputDecoration(labelText: 'Horas trabajadas'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _horasExtraController,
                decoration: const InputDecoration(labelText: 'Horas extra'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                setState(() {
                  trabajadoresDatos[trabajadorSeleccionado] = {
                    'completado': true,
                    'horasTrabajadas': int.tryParse(_horasTrabajadasController.text) ?? 0,
                    'horasExtra': int.tryParse(_horasExtraController.text) ?? 0,
                  };
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _generarNomina() {
    if (trabajadoresDatos.values.any((datos) => !datos['completado'])) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No todos los trabajadores están completados."),
      ));
      return;
    }
    // Mostrar diálogo de éxito
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nómina Generada"),
        content: const Text("Todos los datos han sido enviados para la generación de la nómina."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nóminas"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => _seleccionarFecha(context, true),
            tooltip: 'Seleccionar fecha de inicio',
          ),
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => _seleccionarFecha(context, false),
            tooltip: 'Seleccionar fecha de fin',
          ),
        ],
      ),
      body: Column(
        children: [
          if (fechaInicioSemana != null && fechaFinSemana != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Semana de nómina: ${DateFormat('dd/MM/yyyy').format(fechaInicioSemana!)} - ${DateFormat('dd/MM/yyyy').format(fechaFinSemana!)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: trabajadores.length,
              itemBuilder: (context, index) {
                final trabajador = trabajadores[index];
                final datosTrabajador = trabajadoresDatos[trabajador]!;
                return Card(
                  color: datosTrabajador['completado'] ? Colors.green : null, // Cambio de color basado en completitud
                  child: ListTile(
                    title: Text(trabajador),
                    trailing: datosTrabajador['completado']
                        ? Icon(Icons.check, color: Colors.white) // Icono de completitud
                        : null,
                    onTap: () => _mostrarDialogoNomina(trabajador),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generarNomina,
        child: const Icon(Icons.check),
        tooltip: 'Generar Nómina',
      ),
    );
  }
}

// Datos ficticios de trabajadores
final List<String> trabajadores = ['Juan Pérez', 'María López', 'Carlos Sánchez'];
