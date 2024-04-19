import 'package:datafire/src/model/ingresos_model.dart';
import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class TableTemplate extends StatefulWidget {
  late final ScrollController verticalController = ScrollController();
  List<IngresosScheme>? ingresoScheme = [];
  TableTemplate({super.key, required verticalController, this.ingresoScheme});

  @override
  State<TableTemplate> createState() => _TableTemplateState();
}

class _TableTemplateState extends State<TableTemplate> {
  final int _rowCount = 20;

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
        child: TableView.builder(
            verticalDetails: ScrollableDetails.vertical(
                controller: widget.verticalController),
            cellBuilder: (BuildContext ctx, TableVicinity vicinity) {
              final isStickyHeader =
                  vicinity.xIndex == 0 || vicinity.yIndex == 0;
              var label = '';
              if (vicinity.yIndex == 0) {
                switch (vicinity.xIndex) {
                  case 0:
                    label = 'ID';
                    break;
                  case 1:
                    label = 'Nombre';
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
                final abonoCount = widget.ingresoScheme?[vicinity.yIndex - 1]
                    .abonos[vicinity.yIndex];
                switch (vicinity.xIndex) {
                  case 0:
                    label = vicinity.yIndex.toString();
                    break;
                  case 1:
                    label = abonoCount!.projectName;
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
                    label =
                        '${abonoCount!.date.day}/${abonoCount.date.month}/${abonoCount.date.year}';
                }
              }
              return TableViewCell(
                  child: ColoredBox(
                color: isStickyHeader
                    ? Colors.transparent
                    : colorScheme.background,
                child: Center(
                  child: FittedBox(
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(label,
                              style: TextStyle(
                                fontWeight:
                                    isStickyHeader ? FontWeight.w600 : null,
                                color:
                                    isStickyHeader ? null : colorScheme.outline,
                              )))),
                ),
              ));
            },
            columnBuilder: (index) {
              return TableSpan(
                  foregroundDecoration: index == 0 ? decoration : null,
                  extent: const FractionalTableSpanExtent(1 / 6));
            },
            rowBuilder: (index) {
              return TableSpan(
                  foregroundDecoration: index == 0 ? decoration : null,
                  extent: const FixedTableSpanExtent(50));
            },
            columnCount: 15,
            rowCount: 58),
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

  // construye las celdas

  //construye las columnas

  //construye las filas
  TableSpan _buildRowSpan(int index) {
    final TableSpanDecoration decoration = TableSpanDecoration(
      color: index.isEven ? Colors.purple[100] : null,
      border: const TableSpanBorder(
        trailing: BorderSide(
          width: 3,
        ),
      ),
    );

    switch (index % 3) {
      case 0:
        return TableSpan(
          backgroundDecoration: decoration,
          extent: const FixedTableSpanExtent(50),
          recognizerFactories: <Type, GestureRecognizerFactory>{
            TapGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
              () => TapGestureRecognizer(),
              (TapGestureRecognizer t) =>
                  t.onTap = () => print('Tap row $index'),
            ),
          },
        );
      case 1:
        return TableSpan(
          backgroundDecoration: decoration,
          extent: const FixedTableSpanExtent(65),
          cursor: SystemMouseCursors.click,
        );
      case 2:
        return TableSpan(
          backgroundDecoration: decoration,
          extent: const FractionalTableSpanExtent(0.15),
        );
    }
    throw AssertionError(
        'This should be unreachable, as every index is accounted for in the switch clauses.');
  }
}
