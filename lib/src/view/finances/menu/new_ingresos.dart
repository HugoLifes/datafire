import 'package:datafire/src/widgets/table_scrolleable.dart';
import 'package:flutter/material.dart';

class Ingresos extends StatefulWidget {
  const Ingresos({super.key});

  @override
  State<Ingresos> createState() => _IngresosState();
}

class _IngresosState extends State<Ingresos> {
  late ScrollController verticalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IncomeCard(
              title: 'Ultimo Ingreso',
              amount: '\$8500',
              descripcion: 'Ultimo ingreso de proyecto',
            ),
            IncomeCard(
              title: 'Ingreso del mes',
              amount: '\$55,000',
              descripcion: 'Detalles de los ingresos del mes',
            ),
            IncomeCard(
              title: 'Ingresos en transcurso',
              amount: '\$150,000',
              descripcion: 'Ingreso transcurrido anual',
            )
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Flexible(child: TableTemplate(verticalController: verticalController))
      ]),
    );
  }
}

class IncomeCard extends StatelessWidget {
  final String title;
  final String amount;
  final String descripcion;
  const IncomeCard(
      {Key? key,
      required this.amount,
      required this.descripcion,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                descripcion,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
