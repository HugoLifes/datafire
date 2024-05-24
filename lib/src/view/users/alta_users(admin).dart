import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:datafire/src/services/users.service.dart';
import 'package:datafire/src/widgets/appBar.dart';
import 'package:flutter/material.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  _UsersViewState createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  late Future<List<dynamic>> futureUsers;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  List<String> roles = ['user', 'admin'];
  String selectedRole = 'user';

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarDatafire(
            title: "Edicion de Usuarios",
            description: "Edita o elimina usuarios"),
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
                    child: Text(
                      'No hay usuarios disponibles',
                      style: TextStyle(fontFamily: 'GoogleSans'),
                    ),
                  );
                } else {
                  List<dynamic> users = snapshot.data!;

                  return DataTable(
                    columns: const [
                      DataColumn(
                          label: Text(
                        "ID",
                        style: TextStyle(fontFamily: 'GoogleSans'),
                      )),
                      DataColumn(
                          label: Text('Trabajadores',
                              style: TextStyle(fontFamily: 'GoogleSans'))),
                      DataColumn(
                          label: Text("Correo",
                              style: TextStyle(fontFamily: 'GoogleSans'))),
                      DataColumn(
                          label: Text("Rol",
                              style: TextStyle(fontFamily: 'GoogleSans'))),
                      DataColumn(
                        label: Text('Eliminar',
                            style: TextStyle(fontFamily: 'GoogleSans')),
                        numeric: false,
                      ),
                    ],
                    rows: users
                        .map((user) => DataRow(
                              cells: [
                                DataCell(Text(user["id"].toString(),
                                    style:
                                        TextStyle(fontFamily: 'GoogleSans'))),
                                DataCell(Text(user['name'].toString(),
                                    style:
                                        TextStyle(fontFamily: 'GoogleSans'))),
                                DataCell(Text(user["email"].toString(),
                                    style:
                                        TextStyle(fontFamily: 'GoogleSans'))),
                                DataCell(Text(user["role"].toString(),
                                    style:
                                        TextStyle(fontFamily: 'GoogleSans'))),
                                DataCell(
                                  SizedBox(
                                    width: 50,
                                    child: IconButton(
                                      style: const ButtonStyle(),
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        AwesomeDialog(
                                          context: context,
                                          titleTextStyle: TextStyle(
                                              fontFamily: 'GoogleSans'),
                                          descTextStyle: TextStyle(
                                              fontFamily: 'GoogleSans'),
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          title: 'Eliminar usuario',
                                          desc:
                                              '¿Estás seguro de que quieres eliminar este Usuario?',
                                          width: 620,
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            // Eliminar trabajadores
                                            deleteUser(user["id"], context);

                                            setState(() {
                                              futureUsers = fetchUsers();
                                            });
                                          },
                                        ).show();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  );
                }
              },
            ),
            Container(
              width: 115,
              alignment: Alignment.center,
              child: IconButton.filled(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Ingrese los datos para agregar un nuevo usuario',
                          style: TextStyle(fontFamily: 'GoogleSans'),
                        ),
                        content: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  style: TextStyle(fontFamily: 'GoogleSans'),
                                  decoration: const InputDecoration(
                                      floatingLabelStyle:
                                          TextStyle(fontFamily: 'GoogleSans'),
                                      labelStyle:
                                          TextStyle(fontFamily: 'GoogleSans'),
                                      labelText: 'Nombre'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, ingrese el nombre';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: emailController,
                                  style: TextStyle(fontFamily: 'GoogleSans'),
                                  decoration: const InputDecoration(
                                      floatingLabelStyle:
                                          TextStyle(fontFamily: 'GoogleSans'),
                                      labelStyle:
                                          TextStyle(fontFamily: 'GoogleSans'),
                                      labelText: 'Correo'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, ingrese el correo';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: passwordController,
                                  style: TextStyle(fontFamily: 'GoogleSans'),
                                  decoration: const InputDecoration(
                                      floatingLabelStyle:
                                          TextStyle(fontFamily: 'GoogleSans'),
                                      labelStyle:
                                          TextStyle(fontFamily: 'GoogleSans'),
                                      labelText: 'Contaseña'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, ingrese su contraseña';
                                    }
                                    return null;
                                  },
                                ),
                                DropdownButtonFormField<String>(
                                  value: selectedRole,
                                  style: TextStyle(fontFamily: 'GoogleSans'),
                                  items: roles.map((String role) {
                                    return DropdownMenuItem<String>(
                                      value: role,
                                      child: Text(
                                        role,
                                        style: TextStyle(
                                            fontFamily: 'GoogleSans',
                                            color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedRole = value!;
                                      roleController.text = value;
                                    });
                                  },
                                  decoration:
                                      const InputDecoration(labelText: 'Rol'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, seleccione el rol';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        await postUser(
                                            nameController.text,
                                            emailController.text,
                                            passwordController.text,
                                            roleController.text,
                                            context);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Usuario agregado correctamente'),
                                          ),
                                        );

                                        setState(() {
                                          futureUsers = fetchUsers();
                                        });
                                      } finally {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'Agregar Usuario',
                                    style: TextStyle(fontFamily: 'GoogleSans'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                padding: const EdgeInsets.all(10),
                icon: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 5),
                    Text("Nuevo",
                        style: TextStyle(
                            fontFamily: 'GoogleSans',
                            color: Colors.white,
                            fontSize: 20)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
