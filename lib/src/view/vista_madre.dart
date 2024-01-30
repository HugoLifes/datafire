import 'package:datafire/src/view/alta_trabajadores.dart';
import 'package:datafire/src/view/subida_clientes.dart';
import 'package:datafire/src/view/subida_proyectos.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import 'home.dart';

//Esta vista une todos los accessos a los modulos existentes
class MotherView extends StatelessWidget {
  const MotherView({super.key, required this.controller});
  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // se usa para poder trabajar las dimensiones
    var size = MediaQuery.of(context).size;
    return AnimatedBuilder(
        animation: controller,
        builder: (ctx, child) {
          switch (controller.selectedIndex) {
            case 0:
              return Home();
            case 1:
              return AltaProyectos();
            case 2:
              return AltaClientes();
            case 3:
              return AltaTrabajadores();
            case 4:
            default:
              return Text(
                'Page not found',
                style: theme.textTheme.headlineSmall,
              );
          }
        });
  }
}
