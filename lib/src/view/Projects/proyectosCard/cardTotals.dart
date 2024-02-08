import 'package:datafire/src/services/proyectos.service.dart';
import 'package:flutter/material.dart';

class CardTotals extends StatefulWidget {
  final Map<String, dynamic>? proyecto;

  const CardTotals({Key? key, required this.proyecto}) : super(key: key);

  @override
  _CardTotalsState createState() => _CardTotalsState();
}

class _CardTotalsState extends State<CardTotals> {
  late TextEditingController costoController;
  late TextEditingController abonadoController;
  late TextEditingController remainingController;
  late String costo;
  late String abonado;
  late String remaining;

  @override
  void initState() {
    super.initState();
    costoController = TextEditingController(text: widget.proyecto?["costo"].toString() ?? "Sin costo total");
    abonadoController = TextEditingController(text: widget.proyecto?["abonado"].toString() ?? "sin abonos");
    remainingController = TextEditingController(text: widget.proyecto?["remaining"].toString() ?? "sin abonos");
    costo = widget.proyecto?["costo"].toString() ?? "Sin costo total";
    abonado = widget.proyecto?["abonado"].toString() ?? "sin abonos";
    remaining = widget.proyecto?["remaining"].toString() ?? "sin abonos";
  }

Future<void> actualizarDatos() async {
  try {
    final String projectId = widget.proyecto?["id"].toString() ?? "";

    final Map<String, dynamic> proyecto = await fetchProjectById(projectId);

    setState(() {
      costoController.text = proyecto["costo"].toString();
      abonadoController.text = proyecto["abonado"].toString();
      remainingController.text = proyecto["remaining"].toString();

      // Actualiza los valores de costo, abonado y remaining
      costo = proyecto["costo"].toString();
      abonado = proyecto["abonado"].toString();
      remaining = proyecto["remaining"].toString();
    });

  // ignore: empty_catches
  } catch (err) {
    
  }
}

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150.0,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                "Total:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                "\$$costo",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
        Container(
          width: 150.0,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.amber, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                "Abonado:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                "\$$abonado",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
        Container(
          width: 150.0,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.deepOrange, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                "Restante:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                "\$$remaining",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
        IconButton.filled(onPressed: () {
          actualizarDatos();
        }, icon: const Icon(Icons.refresh))
      ],
    );
  }
}
