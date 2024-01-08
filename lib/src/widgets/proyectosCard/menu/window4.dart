import 'package:datafire/src/services/costos.servicio.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/form_agregar_costo.dart';
import 'package:flutter/material.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/form_Editar%20_costo.dart';

import 'package:flutter/material.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/form_Editar%20_costo.dart';

class Tab4Content extends StatefulWidget {
  final String idProyecto;

  const Tab4Content({Key? key, required this.idProyecto}) : super(key: key);

  @override
  _Tab4ContentState createState() => _Tab4ContentState();
}

class _Tab4ContentState extends State<Tab4Content> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<dynamic>>(
        future: fetchCostsByProjectId(widget.idProyecto),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text("No hay servicios asociados al proyecto.");
          } else {
            List<dynamic> serviciosProyecto = snapshot.data!.where((servicio) =>
              servicio["project_id"].toString() == widget.idProyecto
            ).toList();

            return ListView.builder(
              itemCount: serviciosProyecto.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Card(
                    color: Colors.green[200],
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const  Icon(Icons.payments_outlined),
                          title:  Text("Costo inicial", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w700),),
                          subtitle: const  Text("Costo inicial"),
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
                          leading: Icon(Icons.payments_outlined),
                          title: Text(servicio["cost"]?.toString() ?? "", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w700),),
                          subtitle: Text(servicio["service"]?.toString() ?? ""),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditarCostoDialog(costo: servicio);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(height: 10),
                      Center(
                        child: IconButton.filled(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 24.0),
                            ),
                          ),
                          onPressed: () {
                            _mostrarDialogo();
                          },
                          icon: Icon(Icons.add),
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
          title: Text("Agregar nuevo costo"),
          content: TuFormularioCosto(id_proyecto: widget.idProyecto),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }
}