import 'package:datafire/src/widgets/colors.dart';
import 'package:datafire/src/widgets/ClientesCard/editarCliente.dart';
import 'package:flutter/material.dart';

class clienteCard extends StatefulWidget {
  final Map<String, dynamic> cliente;

  const clienteCard({Key? key, required this.cliente}) : super(key: key);

  @override
  State<clienteCard> createState() => _clienteCardState();
}

class _clienteCardState extends State<clienteCard> {
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
          debugPrint('Cliente ID: ${widget.cliente["id"]} selected!');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DetallesYEditarClientesPage(cliente: widget.cliente)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const Text(
                  'ID Cliente:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.cliente["id"].toString(),
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
                  widget.cliente["name"],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Apellido:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.cliente["last_name"],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Empresa:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.cliente["company"],
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
