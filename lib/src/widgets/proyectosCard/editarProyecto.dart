
import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:datafire/src/services/proyectos-clientes.service.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/window1.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/window2.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/window3.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/window4/window4.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/window5/window5.dart';
import 'package:flutter/material.dart';


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
              length: 5,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Detalles'),
                      Tab(text: 'Clientes Asociados'),
                      Tab(text: 'Trabajadores'),
                      Tab(text: "Servicios"),
                      Tab(text: "Pagos")
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
                          child: window2(proyecto: widget.proyecto, idProyecto: _idProyecto,)
                        ),

                        // Contenido para la tercera pestaña
                         Container(
                          padding: const EdgeInsets.all(16.0),
                          child: ThirdTabContent(proyecto: widget.proyecto),
                        ),

                      // window 4 servicios
Tab4Content(idProyecto: _idProyecto),
Tab5Content(idProyecto: _idProyecto)
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


 
}
