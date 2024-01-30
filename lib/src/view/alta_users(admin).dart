import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:flutter/material.dart';

class usersView extends StatefulWidget {
  @override
  _ThirdTabContentState createState() => _ThirdTabContentState();
}

class _ThirdTabContentState extends State<usersView> {
  late Future<List<dynamic>> futureWorkers;

  @override
  void initState() {
    super.initState();
    futureWorkers = fetchTrabajadores(); // Obtener la lista de trabajadores
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<dynamic>>(
          future: futureWorkers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No hay datos disponibles');
            } else {
              List<dynamic> workers = snapshot.data!;

              return DataTable(
                columns: const [
                  DataColumn(label: Text('Trabajadores')),
                  DataColumn(
                    label: Text('Eliminar'),
                    numeric: true,
                  ),
                ],
                rows: workers
                    .map((worker) => DataRow(
                          cells: [
                            DataCell(Text(worker['name'].toString())),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  // Implementa la lógica para eliminar trabajador si es necesario
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Trabajador eliminado correctamente'),
                                    ),
                                  );
                                  // Actualizar la lista después de eliminar el trabajador
                                  setState(() {
                                    futureWorkers = fetchTrabajadores();
                                  });
                                },
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              );
            }
          },
        ),
        // Puedes agregar botones u otros elementos aquí según tus necesidades
      ],
    );
  }
}
