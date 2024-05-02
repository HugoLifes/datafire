import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:datafire/src/services/costos.servicio.dart';
import 'package:datafire/src/view/Projects/proyectosCard/menu/window4/form_Editar%20_costo.dart';
import 'package:datafire/src/view/Projects/proyectosCard/menu/window4/form_agregar_costo.dart';
import 'package:flutter/material.dart';

class Tab4Content extends StatefulWidget {
  final String idProyecto;
  final String costoInicial;

  const Tab4Content(
      {Key? key, required this.idProyecto, required this.costoInicial})
      : super(key: key);

  @override
  _Tab4ContentState createState() => _Tab4ContentState();
}

class _Tab4ContentState extends State<Tab4Content> {
  late Future<List<dynamic>> futureCostos;

  @override
  void initState() {
    super.initState();
    print(widget.idProyecto);
    futureCostos = fetchCostsByProjectId(widget.idProyecto);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<dynamic>>(
        future: futureCostos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("No hay servicios asociados al proyecto.");
          } else {
            List<dynamic> serviciosProyecto = snapshot.data!
                .where((servicio) =>
                    servicio["project_id"].toString() == widget.idProyecto)
                .toList();
            sumarSalarios(serviciosProyecto);
            return ListView.builder(
              itemCount: serviciosProyecto.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Card(
                    color: Colors.green[200],
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.payments_outlined),
                          title: Text(
                            widget.costoInicial,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700),
                          ),
                          subtitle: const Text("Costo inicial"),
                        ),
                      ],
                    ),
                  );
                } else if (index < serviciosProyecto.length + 1) {
                  var servicio = serviciosProyecto[index - 1];
                  return Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.payments_outlined),
                          title: Text(
                            servicio["cost"]?.toString() ?? "",
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(servicio["service"]?.toString() ?? ""),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return EditarCostoDialog(costo: servicio);
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_forever),
                                onPressed: () {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.warning,
                                    animType: AnimType.bottomSlide,
                                    title: 'Eliminar costo',
                                    desc:
                                        '¿Estás seguro de que quieres eliminar este costo?',
                                    width: 620,
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {
                                      deleteCost(servicio["id"]);
                                      setState(() {
                                        futureCostos = fetchCostsByProjectId(
                                            widget.idProyecto);
                                      });
                                    },
                                  ).show();
                                },
                              ),
                            ],
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
                            _mostrarDialogo(context);
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

  void _mostrarDialogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Agregar nuevo costo"),
          content: TuFormularioCosto(
              idProyecto: widget.idProyecto, futureCosts: futureCostos),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  futureCostos = fetchCostsByProjectId(widget.idProyecto);
                });
                Navigator.of(context).pop();
              },
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  sumarSalarios(List<dynamic> list) {
    for (var i in list) {
      print(i);
    }
  }
}
