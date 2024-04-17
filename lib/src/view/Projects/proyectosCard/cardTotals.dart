import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

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
  late IOWebSocketChannel channel;
  late int ganancia;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con valores por defecto o provenientes del proyecto inicial
    initializeControllersAndValues();

    // Configura la conexión WebSocket
    setupWebSocket();
  }

  void initializeControllersAndValues() {
    costoController = TextEditingController(
        text: widget.proyecto?["costo"].toString() ?? "0");
    abonadoController = TextEditingController(
        text: widget.proyecto?["abonado"].toString() ?? "0");
    remainingController = TextEditingController(
        text: widget.proyecto?["remaining"].toString() ?? "0");
    costo = widget.proyecto?["costo"].toString() ?? "0";
    abonado = widget.proyecto?["abonado"].toString() ?? "0";
    remaining = widget.proyecto?["presupuesto"].toString() ?? "0";
    ganancia = widget.proyecto?['abonado'] - widget.proyecto?['costo'] ?? "0";
  }

  void setupWebSocket() {
    channel = IOWebSocketChannel.connect('ws://localhost:3000');

    channel.stream.listen((message) {
      print("Datos recibidos del socket: $message");
      final proyectoActualizado = jsonDecode(message);

      setState(() {
        updateProjectInfo(proyectoActualizado);
      });
    });
  }

  void updateProjectInfo(dynamic proyecto) {
    costoController.text = proyecto["costo"].toString();
    abonadoController.text = proyecto["abonado"].toString();
    remainingController.text = proyecto["remaining"].toString();
    costo = proyecto["costo"].toString();
    abonado = proyecto["abonado"].toString();
    remaining = proyecto["remaining"].toString();
    ganancia = proyecto["abonado"] - proyecto['costo'];
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCard(
              "Gastado:", "\$$costo", Colors.lightBlueAccent, Colors.blue),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCard("Abonado:", "\$$abonado", Colors.amber, Colors.orange),
              _buildCard("Ganancia:", "\$${ganancia.toString()}",
                  Colors.greenAccent, Colors.green),
            ],
          ),
          _buildCard(
              "Presupuesto:", "\$$remaining", Colors.deepOrange, Colors.red),
        ],
      ),
    );
  }

  Widget _buildCard(
      String title, String value, Color startColor, Color endColor) {
    return Container(
      width: 170.0,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
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
          Text(
            title,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
