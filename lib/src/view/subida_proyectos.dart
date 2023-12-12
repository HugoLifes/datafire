import 'package:datafire/src/forms/alta_form_proyectos.dart';
import 'package:datafire/src/forms/alta_form_trabajadores.dart';
import 'package:datafire/src/services/proyectos.service.dart';
import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/material.dart';

class AltaProyectos extends StatefulWidget {
  const AltaProyectos({Key? key}) : super(key: key);

  @override
  _AltaProyectosState createState() => _AltaProyectosState();
}

class _AltaProyectosState extends State<AltaProyectos> {
  late Future<List<dynamic>> _proyectosFuture;

  @override
  void initState() {
    super.initState();
    _proyectosFuture = fetchProjects();
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
              'Proyectos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(
              'En esta sección se mostrarán sus clientes o poder dar de alta clientes',
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
          // Al presionar el botón, navegar a la página AltaClientePage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AltaProyectoPage(),
            ),
          );
        },
        icon: const Icon(Icons.receipt),
        elevation: 4,
        label: const Row(children: [
          Text('Agregar Proyecto', style: TextStyle(fontSize: 15))
        ]),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _proyectosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los clientes'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay clientes disponibles'));
          } else {
            // Mostrar la lista de clientes en la UI
            final proyectos = snapshot.data as List<dynamic>;
            return GridView.builder(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              itemCount: proyectos.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.width > 800 ? 2 : 1,
                childAspectRatio: size.width / (size.width > 800 ? 500 : 255),
                crossAxisSpacing: 25,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (_, int index) {
                final proyecto = proyectos[index];
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
                      debugPrint('Proyecto ID: ${proyecto["id"]} selected!');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'ID Proyecto:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              proyecto["id"].toString(),
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
                              proyecto["name"],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Fecha Inicio:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              proyecto["fecha_inicio"],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Fecha Fin:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              proyecto["fecha_fin"],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
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
