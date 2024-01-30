import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:datafire/src/services/users.service.dart';
import 'package:flutter/material.dart';

class UsersView extends StatefulWidget {
  @override
  _UsersViewState createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  late Future<List<dynamic>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers(); // Obtener la lista de usuarios
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<dynamic>>(
          future: futureUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No hay usuarios disponibles'),
              );
            } else {
              List<dynamic> users = snapshot.data!;

              return DataTable(
                columns: const [
                  DataColumn(label: Text("ID")),
                  DataColumn(label: Text('Trabajadores')),
                  DataColumn(label: Text("Correo")),
                  DataColumn(
                    label: Text('Eliminar'),
                    numeric: false,
                  ),
                ],
                rows: users.map((worker) => DataRow(
                  cells: [
                    DataCell(Text(worker["id"].toString())),
                    DataCell(Text(worker['name'].toString())),
                    DataCell(Text(worker["email"].toString())),
                    DataCell(
                      SizedBox(
                        width: 50, // Ajusta el ancho según tus necesidades
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            // Eliminar trabajadores
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Trabajador eliminado correctamente'),
                              ),
                            );
                            // Actualizar la lista después de eliminar el usuario
                            setState(() {
                              futureUsers = fetchUsers();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                )).toList(),
              );
            }
          },
        ),
        // Puedes agregar más widgets aquí según sea necesario
      ],
    );
  }
}
