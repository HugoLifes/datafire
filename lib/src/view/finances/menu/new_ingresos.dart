import 'package:datafire/src/model/ingresos_model.dart';
import 'package:datafire/src/widgets/table_scrolleable.dart';
import 'package:flutter/material.dart';

class NewIngresos extends StatefulWidget {
  List<IngresosScheme>? ingresoScheme = [];
  NewIngresos({super.key, this.ingresoScheme});

  @override
  State<NewIngresos> createState() => _IngresosState();
}

class _IngresosState extends State<NewIngresos> {
  late ScrollController verticalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IncomeCard(
            title: 'Ultimo Ingreso',
            amount: '\$ ${widget.ingresoScheme?.last.totalWeeklyAbonos}',
            descripcion: 'Ultimo ingreso de proyecto',
          ),
          const IncomeCard(
            title: 'Ingreso del mes',
            amount: '\$55,000',
            descripcion: 'Detalles de los ingresos del mes',
          ),
          const IncomeCard(
            title: 'Ingresos en transcurso',
            amount: '\$150,000',
            descripcion: 'Ingreso transcurrido anual',
          )
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      Flexible(
          child: TableTemplate(
        verticalController: verticalController,
        ingresoScheme: widget.ingresoScheme,
      ))
    ]);
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
