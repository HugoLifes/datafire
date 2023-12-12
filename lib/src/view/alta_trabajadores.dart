import 'package:datafire/src/forms/alta_form_trabajadores.dart';
import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/material.dart';

class AltaTrabajadores extends StatefulWidget {
  const AltaTrabajadores({Key? key}) : super(key: key);

  @override
  _AltaTrabajadoresState createState() => _AltaTrabajadoresState();
}

class _AltaTrabajadoresState extends State<AltaTrabajadores> {
  late Future<List<dynamic>> _trabajadoresFuture;

  @override
  void initState() {
    super.initState();
    _trabajadoresFuture = fetchTrabajadores();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trabajadores',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(
              'Da de alta a tus trabajadores',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: accentCanvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AltaTrabajadorPage(),
            ),
          );
        },
        icon: const Icon(Icons.receipt),
        elevation: 4,
        label: const Row(children: [
          Text('Agregar Trabajador', style: TextStyle(fontSize: 15))
        ]),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _trabajadoresFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error al cargar los trabajadores'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay trabajadores disponibles'));
          } else {
            final trabajadores = snapshot.data as List<dynamic>;
            return GridView.builder(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              itemCount: trabajadores.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.width > 800 ? 2 : 1,
                childAspectRatio: size.width / (size.width > 800 ? 500 : 255),
                crossAxisSpacing: 25,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                final trabajador = trabajadores[index];
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: canvasColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          offset: Offset(0, 5)),
                    ],
                  ),
                  child: InkWell(
                    hoverColor: accentCanvasColor,
                    onTap: () {
                      debugPrint(
                          'Trabajador ID: ${trabajador["id"]} selected!');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'ID Trabajador:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              trabajador["id"].toString(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Nombre:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              trabajador["name"],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Apellido:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              trabajador["last_name"],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Edad:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              trabajador["age"].toString(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Cargo:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              trabajador["position"],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Salario:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              trabajador["salary"].toString(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        // Add more details as needed
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
