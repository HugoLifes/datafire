import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CobrarWidget extends StatelessWidget {
  final Future<List<dynamic>> fetchDataFuture;

  const CobrarWidget({required this.fetchDataFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final dataSource = ProjectInfoDataSource(snapshot.data as List<Map<String, dynamic>>);
          return SfDataGrid(
            source: dataSource,
            columns: [
              GridColumn(columnName: 'name', label: Text('Project Name', textAlign: TextAlign.center)),
              GridColumn(columnName: 'remaining', label: Text('Remaining', textAlign: TextAlign.center)),
              GridColumn(columnName: 'projectCustomers', label: Text('Project Customers', textAlign: TextAlign.center)),
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

class ProjectInfoDataSource extends DataGridSource {
  ProjectInfoDataSource(List<Map<String, dynamic>> data) {
    _dataGridRows = data
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'name', value: e['name'] ?? ''),
              DataGridCell<double>(columnName: 'remaining', value: (e['remaining'] ?? 0).toDouble()),
              DataGridCell<List<Widget>>(columnName: 'projectCustomers', value: _formatProjectCustomers(e['projectCustomers'])),
            ]))
        .toList();
  }

  late List<DataGridRow> _dataGridRows;

  List<Widget> _formatProjectCustomers(List<dynamic>? projectCustomers) {
    if (projectCustomers == null || projectCustomers.isEmpty) return [];

    return projectCustomers.map((customer) {
      String customerName = customer['customer_name'] ?? '';
      return Text(customerName);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        if (e.columnName == 'projectCustomers') {
          List<Widget> customerWidgets = e.value as List<Widget>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: customerWidgets,
          );
        } else {
          return Container(
            alignment: getAlignment(e.columnName),
            padding: EdgeInsets.all(8.0),
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
    if (columnName == 'remaining') {
      return Alignment.centerRight;
    } else {
      return Alignment.centerLeft;
    }
  }
}
