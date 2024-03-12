import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

class EgresosWidget extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> fetchDataFuture;

  const EgresosWidget({required this.fetchDataFuture});

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
              GridColumn(columnName: 'startDate', label: const Text('Inicio de semana', textAlign: TextAlign.center)),
              GridColumn(columnName: 'endDate', label: const Text('Fin de semana', textAlign: TextAlign.center)),
              GridColumn(columnName: 'weeklyCost', label: const Text('Costo Semanal', textAlign: TextAlign.center)),
              GridColumn(columnName: 'totalWeeklyCost', label: const Text('Total Semanal', textAlign: TextAlign.center)),
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
  OrderInfoDataSource(List<Map<String, dynamic>> data) {
    _dataGridRows = data
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'startDate', value: _formatDate(e['startDate'])),
              DataGridCell<String>(columnName: 'endDate', value: _formatDate(e['endDate'])),
              DataGridCell<List<Widget>>(columnName: 'weeklyCost', value: _formatWeeklyCost(e['weeklyCost'])),
              DataGridCell<double>(columnName: 'totalWeeklyCost', value: (e['totalWeeklyCost'] ?? 0.0).toDouble()),
            ]))
        .toList();
  }

  late List<DataGridRow> _dataGridRows;

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return '';
    }

    final DateTime date = DateTime.parse(dateStr);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }

  List<Widget> _formatWeeklyCost(List<dynamic>? weeklyCost) {
    if (weeklyCost == null) return [];

    return weeklyCost.map((entry) {
      String projectName = entry['projectName'] ?? '';
      double cost = entry['weeklyCost']?.toDouble() ?? 0.0;
      return Flexible(
        child: Text(
          '$projectName: \$${cost.toStringAsFixed(2)}', // Agrega el signo de pesos y formatea el número a dos decimales
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
          return Container(
            alignment: getAlignment(e.columnName),
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 60.0,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: weeklyCostWidgets,
              ),
            ),
          );
        } else if (e.columnName == 'totalWeeklyCost') {
          return Container(
            alignment: getAlignment(e.columnName),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '\$${e.value.toStringAsFixed(2)}', // Agrega el signo de pesos y formatea el número a dos decimales
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        } else {
          return Container(
            alignment: getAlignment(e.columnName),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              e.value.toString(),
              textAlign: TextAlign.start,
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
      return Alignment.center;
    }
  }
}
