import 'package:datafire/src/model/ingresos_model.dart';
import 'package:datafire/src/model/workers_model.dart';
import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class TableTemplate extends StatefulWidget {
  late final ScrollController verticalController = ScrollController();
  List<IngresosScheme>? ingresoScheme = [];
  List<WorkerScheme>? workerScheme = [];
  bool? isEgresos = false;

  TableTemplate(
      {super.key,
      required verticalController,
      this.ingresoScheme,
      this.workerScheme,
      this.isEgresos});

  @override
  State<TableTemplate> createState() => _TableTemplateState();
}

class _TableTemplateState extends State<TableTemplate> {
  final int _rowCount = 20;

  @override
  void initState() {
    super.initState();

    widget.verticalController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final decoration = TableSpanDecoration(
        border:
            TableSpanBorder(trailing: const BorderSide(color: Colors.black)));
    return Scaffold(
      body: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: widget.isEgresos!
            ? egresosView(colorScheme, decoration)
            : ingresosView(colorScheme, decoration),
      ),
      persistentFooterButtons: [
        TextButton(
          onPressed: () {
            widget.verticalController.jumpTo(0);
          },
          child: const Text('Jump to Top'),
        ),
        TextButton(
          onPressed: () {
            widget.verticalController
                .jumpTo(widget.verticalController.position.maxScrollExtent);
          },
          child: const Text('Jump to Bottom'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Exportar'),
        ),
      ],
    );
  }

  // vista de ingresos
  TableView ingresosView(
      ColorScheme colorScheme, TableSpanDecoration decoration) {
    return TableView.builder(
        verticalDetails:
            ScrollableDetails.vertical(controller: widget.verticalController),
        cellBuilder: (BuildContext ctx, TableVicinity vicinity) {
          final isStickyHeader = vicinity.xIndex == 0 || vicinity.yIndex == 0;
          var label = '';
          if (vicinity.yIndex == 0) {
            switch (vicinity.xIndex) {
              case 0:
                label = 'ID';
                break;
              case 1:
                label = 'Proyecto';
                break;
              case 2:
                label = 'Fecha Inicio';
                break;
              case 3:
                label = 'Fecha Final';
                break;
              case 4:
                label = 'Pago total';
                break;
              case 5:
                label = 'Fecha de pago';
            }
          } else {
            final ingresoCount = widget.ingresoScheme?[vicinity.yIndex - 1];
            final abonoCount = widget
                .ingresoScheme?[vicinity.yIndex - 1].abonos[vicinity.yIndex];
            switch (vicinity.xIndex) {
              case 0:
                label = vicinity.yIndex.toString();
                break;
              case 1:
                if (widget.ingresoScheme?[vicinity.yIndex - 1].abonos == null) {
                  label = "No hay proyecto";
                } else {
                  label = abonoCount!.projectName;
                }
                break;
              case 2:
                label =
                    '${ingresoCount?.startDate.day}/${ingresoCount?.startDate.month}/${ingresoCount?.startDate.year}';
                break;
              case 3:
                label =
                    '${ingresoCount?.endDate.day}/${ingresoCount?.endDate.month}/${ingresoCount?.endDate.year}';
                break;
              case 4:
                label = ingresoCount!.totalWeeklyAbonos.toString();
                break;
              case 5:
                if (widget.ingresoScheme?[vicinity.yIndex - 1].abonos == null) {
                  label = "No hay pago";
                } else {
                  label =
                      '${abonoCount!.date.day}/${abonoCount.date.month}/${abonoCount.date.year}';
                }
            }
          }
          return TableViewCell(
              child: ColoredBox(
            color: isStickyHeader ? Colors.transparent : colorScheme.background,
            child: Center(
              child: FittedBox(
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(label,
                          style: TextStyle(
                            fontFamily: 'GoogleSans',
                            fontWeight: isStickyHeader ? FontWeight.w600 : null,
                            color: isStickyHeader ? null : colorScheme.outline,
                          )))),
            ),
          ));
        },
        columnBuilder: (index) {
          return TableSpan(
              foregroundDecoration: index == 0 ? decoration : null,
              extent: const FractionalTableSpanExtent(1 / 7));
        },
        rowBuilder: (index) {
          return TableSpan(
              foregroundDecoration: index == 0 ? decoration : null,
              extent: const FixedTableSpanExtent(50));
        },
        columnCount: 15,
        rowCount: widget.ingresoScheme!.length + 1);
  }

  //vista de egresos
  TableView egresosView(
      ColorScheme colorScheme, TableSpanDecoration decoration) {
    return TableView.builder(
        verticalDetails:
            ScrollableDetails.vertical(controller: widget.verticalController),
        cellBuilder: (BuildContext ctx, TableVicinity vicinity) {
          final isStickyHeader = vicinity.xIndex == 0 || vicinity.yIndex == 0;
          var label = '';
          if (vicinity.yIndex == 0) {
            switch (vicinity.xIndex) {
              case 0:
                label = 'ID';
                break;
              case 1:
                label = 'Sueldos';
                break;
              case 2:
                label = 'Salario Bruto';
                break;
              case 3:
                label = 'Seguro Social';
                break;
              case 4:
                label = 'ISR';
                break;
            }
          } else {
            final egresoCount = widget.workerScheme?[vicinity.yIndex - 1];

            switch (vicinity.xIndex) {
              case 0:
                label = vicinity.yIndex.toString();
                break;
              case 1:
                label = egresoCount!.salary.toString();

                break;
              case 2:
                label =
                    double.tryParse(egresoCount!.salarioBrutoAnual.toString())!
                        .toStringAsFixed(3);

                break;
              case 3:
                label = double.tryParse(egresoCount!.seguroSocial.toString())!
                    .toStringAsFixed(3);
                break;
              case 4:
                label = double.tryParse(egresoCount!.isr.toString().toString())!
                    .toStringAsFixed(3);
                break;
            }
          }
          return TableViewCell(
              child: ColoredBox(
            color: isStickyHeader ? Colors.transparent : colorScheme.background,
            child: Center(
              child: FittedBox(
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'GoogleSans',
                          fontWeight: isStickyHeader ? FontWeight.w600 : null,
                          color: isStickyHeader ? null : colorScheme.outline,
                        ),
                        textAlign: TextAlign.center,
                      ))),
            ),
          ));
        },
        columnBuilder: (index) {
          return TableSpan(
              foregroundDecoration: index == 0 ? decoration : null,
              extent: const FractionalTableSpanExtent(1 / 7));
        },
        rowBuilder: (index) {
          return TableSpan(
              foregroundDecoration: index == 0 ? decoration : null,
              extent: const FixedTableSpanExtent(50));
        },
        columnCount: 10,
        rowCount: widget.workerScheme!.length + 1);
  }
  //construye las filas
}
