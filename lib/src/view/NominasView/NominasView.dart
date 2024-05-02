import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class NominasView extends StatefulWidget {
  const NominasView({Key? key}) : super(key: key);

  @override
  State<NominasView> createState() => _NominasViewState();
}

class _NominasViewState extends State<NominasView> {
  DateTime? fechaInicioSemana;
  DateTime? fechaFinSemana;
  Map<String, dynamic> trabajadoresDatos = {};
  List<String> trabajadores = [];

  @override
  void initState() {
    super.initState();
    fetchTrabajadores();
  }

  Future<void> fetchTrabajadores() async {
    const url = "http://localhost:3000/Api/v1/trabajadores";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          trabajadores = List<String>.from(data.map((trabajador) =>
              "${trabajador['id']} ${trabajador['name']} ${trabajador['last_name']} \$${trabajador['salary_hour']} por hora"));
          trabajadoresDatos = Map.fromIterable(data,
              key: (trabajador) => trabajador['id'].toString(),
              value: (trabajador) => {
                    'completado': false,
                    'horasTrabajadas': 0,
                    'horasExtra': 0,
                    'salary_hour':
                        double.tryParse(trabajador['salary_hour'].toString()) ??
                            0.0,
                  });
        });
      } else {
        throw Exception('Failed to load trabajadores');
      }
    } catch (e) {
      throw Exception('Failed to load trabajadores: $e');
    }
  }

  double calcularTotalSemanal() {
    return trabajadoresDatos.values.where((datos) => datos['completado']).fold(
        0.0,
        (total, datos) =>
            total +
            datos['salary_hour'] *
                (datos['horasTrabajadas'] + datos['horasExtra']));
  }

  void generarNomina() async {
    if (fechaInicioSemana == null || fechaFinSemana == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Por favor, selecciona las fechas de inicio y fin de la semana."),
      ));
      return;
    }
    if (trabajadoresDatos.values.any((datos) => !datos['completado'])) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No todos los trabajadores están completados."),
      ));
      return;
    }

    List<Future> nominasFutures = [];

    String fechaInicio = fechaInicioSemana!.toIso8601String();
    String fechaFin = fechaFinSemana!.toIso8601String();

    trabajadoresDatos.forEach((id, datos) {
      if (datos['completado']) {
        var nominaData = {
          "fecha_inicio_semana": fechaInicio,
          "fecha_fin_semana": fechaFin,
          "worker_id": int.parse(id),
          "nombre": trabajadores
              .firstWhere((nombre) => nombre.startsWith(id))
              .split(" ")
              .sublist(1)
              .join(" "),
          "salary_hour": datos['salary_hour'],
          "horas_trabajadas": datos['horasTrabajadas'],
          "horas_extra": datos['horasExtra'],
        };
        nominasFutures.add(enviarDatosNomina(nominaData));
      }
    });

    await Future.wait(nominasFutures);

    // Muestra un diálogo de éxito y cierra la pantalla actual
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Éxito"),
          content: const Text("Las nóminas han sido creadas con éxito."),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> enviarDatosNomina(Map<String, dynamic> nominaData) async {
    const url = "http://localhost:3000/Api/v1/nominasSemanales";
    try {
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(nominaData));
      if (response.statusCode == 200) {
        print(
            "Datos enviados correctamente para el trabajador ID: ${nominaData['worker_id']}");
      } else {
        print(
            "Error en la solicitud: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Error al enviar datos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nóminas"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => seleccionarSemana(context),
              tooltip: 'Seleccionar Semana'),
        ],
      ),
      body: Column(
        children: [
          if (fechaInicioSemana != null && fechaFinSemana != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Semana de nómina: ${DateFormat('dd/MM/yyyy').format(fechaInicioSemana!)} - ${DateFormat('dd/MM/yyyy').format(fechaFinSemana!)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: trabajadores.length,
              itemBuilder: (context, index) {
                final trabajadorId = trabajadores[index].split(" ")[0];
                final trabajadorDatos = trabajadoresDatos[trabajadorId]!;
                final double salarioTotal = trabajadorDatos['salary_hour'] *
                    (trabajadorDatos['horasTrabajadas'] +
                        trabajadorDatos['horasExtra']);

                return Card(
                  color: trabajadorDatos['completado']
                      ? Colors.green[400]
                      : Colors.white,
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: ListTile(
                    title: Text(trabajadores[index]),
                    subtitle: trabajadorDatos['completado']
                        ? Text(
                            "Total a pagar: \$${salarioTotal.toStringAsFixed(2)}")
                        : null,
                    onTap: () => mostrarDialogoNomina(trabajadorId),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'Total Semanal: \$${calcularTotalSemanal().toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: generarNomina,
        backgroundColor: Colors.green,
        tooltip: 'Generar Nómina',
        child: const Icon(Icons.publish),
      ),
    );
  }

  Future<void> seleccionarSemana(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        fechaInicioSemana = DateTime(picked.year, picked.month,
            picked.day - (picked.weekday - DateTime.monday));
        fechaFinSemana = fechaInicioSemana!.add(const Duration(days: 6));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Selección inválida, por favor selecciona un lunes para iniciar la semana.'),
      ));
    }
  }

  void mostrarDialogoNomina(String trabajadorId) {
    if (fechaInicioSemana == null || fechaFinSemana == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Por favor, selecciona primero las fechas de inicio y fin de la semana."),
      ));
      return;
    }
    final TextEditingController horasTrabajadasController =
        TextEditingController();
    final TextEditingController horasExtraController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Ingresar Nómina para ${trabajadores.firstWhere((nombre) => nombre.startsWith(trabajadorId)).split(" ").skip(1).join(" ")}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  'Semana del ${DateFormat('dd/MM/yyyy').format(fechaInicioSemana!)} al ${DateFormat('dd/MM/yyyy').format(fechaFinSemana!)}'),
              TextField(
                  controller: horasTrabajadasController,
                  decoration:
                      const InputDecoration(labelText: 'Horas trabajadas'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: horasExtraController,
                  decoration: const InputDecoration(labelText: 'Horas extra'),
                  keyboardType: TextInputType.number),
            ],
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop()),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                setState(() {
                  trabajadoresDatos[trabajadorId]!['completado'] = true;
                  trabajadoresDatos[trabajadorId]!['horasTrabajadas'] =
                      int.tryParse(horasTrabajadasController.text) ?? 0;
                  trabajadoresDatos[trabajadorId]!['horasExtra'] =
                      int.tryParse(horasExtraController.text) ?? 0;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
