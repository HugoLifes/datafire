import 'package:datafire/src/widgets/colors.dart';
import 'package:datafire/src/view/Customers/ClientesCard/editarCliente.dart';
import 'package:flutter/material.dart';

//nombre de clases la primera mayuscula
class ClienteCard extends StatefulWidget {
  final Map<String, dynamic> cliente;
  const ClienteCard({Key? key, required this.cliente}) : super(key: key);
  @override
  State<ClienteCard> createState() => _ClienteCardState();
}

//nombre de clases la primera mayuscula
class _ClienteCardState extends State<ClienteCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: false,
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: InkWell(
        hoverColor: Colors.grey.withOpacity(0.1),
        onTap: () {
          debugPrint('Cliente ID: ${widget.cliente["id"]} selected!');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DetallesYEditarClientesPage(cliente: widget.cliente)));
        },
        child: Container(
          padding: EdgeInsets.all(10),
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
                    'Apellidos:',
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
      ),
    );
  }
}
