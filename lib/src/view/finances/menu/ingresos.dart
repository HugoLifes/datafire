import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

class IngresosWidget extends StatelessWidget {
  final Future<List<dynamic>> fetchDataFuture;

  const IngresosWidget({super.key, required this.fetchDataFuture});

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
          final dataSource = OrderInfoDataSource(snapshot.data as List<Map<String, dynamic>>);
          return SfDataGrid(
            source: dataSource,
            columns: [
              GridColumn(
                columnName: 'startDate',
                label: const Text('                   Inicio de semana', textAlign: TextAlign.center),
              ),
              GridColumn(
                columnName: 'endDate',
                label: const Text('                          Fin de semana', textAlign: TextAlign.center),
              ),
              GridColumn(
                columnName: 'weeklyCost',
                label: const Text('Costo Semanal', textAlign: TextAlign.center),
              ),
              GridColumn(
                columnName: 'totalWeeklyCost',
                label: const Text('Total Semanal', textAlign: TextAlign.center),
              ),
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

class OrderInfoDataSource extends DataGridSource {
  late List<DataGridRow> _dataGridRows;

  OrderInfoDataSource(List<Map<String, dynamic>> data) {
    _dataGridRows = data
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'startDate', value: _formatDate(e['startDate'])),
              DataGridCell<String>(columnName: 'endDate', value: _formatDate(e['endDate'])),
              DataGridCell<List<Widget>>(columnName: 'weeklyCost', value: _formatWeeklyCost(e['abonos'])),
              DataGridCell<double>(columnName: 'totalWeeklyCost', value: (e['totalWeeklyAbonos'] ?? 0.0).toDouble()),
            ]))
        .toList();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return '';
    }

    final DateTime date = DateTime.parse(dateStr);
    final DateFormat formatter = DateFormat('dd-MM-yyyy'); // Ajusta el formato según tus preferencias
    return formatter.format(date);
  }

  List<Widget> _formatWeeklyCost(List<dynamic>? abonos) {
    if (abonos == null) return [];

    return abonos.map((entry) {
      String projectName = entry['projectName'] ?? '';
      double cost = entry['amount']?.toDouble() ?? 0.0;
      return Text(
        '$projectName: $cost',
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        if (e.columnName == 'weeklyCost') {
          List<Widget> weeklyCostWidgets = e.value as List<Widget>;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: weeklyCostWidgets,
            ),
          );
        } else {
          return Container(
            alignment: getAlignment(e.columnName),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              e.value.toString(),
              textAlign: TextAlign.center,
            ),
          );
        }
      }).toList(),
    );
  }

  Alignment getAlignment(String columnName) {
    if (columnName == 'startDate' || columnName == 'endDate') {
      return Alignment.center;
    } else {
      return Alignment.centerLeft;
    }
  }
}
