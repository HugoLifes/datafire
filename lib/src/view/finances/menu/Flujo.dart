import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

class FlujoWidget extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> fetchDataFuture;

  const FlujoWidget({required this.fetchDataFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final dataSource =
              FlujoDataSource(snapshot.data as List<Map<String, dynamic>>);
          return SfDataGrid(
            source: dataSource,
            columns: [
              GridColumn(
                  columnName: 'startDate',
                  label: const Text('Inicio de semana',
                      textAlign: TextAlign.center)),
              GridColumn(
                  columnName: 'endDate',
                  label: const Text('Fin de semana',
                      textAlign: TextAlign.center)),
              GridColumn(
                  columnName: 'caja', label: const Text('Caja', textAlign: TextAlign.center)),
              GridColumn(
                  columnName: 'ingresos',
                  label: const Text('Ingresos', textAlign: TextAlign.center)),
              GridColumn(
                  columnName: 'egresos',
                  label: const Text('Egresos', textAlign: TextAlign.center)),
              GridColumn(
                  columnName: 'balanceDeFlujo',
                  label: const Text('Balance de Flujo',
                      textAlign: TextAlign.center)),
              GridColumn(
                  columnName: 'prestamo',
                  label: const Text('Prestamo', textAlign: TextAlign.center)),
              GridColumn(
                  columnName: 'balanceTotal',
                  label: const Text('Balance Total',
                      textAlign: TextAlign.center)),
            ],
            allowSorting: true,
            allowFiltering: true,
            columnWidthMode: ColumnWidthMode.fill,
          );
        }
      },
    );
  }
}

class FlujoDataSource extends DataGridSource {
  FlujoDataSource(List<Map<String, dynamic>> data) {
    _dataGridRows = data
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'startDate',
                  value: _formatDate(e['startDate']) ?? ''),
              DataGridCell<String>(
                  columnName: 'endDate',
                  value: _formatDate(e['endDate']) ?? ''),
              DataGridCell<String>(
                  columnName: 'caja', value: e['caja']?.toString() ?? ''),
              DataGridCell<double>(
                  columnName: 'ingresos',
                  value: e['ingresos']?.toDouble() ?? 0.0),
              DataGridCell<double>(
                  columnName: 'egresos',
                  value: e['egresos']?.toDouble() ?? 0.0),
              DataGridCell<double>(
                  columnName: 'balanceDeFlujo',
                  value: e['balanceDeFlujo']?.toDouble() ?? 0.0),
              DataGridCell<double>(
                  columnName: 'prestamo',
                  value: e['prestamo']?.toDouble() ?? 0.0),
              DataGridCell<double>(
                  columnName: 'balanceTotal',
                  value: e['balanceTotal']?.toDouble() ?? 0.0),
            ]))
        .toList();
  }

  late List<DataGridRow> _dataGridRows;

  String? _formatDate(String? date) {
    if (date == null) return null;

    final parsedDate = DateTime.parse(date);
    final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    return formattedDate;
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            e.value.toString(),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }
}