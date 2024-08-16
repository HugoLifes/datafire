import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:datafire/src/view/workers/trabajadores/menu/tools/addTools.dart';

class ToolsTab extends StatefulWidget {
  final String workerId;
  final int salary;

  const ToolsTab({
    Key? key,
    required this.workerId,
    required this.salary,
  }) : super(key: key);

  @override
  _ToolsTabState createState() => _ToolsTabState();
}

class _ToolsTabState extends State<ToolsTab> {
  int totalCosts = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<dynamic>>(
        future: fetchWorkerToolsById(widget.workerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("No hay Herramientas asociadas al proyecto.");
          } else {
            List<dynamic> serviciosProyecto = snapshot.data!
                .where((servicio) =>
                    servicio["worker_id"].toString() == widget.workerId)
                .toList();

            totalCosts = serviciosProyecto.fold<int>(widget.salary,
                (sum, abono) => ((abono["cost"] ?? 0)).toInt());

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
                          title: Text("\$$totalCosts"),
                          subtitle: const Text("Suma total de herramientas compradas al trabajador"),
                        ),
                      ],
                    ),
                  );
                } else if (index < serviciosProyecto.length + 1) {
                  var abono = serviciosProyecto[index - 1];
                  String formattedDate = abono["fecha_adquisicion"] != null
                      ? DateFormat('yyyy-MM-dd').format(DateTime.parse(abono["fecha_adquisicion"]))
                      : "Fecha no disponible";
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
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(abono["tool_name"]?.toString() ?? ""),
                              Text(formattedDate),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.scale,
                                title: "Eliminar Herramienta",
                                desc:
                                    "¿Estas seguro que quieres eliminar esta Herramienta?",
                                width: 620,
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {
                                  deleteTool(abono["id"]);
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
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
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
          title: const Text("Agregar nueva herramienta"),
          content: AddToolForm(workerId: widget.workerId),
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
