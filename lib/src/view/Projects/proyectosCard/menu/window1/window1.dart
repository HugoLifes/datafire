import 'package:flutter/material.dart';

class window1 extends StatelessWidget {
  final Map<String, dynamic>? proyecto;

  window1({required this.proyecto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Campo')),
            DataColumn(label: Text('Valor')),
          ],
          rows: proyecto?.entries
              .map((entry) => DataRow(
                    cells: [
                      DataCell(Text(entry.key)),
                      DataCell(Text('${entry.value}')),
                    ],
                  ))
              .toList() ??
              [],
        ),
      ),
    );
  }
}