

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
         print("Response body: ${response.body}"); // Añade esto para depurar
        final data = json.decode(response.body);
        setState(() {
          for (var trabajador in data) {
            String key = trabajador["id"].toString();
            trabajadores.add("${trabajador["id"]} ${trabajador['name']} ${trabajador['last_name']}   ${trabajador['salary_hour']}");
            trabajadoresDatos[key] = {
              'completado': false,
              'horasTrabajadas': 0,
              'horasExtra': 0,
              'salary_hour': trabajador['salary_hour'],
            };
          }
        });
      } else {
        throw Exception('Failed to load trabajadores');
      }
    } catch (e) {
      throw Exception('Failed to load trabajadores: $e');
    }
  }

  Future<void> _seleccionarFecha(BuildContext context, bool esFechaInicio) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: esFechaInicio ? DateTime.now() : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != fechaInicioSemana) {
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

  void _generarNomina() async {
    if (fechaInicioSemana == null || fechaFinSemana == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Por favor, selecciona las fechas de inicio y fin de la semana."),
      ));
      return;
    }
    if (trabajadoresDatos.values.any((datos) => !datos['completado'])) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No todos los trabajadores están completados."),
      ));
      return;
    }

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String fechaInicio = formatter.format(fechaInicioSemana!);
    String fechaFin = formatter.format(fechaFinSemana!);

    trabajadoresDatos.forEach((idTrabajador, trabajadorDatos) {
      if (!trabajadorDatos['completado']) {
        print("Faltan datos para el trabajador con ID: $idTrabajador");
        return;
      }

      final Map<String, dynamic> nominaData = {
        "fecha_inicio_semana": fechaInicio,
        "fecha_fin_semana": fechaFin,
        "worker_id": int.parse(idTrabajador),
        "nombre": trabajadores.firstWhere((nombre) => nombre.startsWith(idTrabajador)).split(" ").sublist(1).join(" "),
        "salary_hour": trabajadorDatos['salary_hour'],
        "horas_trabajadas": trabajadorDatos['horasTrabajadas'],
        "horas_extra": trabajadorDatos['horasExtra'],
      };

      _enviarDatosNomina(nominaData);
    });
  }

  void _enviarDatosNomina(Map<String, dynamic> nominaData) async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:3000/Api/v1/nominasSemanales"),
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(nominaData),
      );

      if (response.statusCode == 200) {
        // Manejar la respuesta exitosa aquí
        print("Datos enviados correctamente para el trabajador ID: ${nominaData['worker_id']}");
      } else {
        print("Error en la solicitud: ${response.statusCode}, ${response.body}");
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
                final trabajadorDatos = trabajadoresDatos[trabajador.split(" ")[0]]!;
                return Card(
                  color: trabajadorDatos['completado'] ? Colors.green : null,
                  child: ListTile(
                    title: Text(trabajador),
                    trailing: trabajadorDatos['completado']
                        ? Icon(Icons.check, color: Colors.white)
                        : null,
                    onTap: () => _mostrarDialogoNomina(trabajador.split(" ")[0]),
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