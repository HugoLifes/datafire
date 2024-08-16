import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:datafire/src/services/abonos.service.dart';
import 'package:datafire/src/view/Projects/proyectosCard/menu/window5/form_agregar_abono.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class Tab5Content extends StatefulWidget {
  final String idProyecto;

  const Tab5Content({Key? key, required this.idProyecto}) : super(key: key);

  @override
  _Tab5ContentState createState() => _Tab5ContentState();
}

class _Tab5ContentState extends State<Tab5Content> {
  bool _loaderOverlay = false;

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
            return Column(
              children: [
                const SizedBox(height: 10),
                Center(
                  child: IconButton.filled(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(horizontal: 24.0),
                      ),
                    ),
                    onPressed: () => _mostrarDialogo(context),
                    icon: const Icon(Icons.add),
                  ),
                ),
              ],
            );
          } else {
            List<dynamic> serviciosProyecto = snapshot.data!
                .where((servicio) =>
                    servicio["projectId"].toString() == widget.idProyecto)
                .toList();

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
                    child: const Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.payments_outlined),
                          title: Text(
                            "Abonos dados por el cliente",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text("Abonos:"),
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
                          title: Text(
                            "\$${abono["monto"]?.toString()}",
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700),
                          ),
                          subtitle:
                              Text(abono["fecha_abono"]?.toString() ?? ""),
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
                                btnOkOnPress: () async {
                                  context.loaderOverlay.show();
                                  setState(() {
                                    _loaderOverlay =
                                        context.loaderOverlay.visible;
                                  });
                                  deleteAbono(abono["id"]).whenComplete(() {
                                    if (_loaderOverlay) {
                                      context.loaderOverlay.hide();
                                    }

                                    setState(() {
                                      _loaderOverlay = false;
                                    });
                                  });
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
                          onPressed: () => _mostrarDialogo(context),
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
