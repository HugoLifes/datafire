import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class FinancesView extends StatefulWidget {
  @override
  _FinancesViewState createState() => _FinancesViewState();
}

class _FinancesViewState extends State<FinancesView> {
  late Future<List<Map<String, dynamic>>> fetchDataFuture;
  late OrderInfoDataSource dataSource;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:3000/Api/v1/proyectos/egresos'));

    if (response.statusCode == 200) {
      print("cargado con exito");
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar datos de egresos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text("Finanzas"),
        ),
      ),
      body: FutureBuilder(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // o cualquier widget de carga
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            dataSource = OrderInfoDataSource(snapshot.data as List<Map<String, dynamic>>);
            return SfDataGrid(
              source: dataSource,
              columns: [
                GridColumn(columnName: 'startDate', label: Text('Inicio de semana')),
                GridColumn(columnName: 'endDate', label: Text('Fin de semana')),
                GridColumn(columnName: 'weeklyCost', label: Text('Costo Semanal')),
                GridColumn(columnName: 'totalWeeklyCost', label: Text('Total Semanal')),
              ],
              allowSorting: true,
              allowFiltering: true,
            );
          }
        },
      ),
    );
  }
}


class OrderInfoDataSource extends DataGridSource {
  OrderInfoDataSource(List<Map<String, dynamic>> data) {
    _dataGridRows = data
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'startDate', value: e['startDate'] ?? ''),
              DataGridCell<String>(columnName: 'endDate', value: e['endDate'] ?? ''),
              DataGridCell<double>(
                  columnName: 'weeklyCost', value: _toDoubleOrZero(e['weeklyCost'])),
              DataGridCell<double>(
                  columnName: 'totalWeeklyCost', value: _toDoubleOrZero(e['totalWeeklyCost'])),
            ]))
        .toList();
  }

  late List<DataGridRow> _dataGridRows;

  double _toDoubleOrZero(dynamic value) {
    if (value is int || value is double) {
      return value.toDouble();
    } else {
      return 0.0;
    }
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  // Resto del código...


  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: getAlignment(e.columnName),
          padding: EdgeInsets.all(8.0),
          child: Text(e.value.toString()),
        );
      }).toList(),
    );
  }

  Alignment getAlignment(String columnName) {
    if (columnName == 'startDate' || columnName == 'endDate') {
      return Alignment.centerRight;
    } else {
      return Alignment.centerLeft;
    }
  }
}
