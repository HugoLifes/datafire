import 'package:datafire/src/view/Customers/subida_clientes.dart';
import 'package:datafire/src/view/NominasView/NominasMain.dart';
import 'package:datafire/src/view/Projects/subida_proyectos.dart';
import 'package:datafire/src/view/finances/financesView.dart';
import 'package:datafire/src/view/users/users.verification_view.dart';
import 'package:datafire/src/view/workers/alta_trabajadores.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import 'home.dart';

//Esta vista une todos los accessos a los modulos existentes
class MotherView extends StatelessWidget {
  const MotherView({super.key, required this.controller});
  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (ctx, child) {
          switch (controller.selectedIndex) {
            case 0:
              return const Home();
            case 1:
              return const AltaProyectos();
            case 2:
              return const AltaClientes();
            case 3:
              return const AltaTrabajadores();
            case 4:
              return const FinancesView();
            case 5:
              return const NominasMain();
            case 6:
              return const UserVerificationView();
            default:
              return const Text(
                'Page not found',
                style: TextStyle(
                  fontFamily: 'GoogleSans',
                ),
              );
          }
        });
  }
}
