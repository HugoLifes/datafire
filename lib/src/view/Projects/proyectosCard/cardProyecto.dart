import 'package:datafire/src/widgets/colors.dart';
import 'package:datafire/src/widgets/proyectosCard/editarProyecto.dart';
import 'package:flutter/material.dart';

class ProyectoCard extends StatefulWidget {
  final Map<String, dynamic> proyecto;

  const ProyectoCard({Key? key, required this.proyecto}) : super(key: key);

  @override
  _ProyectoCardState createState() => _ProyectoCardState();
}

class _ProyectoCardState extends State<ProyectoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: canvasColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        hoverColor: accentCanvasColor,
        onTap: () {
          debugPrint('Proyecto ID: ${widget.proyecto["id"]} selected!');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetallesYAltaProyectoPage(proyecto: widget.proyecto),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const Text(
                  'ID Proyecto:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.proyecto["id"].toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                )
              ],
            ),
            Row(
              children: [
                const Text(
                  'Nombre:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.proyecto["name"],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Fecha Inicio:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.proyecto["fecha_inicio"],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Fecha Fin:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.proyecto["fecha_fin"],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
