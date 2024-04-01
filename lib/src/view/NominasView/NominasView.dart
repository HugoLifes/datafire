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
  Map<String, Map<String, dynamic>> trabajadoresDatos = {};
  List<String> trabajadores = [];

  @override
  void initState() {
    super.initState();
    fetchTrabajadores();
  }

  Future<void> fetchTrabajadores() async {
    const url =
        "https://datafire-production.up.railway.app/Api/v1/trabajadores";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          trabajadores = data
              .map<String>((trabajador) =>
                  "${trabajador["id"]} ${trabajador['name']} ${trabajador['last_name']} ${trabajador['salary_hour']}")
              .toList();
          for (var trabajador in data) {
            trabajadoresDatos[trabajador["id"].toString()] = {
              'completado': false,
              'horasTrabajadas': 0,
              'horasExtra': 0,
              'salary_hour': trabajador['salary_hour'] != null
                  ? double.parse(trabajador['salary_hour'].toString())
                  : 0.0,
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

  double calcularTotalSemanal() {
    double totalSemanal = 0.0;
    trabajadoresDatos.forEach((id, datos) {
      if (datos['completado']) {
        final double salaryHour = datos['salary_hour'];
        final int horasTrabajadas = datos['horasTrabajadas'];
        final int horasExtra = datos['horasExtra'];
        final double salarioTotal = salaryHour * (horasTrabajadas + horasExtra);
        totalSemanal += salarioTotal;
      }
    });
    return totalSemanal;
  }

  void _seleccionarSemana(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      if (picked.weekday == DateTime.monday) {
        // La fecha seleccionada es lunes
        DateTime startOfWeek = picked;
        DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

        setState(() {
          fechaInicioSemana = startOfWeek;
          fechaFinSemana = endOfWeek;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Selección inválida'),
              content: Text(
                  'Por favor, selecciona un lunes para iniciar la semana.'),
              actions: <Widget>[
                TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            );
          },
        );
      }
    }
  }

  void _mostrarDialogoNomina(String trabajadorId) {
    if (fechaInicioSemana == null || fechaFinSemana == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Por favor, selecciona primero las fechas de inicio y fin de la semana.")));
      return;
    }

    final TextEditingController _horasTrabajadasController =
        TextEditingController();
    final TextEditingController _horasExtraController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Ingresar Nómina para ${trabajadores.firstWhere((nombre) => nombre.startsWith(trabajadorId)).split(" ").skip(1).join(" ")}'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                    'Semana del ${DateFormat('dd/MM/yyyy').format(fechaInicioSemana!)} al ${DateFormat('dd/MM/yyyy').format(fechaFinSemana!)}'),
                TextField(
                  controller: _horasTrabajadasController,
                  decoration: InputDecoration(labelText: 'Horas trabajadas'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _horasExtraController,
                  decoration: InputDecoration(labelText: 'Horas extra'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop()),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                final int horasTrabajadas =
                    int.tryParse(_horasTrabajadasController.text) ?? 0;
                final int horasExtra =
                    int.tryParse(_horasExtraController.text) ?? 0;
                setState(() {
                  trabajadoresDatos[trabajadorId] = {
                    ...trabajadoresDatos[trabajadorId]!,
                    'completado': true,
                    'horasTrabajadas': horasTrabajadas,
                    'horasExtra': horasExtra,
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
    if (fechaInicioSemana == null || fechaFinSemana == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Por favor, selecciona las fechas de inicio y fin de la semana.")));
      return;
    }
    if (trabajadoresDatos.values.any((datos) => !datos['completado'])) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No todos los trabajadores están completados.")));
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
        "nombre": trabajadores
            .firstWhere((nombre) => nombre.startsWith(idTrabajador))
            .split(" ")
            .sublist(1)
            .join(" "),
        "salary_hour": trabajadorDatos['salary_hour'] ?? 1.0,
        "horas_trabajadas": trabajadorDatos['horasTrabajadas'],
        "horas_extra": trabajadorDatos['horasExtra'],
      };

      _enviarDatosNomina(nominaData);
    });
  }

  void _enviarDatosNomina(Map<String, dynamic> nominaData) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://datafire-production.up.railway.app/Api/v1/nominasSemanales"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(nominaData),
      );

      if (response.statusCode == 200) {
        // Manejar la respuesta exitosa aquí
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
    double totalSemanal = calcularTotalSemanal();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nóminas"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _seleccionarSemana(context),
            tooltip: 'Seleccionar Semana',
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: trabajadores.length,
              itemBuilder: (context, index) {
                final trabajadorId = trabajadores[index].split(" ")[0];
                final trabajadorDatos = trabajadoresDatos[trabajadorId]!;

                final int horasTrabajadas =
                    trabajadorDatos['horasTrabajadas'] ?? 0;
                final int horasExtra = trabajadorDatos['horasExtra'] ?? 0;
                final double salaryHour = trabajadorDatos['salary_hour'] ?? 0.0;
                final double salarioTotal =
                    salaryHour * (horasTrabajadas + horasExtra);

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
                    trailing: Icon(
                      trabajadorDatos['completado']
                          ? Icons.check_circle_outline
                          : Icons.radio_button_unchecked,
                      color: trabajadorDatos['completado']
                          ? Colors.white
                          : Colors.grey,
                    ),
                    onTap: () => _mostrarDialogoNomina(trabajadorId),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total Semanal: \$${totalSemanal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generarNomina,
        backgroundColor: Colors.green,
        child: const Icon(Icons.publish),
        tooltip: 'Generar Nómina',
      ),
    );
  }
}
