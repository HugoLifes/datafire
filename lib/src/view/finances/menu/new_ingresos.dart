import 'package:datafire/src/model/ingresos_model.dart';
import 'package:datafire/src/widgets/table_scrolleable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewIngresos extends StatefulWidget {
  List<IngresosScheme>? ingresoScheme = [];
  List<AbonoScheme>? abono = [];
  NewIngresos({super.key, this.ingresoScheme, this.abono});

  @override
  State<NewIngresos> createState() => _IngresosState();
}

class _IngresosState extends State<NewIngresos> {
  late ScrollController verticalController = ScrollController();
  int ingresoMes = 0;
  int ingresoAnual = 0;
  final NumberFormat numberFormat = NumberFormat("#,##0.00", "es_MX");

  @override
  void initState() {
    calculos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IncomeCard(
            title: 'Ultimo Ingreso',
            amount: '\$ ${numberFormat.format(widget.abono!.last.amount)} MXN',
            descripcion: 'Ultimo ingreso de proyecto',
          ),
          IncomeCard(
            title: 'Ingreso del mes',
            amount: '\$ ${numberFormat.format(ingresoMes)} MXN',
            descripcion: 'Detalles de los ingresos del mes',
          ),
          IncomeCard(
            title: 'Ingresos en transcurso',
            amount: '\$ ${numberFormat.format(ingresoAnual)} MXN',
            descripcion: 'Ingreso transcurrido anual',
          )
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      Flexible(
          child: TableTemplate(
        isEgresos: false,
        verticalController: verticalController,
        ingresoScheme: widget.ingresoScheme,
        abono: widget.abono,
        isFlujo: false,
      ))
    ]);
  }

  calculos() {
    int mesActual = DateTime.now().month;
    for (int i = 0; i < widget.ingresoScheme!.length; i++) {
      ingresoAnual += widget.ingresoScheme![i].totalWeeklyAbonos;
    }

    for (int i = 0; i < widget.abono!.length; i++) {
      if (mesActual == widget.abono![i].date.month) {
        ingresoMes += widget.abono![i].amount;
      }
    }
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
                  fontFamily: 'GoogleSans',
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
                  fontFamily: 'GoogleSans',
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                descripcion,
                style: const TextStyle(
                  fontFamily: 'GoogleSans',
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
