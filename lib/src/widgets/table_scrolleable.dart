import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class TableTemplate extends StatefulWidget {
  late final ScrollController verticalController = ScrollController();
  TableTemplate({super.key, required verticalController});

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
          verticalDetails:
              ScrollableDetails.vertical(controller: widget.verticalController),
          cellBuilder: (BuildContext ctx, TableVicinity vicinity) {
            final isStickyHeader = vicinity.xIndex == 0 || vicinity.yIndex == 0;
            return TableViewCell(
                child: ColoredBox(
              color:
                  isStickyHeader ? Colors.transparent : colorScheme.background,
              child: Center(
                child: FittedBox(
                    child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                            'Tile c: ${vicinity.column}, r: ${vicinity.row}',
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
                extent: const FractionalTableSpanExtent(1 / 8));
          },
          rowBuilder: (index) {
            return TableSpan(
                foregroundDecoration: index == 0 ? decoration : null,
                extent: const FixedTableSpanExtent(50));
          },
          columnCount: 20,
          rowCount: _rowCount,
        ),
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

  TableSpan _buildColumnSpan(int index) {
    const TableSpanDecoration decoration = TableSpanDecoration(
      border: TableSpanBorder(
        trailing: BorderSide(),
      ),
    );

    switch (index % 5) {
      case 0:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(100),
          onEnter: (_) => print('Entered column $index'),
          recognizerFactories: <Type, GestureRecognizerFactory>{
            TapGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
              () => TapGestureRecognizer(),
              (TapGestureRecognizer t) =>
                  t.onTap = () => print('Tap column $index'),
            ),
          },
        );
      case 1:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FractionalTableSpanExtent(0.5),
          onEnter: (_) => print('Entered column $index'),
          cursor: SystemMouseCursors.contextMenu,
        );
      case 2:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(120),
          onEnter: (_) => print('Entered column $index'),
        );
      case 3:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(145),
          onEnter: (_) => print('Entered column $index'),
        );
      case 4:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(200),
          onEnter: (_) => print('Entered column $index'),
        );
    }
    throw AssertionError(
        'This should be unreachable, as every index is accounted for in the switch clauses.');
  }

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
