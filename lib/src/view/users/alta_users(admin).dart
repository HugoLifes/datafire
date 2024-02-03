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
    return Scaffold(
      appBar: AppBar(
        title: (const Text("Alta y baja Usuarios")),
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder<List<dynamic>>(
              future: futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No hay usuarios disponibles'),
                  );
                } else {
                  List<dynamic> users = snapshot.data!;
        
                  return DataTable(
                    columns: const [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text('Trabajadores')),
                      DataColumn(label: Text("Correo")),
                      DataColumn(label: Text("Rol")),
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
                        DataCell(Text(worker["role"].toString())),
                        DataCell(
                          SizedBox(
                            width: 50, 
                            child: IconButton(
                              style: const ButtonStyle(),
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                // Eliminar trabajadores
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Trabajador eliminado correctamente'),
                                  ),
                                );
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
            Container(
              width: 115,
              alignment: Alignment.center,
              child: IconButton.filled(onPressed: (){},
              padding: const EdgeInsets.all(10),
               icon: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 10),
                  Text("Nuevo", style: TextStyle(color: Colors.white, fontSize: 20),)
                ],
              ), ),
            )
          ],
        ),
      ),
    );
  }
}
