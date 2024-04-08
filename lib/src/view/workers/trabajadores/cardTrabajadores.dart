import 'package:datafire/src/view/workers/trabajadores/editarTrabajadores.dart';
import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/material.dart';

class TrabajadorCard extends StatefulWidget {
  final Map<String, dynamic> trabajador;

  const TrabajadorCard({super.key, Key? customKey, required this.trabajador});

  @override
  State<TrabajadorCard> createState() => _TrabajadorCardState();
}

class _TrabajadorCardState extends State<TrabajadorCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: canvasColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 5)),
        ],
      ),
      child: InkWell(
        hoverColor: accentCanvasColor,
        onTap: () {
          debugPrint('Trabajador ID: ${widget.trabajador["id"]} selected!');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetallesYEditarTrabajadoresPage(
                      trabajador: widget.trabajador)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const Text(
                  'ID Trabajador:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.trabajador["id"].toString(),
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
                  widget.trabajador["name"],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Apellidos:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.trabajador["last_name"],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Edad:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.trabajador["age"].toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Cargo:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.trabajador["position"],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Salario:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.trabajador["salary"].toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
