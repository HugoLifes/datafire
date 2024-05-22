import 'package:datafire/src/model/flujo_caja_model.dart';
import 'package:datafire/src/model/ingresos_model.dart';
import 'package:datafire/src/model/nominas_semanales.dart';
import 'package:datafire/src/model/workers_model.dart';
import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class TableTemplate extends StatefulWidget {
  late final ScrollController verticalController = ScrollController();
  late ScrollController? horizontalController = ScrollController();
  List<IngresosScheme>? ingresoScheme = [];
  List<WorkerScheme>? workerScheme = [];
  List<Nomina>? payroll = [];
  bool? isEgresos = false;
  bool? isFlujo = false;
  List<AbonoScheme>? abono = [];
  List<FlujoCaja>? flujo = [];

  TableTemplate(
      {super.key,
      required verticalController,
      this.ingresoScheme,
      this.workerScheme,
      this.payroll,
      this.isEgresos,
      this.abono,
      this.isFlujo,
      this.horizontalController,
      this.flujo});

  @override
  State<TableTemplate> createState() => _TableTemplateState();
}

class _TableTemplateState extends State<TableTemplate> {
  final int _rowCount = 20;
  List<String> rowContent = [
    'Caja',
    'Ingresos',
    'Egresos',
    'Impuestos',
    'Blance Flujo',
    'Prestamo',
    'Balance Total'
  ];
  @override
  void initState() {
    super.initState();

    widget.verticalController.addListener(() {
      setState(() {});
    });

    if (widget.isFlujo == false) {
    } else {
      widget.horizontalController!.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    widget.verticalController.dispose();
    widget.horizontalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final decoration = TableSpanDecoration(
        border:
            TableSpanBorder(trailing: const BorderSide(color: Colors.black)));
    return Scaffold(
      body: widget.isFlujo!
          ? Card(
              elevation: 3,
              clipBehavior: Clip.antiAlias,
              child: flujoView(colorScheme, decoration),
            )
          : Card(
              elevation: 3,
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
                label = 'Pago total';
                break;
              case 3:
                label = 'Fecha de pago';
            }
          } else {
            final ingresoCount = widget.abono?[vicinity.yIndex - 1];

            switch (vicinity.xIndex) {
              case 0:
                label = vicinity.yIndex.toString();
                break;
              case 1:
                label = ingresoCount!.projectName;

                break;
              case 2:
                label = ingresoCount!.amount.toString();
                break;
              case 3:
                label =
                    '${ingresoCount!.date.day}/${ingresoCount.date.month}/${ingresoCount.date.year}';
            }
          }
          return TableViewCell(
              child: ColoredBox(
            color: isStickyHeader ? Colors.transparent : Colors.white,
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
              extent: const FractionalTableSpanExtent(1 / 5));
        },
        rowBuilder: (index) {
          return TableSpan(
              foregroundDecoration: index == 0 ? decoration : null,
              extent: const FixedTableSpanExtent(40));
        },
        columnCount: 10,
        rowCount: widget.abono!.length + 1);
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
                label = 'Pago';
                break;
              case 2:
                label = 'Salario Hora';
                break;
              case 3:
                label = 'Seguro Social';
                break;
              case 4:
                label = 'ISR';
                break;
              case 5:
                label = 'Horas';
                break;
            }
          } else {
            final egresoCount = widget.payroll?[vicinity.yIndex - 1];

            switch (vicinity.xIndex) {
              case 0:
                label = vicinity.yIndex.toString();
                break;
              case 1:
                label = double.tryParse(egresoCount!.salary.toString())!
                    .toStringAsFixed(2);

                break;
              case 2:
                label = double.tryParse(egresoCount!.salaryHour.toString())!
                    .toStringAsFixed(2);

                break;
              case 3:
                label = double.tryParse(egresoCount!.seguroSocial.toString())!
                    .toStringAsFixed(2);
                break;
              case 4:
                label = double.tryParse(egresoCount!.isr.toString())!
                    .toStringAsFixed(2);
                break;
              case 5:
                label = egresoCount!.horasTrabajadas.toString();
                break;
            }
          }
          return TableViewCell(
              child: ColoredBox(
            color: isStickyHeader ? Colors.transparent : Colors.white,
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
        rowCount: widget.payroll!.length + 1);
  }
  //construye las filas

  flujoView(ColorScheme colorScheme, TableSpanDecoration decoration) {
    return Scrollbar(
      controller: widget.horizontalController,
      thumbVisibility: true,
      scrollbarOrientation: ScrollbarOrientation.bottom,
      child: TableView.builder(
          verticalDetails:
              ScrollableDetails.vertical(controller: widget.verticalController),
          horizontalDetails: ScrollableDetails.horizontal(
              controller: widget.horizontalController),
          columnCount: widget.flujo!.length,
          rowCount: rowContent.length + 1,
          columnBuilder: (index) {
            return TableSpan(
                foregroundDecoration: index == 0 ? decoration : null,
                extent: const FractionalTableSpanExtent(1 / 7));
          },
          rowBuilder: (index) {
            return TableSpan(
                foregroundDecoration: index == 0 ? decoration : null,
                extent: const FixedTableSpanExtent(85));
          },
          cellBuilder: (BuildContext ctx, TableVicinity vicinity) {
            final isStickyHeader = vicinity.xIndex == 0 || vicinity.yIndex == 0;
            var label = '';
            if (vicinity.yIndex == 0) {
              if (vicinity.xIndex == 0) {
                label = 'ID';
              } else {
                label = "Semana ${vicinity.xIndex}";
              }
            } else {
              final flujocaja = widget.flujo?[vicinity.xIndex];

              if (vicinity.xIndex == 0) {
                label = rowContent[vicinity.yIndex - 1];
              } else {
                switch (vicinity.yIndex) {
                  case 1:
                    label = double.parse(flujocaja!.caja.toString())
                        .toStringAsFixed(2);
                    break;
                  case 2:
                    label = double.parse(flujocaja!.ingresos.toString())
                        .toStringAsFixed(2);
                    break;
                  case 3:
                    label = double.parse(flujocaja!.egresos.toString())
                        .toStringAsFixed(2);
                    break;
                  case 4:
                    label = double.parse(flujocaja!.impuestos.toString())
                        .toStringAsFixed(2);
                    break;
                  case 5:
                    label = double.parse(flujocaja!.balanceDeFlujo.toString())
                        .toStringAsFixed(2);
                    break;
                  case 6:
                    label = double.parse(flujocaja!.prestamo.toString())
                        .toStringAsFixed(2);
                    break;
                  case 7:
                    label = double.parse(flujocaja!.balanceTotal.toString())
                        .toStringAsFixed(2);
                }
              }
            }
            return TableViewCell(
                child: ColoredBox(
              color: isStickyHeader ? Colors.transparent : Colors.white,
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
          }),
    );
  }
}
