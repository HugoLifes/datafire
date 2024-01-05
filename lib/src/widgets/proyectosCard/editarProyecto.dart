import 'dart:convert';
import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:datafire/src/services/costos.servicio.dart';
import 'package:datafire/src/services/proyectos-clientes.service.dart';
import 'package:datafire/src/services/proyectos.service.dart';
import 'package:datafire/src/services/proyectosTrabajadores.service.dart';
import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/form_Editar%20_costo.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/form_agregar_costo.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/window1.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/window2.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/window3.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:datafire/src/widgets/proyectosCard/form_editarProyecto.dart';

class DetallesYAltaProyectoPage extends StatefulWidget {
  final Map<String, dynamic>? proyecto;

  DetallesYAltaProyectoPage({Key? key, required this.proyecto}) : super(key: key);

  @override
  _DetallesYAltaProyectoPageState createState() => _DetallesYAltaProyectoPageState();
}

class _DetallesYAltaProyectoPageState extends State<DetallesYAltaProyectoPage> {
  final _nombreController = TextEditingController();
  final _inicioController = TextEditingController();
  final _finController = TextEditingController();
  final _costoController = TextEditingController();
  late final String _idProyecto;

  @override
  void initState() {
    super.initState();
    _idProyecto = widget.proyecto?["id"].toString() ?? "";
    _nombreController.text = widget.proyecto?['project_name'] ?? 'Sin nombre';
    _inicioController.text = widget.proyecto?['fecha_inicio'] ?? 'Sin fecha de inicio';
    _finController.text = widget.proyecto?['fecha_fin'] ?? 'Sin fecha de finalización';
    _costoController.text = widget.proyecto?["costo"].toString() ?? "Sin costo total";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles y Editar Proyecto'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Detalles'),
                      Tab(text: 'Clientes Asociados'),
                      Tab(text: 'Trabajadores'),
                      Tab(text: "Servicios",)
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Detalles (Window 1)
                        window1(proyecto: widget.proyecto),

                        // Clientes Asociados (window 2)
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: window2(proyecto: widget.proyecto, selectClientsDialog: _selectClientsDialog, idProyecto: _idProyecto,)
                        ),

                        // Contenido para la tercera pestaña
                         Container(
                          padding: const EdgeInsets.all(16.0),
                          child: ThirdTabContent(proyecto: widget.proyecto),
                        ),

                      // window 4 servicios
Container(
    padding: const EdgeInsets.all(16.0),
    child: FutureBuilder<List<dynamic>>(
      future: fetchCostsByProjectId(_idProyecto),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text("No hay servicios asociados al proyecto.");
        } else {
          // Filtra la lista de servicios para mostrar solo los asociados al proyecto.
          List<dynamic> serviciosProyecto = snapshot.data!.where((servicio) =>
            servicio["project_id"].toString() == _idProyecto
          ).toList();

          // Muestra los servicios en un ListView.
          return ListView.builder(
            itemCount: serviciosProyecto.length + 2, // Añade dos para la bienvenida y el botón.
            itemBuilder: (context, index) {
              if (index == 0) {
                // Primer ítem es la Card de Bienvenida
                return Card(
                  color: Colors.green[200],
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.green, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const  Icon(Icons.payments_outlined),
                        title:  Text(widget.proyecto?["costo"].toString() ?? "", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w700),),
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
                // Último ítem es el botón que abre un diálogo.
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
),

                  

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Formulario en el lado derecho
          Expanded(
            flex: 1,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16.0),
              child: EditarProyectosForm(proyecto: widget.proyecto),
            ),
          ),
        ],
      ),
    );
  }

void _mostrarDialogo() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Agregar nuevo costo"),
        content: TuFormularioCosto(id_proyecto: _idProyecto),
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

  void _selectClientsDialog(String projectId) async {
    List<dynamic> clientes = await fetchClientes();
    List<String> clientesSeleccionados = [];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Selecciona clientes"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: clientes.map((cliente) {
                    bool isSelected = clientesSeleccionados.contains(cliente["id"]?.toString() ?? "");

                    return CheckboxListTile(
                      title: Text(cliente["name"]?.toString() ?? ""),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            if (value) {
                              clientesSeleccionados.add(cliente["id"]?.toString() ?? "");
                            } else {
                              clientesSeleccionados.remove(cliente["id"]?.toString() ?? "");
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                clientesSeleccionados.forEach((clienteId) {
                  postCustomerProject().addCustomerProject(projectId, clienteId);
                });
                Navigator.of(context).pop();
              },
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}
