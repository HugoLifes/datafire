import 'dart:ffi';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:datafire/src/services/abonos.service.dart';
import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:datafire/src/view/Projects/proyectosCard/menu/window5/form_agregar_abono.dart';

import 'package:flutter/material.dart';

class WorkerCostsTab extends StatefulWidget {
  final String idProyecto;
  final int salary;

  const WorkerCostsTab({
    Key? key,
    required this.idProyecto,
    required this.salary,
  }) : super(key: key);

  @override
  _WorkerCostsTabState createState() => _WorkerCostsTabState();
}

class _WorkerCostsTabState extends State<WorkerCostsTab> {
  int totalCosts = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<dynamic>>(
        future: fetchWorkerCostsById(widget.idProyecto),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("No hay Abonos asociados al proyecto.");
          } else {
            List<dynamic> serviciosProyecto = snapshot.data!
                .where((servicio) =>
                    servicio["worker_id"].toString() == widget.idProyecto)
                .toList();

            totalCosts = serviciosProyecto.fold<int>(widget.salary,
                (sum, abono) => (sum + (abono["cost"] ?? 0)).toInt());

            return ListView.builder(
              itemCount: serviciosProyecto.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Card(
                    color: Colors.green[200],
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: Color.fromARGB(255, 192, 253, 194),
                          width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.summarize),
                          title: Text("\$${totalCosts}"),
                          subtitle: const Text("Costo total del trabajador"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.payments_outlined),
                          title: Text("\$${widget.salary}"),
                          subtitle: const Text("Salario semanal"),
                        ),
                      ],
                    ),
                  );
                } else if (index < serviciosProyecto.length + 1) {
                  var abono = serviciosProyecto[index - 1];
                  return Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.payments_outlined),
                          title: Text(
                            "\$${abono["cost"]?.toString()}",
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(abono["service"]?.toString() ?? ""),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.scale,
                                title: "Eliminar abono",
                                desc:
                                    "¿Estas seguro que quieres eliminar este Abono?",
                                width: 620,
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {
                                  deleteAbono(abono["id"]);
                                },
                              ).show();
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: IconButton.filled(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(horizontal: 24.0),
                            ),
                          ),
                          onPressed: () {
                            _mostrarDialogo();
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  void _mostrarDialogo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Agregar nuevo Abono"),
          content: AddAbonoForm(idProyecto: widget.idProyecto),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }
}
