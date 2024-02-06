import 'package:datafire/src/services/abonos.service.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/window5/form_agregar_abono.dart';
import 'package:flutter/material.dart';



class Tab5Content extends StatefulWidget {
  final String idProyecto;

  const Tab5Content({Key? key, required this.idProyecto}) : super(key: key);

  @override
  _Tab5ContentState createState() => _Tab5ContentState();
}

class _Tab5ContentState extends State<Tab5Content> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<dynamic>>(
        future: fetchAbonosById(widget.idProyecto),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("No hay Abonos asociados al proyecto.");
          } else {
            List<dynamic> serviciosProyecto = snapshot.data!.where((servicio) =>
              servicio["projectId"].toString() == widget.idProyecto
            ).toList();

            return ListView.builder(
              itemCount: serviciosProyecto.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Card(
                    color: Colors.green[200],
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color.fromARGB(255, 192, 253, 194), width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.payments_outlined),
                          title:  Text("\$200", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w700),),
                          subtitle: Text("Pago inicial"),
                        ),
                      ],
                    ),
                  );
                } else if (index < serviciosProyecto.length + 1) {
                  var abono = serviciosProyecto[index - 1];
                  return Card(
                    color: Colors.yellow[200],
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.payments_outlined),
                          title: Text("\$${abono["monto"]?.toString()}", style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w700),),
                          subtitle: Text(abono["fecha_abono"]?.toString() ?? ""),
                          trailing:IconButton(
                            icon:  Icon(Icons.delete),
                            onPressed: () {
                              print([""]);
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
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
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
          content: addAbonoForm(id_proyecto: widget.idProyecto),
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

