import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:datafire/src/services/abonos.service.dart';
import 'package:datafire/src/view/Projects/proyectosCard/menu/window6Adjustemns/form_agregar_ajuste.dart';
import 'package:flutter/material.dart';
import 'package:datafire/src/services/Ajustes.service.dart';
import 'package:intl/intl.dart'; // Import the intl package

class Tab6Content extends StatefulWidget {
  final String idProyecto;

  const Tab6Content({Key? key, required this.idProyecto}) : super(key: key);

  @override
  _Tab6ContentState createState() => _Tab6ContentState();
}

class _Tab6ContentState extends State<Tab6Content> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<dynamic>>(
        future: fetchAjustesById(widget.idProyecto),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("No hay Ajustes asociados al proyecto.");
          } else {
            List<dynamic> ajustes = snapshot.data!.where((ajuste) =>
              ajuste["projectId"].toString() == widget.idProyecto
            ).toList();

            return ListView.builder(
              itemCount: ajustes.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Card(
                    color: Colors.green[200],
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color.fromARGB(255, 192, 253, 194), width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.payments_outlined),
                      title: Text("Ajustes en el presupuesto", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w700)),
                      subtitle: Text("Ajustes:"),
                    ),
                  );
                } else if (index < ajustes.length + 1) {
                  var ajuste = ajustes[index - 1];
                  bool isOperationTrue = ajuste["operation"] == true; 
                  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(ajuste["fecha_ajuste"]));
                  return Card(
                    color: isOperationTrue ? Colors.green : Colors.red,
                    child: ListTile(
                      leading: const Icon(Icons.payments_outlined),
                      title: Text("\$${ajuste["monto"]?.toString()}", style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w700)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formattedDate),
                          Text(ajuste["motive"] ?? "error al cargar")
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.scale,
                            title: "Eliminar Ajuste",
                            desc: "¿Estas seguro que quieres eliminar este Ajuste?",
                            width: 620,
                            btnCancelOnPress: (){},
                            btnOkOnPress: () {
                              deleteAjuste(ajuste["id"]);
                            },
                          ).show();
                        },
                      ),
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
          title: const Text("Agregar nuevo Ajuste"),
          content: AddAdjustmentForm(idProyecto: widget.idProyecto),  
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
