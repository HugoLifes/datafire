import 'package:datafire/src/model/flujo_caja_model.dart';
import 'package:datafire/src/model/ingresos_model.dart';
import 'package:datafire/src/model/nominas_semanales.dart';
import 'package:datafire/src/model/prestamos_model.dart';
import 'package:datafire/src/model/workers_model.dart';
import 'package:datafire/src/widgets/table_scrolleable.dart';
import 'package:flutter/material.dart';

class NewFlujo extends StatefulWidget {
  NewFlujo({
    super.key,
    this.flujo,
  });
  List<FlujoCaja>? flujo = [];

  @override
  State<NewFlujo> createState() => _NewFlujoState();
}

class _NewFlujoState extends State<NewFlujo> {
  late ScrollController verticalController = ScrollController();
  late ScrollController horizontalController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return TableTemplate(
      isEgresos: false,
      verticalController: verticalController,
      horizontalController: horizontalController,
      flujo: widget.flujo,
      isFlujo: true,
    );
  }
}
