import 'package:datafire/src/widgets/appBar.dart';
import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/material.dart';

class financesView extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBarDatafire(title: "Finanzas", description: "Aqui tendras acceso a todas las finanzas de los proyectos"))
    );
    
  }
}
