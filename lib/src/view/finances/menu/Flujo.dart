import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class FlujoWidget extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> fetchDataFuture;

   FlujoWidget({required this.fetchDataFuture});

  final _dateController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final dataSource =
                FlujoDataSource(snapshot.data as List<Map<String, dynamic>>);
            return Column(
              children: [
                Expanded(
                  child: SfDataGrid(
                    source: dataSource,
                    columns: [
                      GridColumn(
                        columnName: 'startDate',
                        label: const Text('Inicio de semana',
                            textAlign: TextAlign.center),
                      ),
                      GridColumn(
                        columnName: 'endDate',
                        label: const Text('Fin de semana',
                            textAlign: TextAlign.center),
                      ),
                      GridColumn(
                        columnName: 'caja',
                        label: const Text('Caja', textAlign: TextAlign.center),
                      ),
                      GridColumn(
                        columnName: 'ingresos',
                        label: const Text('Ingresos',
                            textAlign: TextAlign.center),
                      ),
                      GridColumn(
                        columnName: 'egresos',
                        label: const Text('Egresos',
                            textAlign: TextAlign.center),
                      ),
                      GridColumn(
                        columnName: 'balanceDeFlujo',
                        label: const Text('Balance de Flujo',
                            textAlign: TextAlign.center),
                      ),
                      GridColumn(
                        columnName: 'prestamo',
                        label: const Text('Prestamo',
                            textAlign: TextAlign.center),
                      ),
                      GridColumn(
                        columnName: 'balanceTotal',
                        label: const Text('Balance Total',
                            textAlign: TextAlign.center),
                      ),
                    ],
                    allowSorting: true,
                    allowFiltering: true,
                    columnWidthMode: ColumnWidthMode.fill,
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarFormulario(context);
        },
        child: Icon(Icons.add),
        
      ),
    );
  }

  Future<void> _mostrarFormulario(BuildContext context) async {
    DateTime? selectedDate = DateTime.now();

    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ).then((value) {
      if (value != null) {
        selectedDate = value;
        _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
      }
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Préstamo'),
          content: Column(
            children: [
              Row(
                children: [
                  Text('Fecha del Préstamo:'),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      ).then((value) {
                        if (value != null) {
                          selectedDate = value;
                          _dateController.text =
                              DateFormat('yyyy-MM-dd').format(selectedDate!);
                        }
                      });
                    },
                    child: Text('Seleccionar Fecha'),
                  ),
                ],
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Monto Pagado'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _enviarFormulario();
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _enviarFormulario() async {
    final datePrestamo = _dateController.text;
    final amountPaid = _amountController.text;

    if (datePrestamo.isNotEmpty && amountPaid.isNotEmpty) {
      await postProyecto(datePrestamo, amountPaid);
    }
  }

  Future<void> postProyecto(String datePrestamo, String amountPaid) async {
    const url = "https://datafire-production.up.railway.app/Api/v1/proyectos/prestamos";

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "date_prestamo": datePrestamo,
          "amount_paid": amountPaid,
        }),
      );

      if (res.statusCode == 200) {
        // Manejar la respuesta exitosa si es necesario
      } else {
        // Manejar la respuesta fallida si es necesario
      }
    } catch (err) {
      // Manejar errores si es necesario
    }
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
