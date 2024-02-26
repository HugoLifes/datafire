import 'dart:convert';

import 'package:datafire/src/widgets/appBar.dart';
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
      print("cargado con éxito");
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
        child: AppBarDatafire(title: "Finanzas", description: "Aquí tendrás acceso a todas las finanzas de los proyectos"),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  const TabBar(tabs: [
                    Tab(text: "egresos"),
                    Tab(text: "nomina",),
                    Tab(text: "ingresos",),
                    Tab(text: "flujo")
                  ]),
                  Expanded(
                    child: TabBarView(
                      children: [
                        FutureBuilder(
                          future: fetchDataFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              dataSource = OrderInfoDataSource(snapshot.data as List<Map<String, dynamic>>);
                              return SfDataGrid(
                                source: dataSource,
                                columns: [
                                  GridColumn(columnName: 'startDate', label: Text('Inicio de semana'), width: 200),
                                  GridColumn(columnName: 'endDate', label: Text('Fin de semana'), width: 200),
                                  GridColumn(columnName: 'weeklyCost', label: Text('Costo Semanal'), width: 400),
                                  GridColumn(columnName: 'totalWeeklyCost', label: Text('Total Semanal')),
                                ],
                                allowSorting: true,
                                allowFiltering: true,
                                columnWidthMode: ColumnWidthMode.none,
                                // defaultColumnWidth: 150,
                              );
                            }
                          },
                        ),
                        Placeholder(),
                        Placeholder(),
                        Placeholder(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
              DataGridCell<List<Widget>>(columnName: 'weeklyCost', value: _formatWeeklyCost(e['weeklyCost'])),
              DataGridCell<double>(columnName: 'totalWeeklyCost', value: (e['totalWeeklyCost'] ?? 0.0).toDouble()),
            ]))
        .toList();
  }

  late List<DataGridRow> _dataGridRows;

  List<Widget> _formatWeeklyCost(List<dynamic>? weeklyCost) {
    if (weeklyCost == null) return [];

    return weeklyCost.map((entry) {
      String projectName = entry['projectName'] ?? '';
      double cost = entry['weeklyCost']?.toDouble() ?? 0.0;
      return Text('$projectName: $cost');
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: weeklyCostWidgets,
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
    if (columnName == 'startDate' || columnName == 'endDate') {
      return Alignment.centerRight;
    } else {
      return Alignment.centerLeft;
    }
  }
}
