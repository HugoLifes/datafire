import 'package:datafire/src/forms%20alta/alta_form_proyectos.dart';
import 'package:datafire/src/model/data.dart';
import 'package:datafire/src/view/Projects/proyectosCard/cardProyecto.dart';
import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/material.dart';

class AltaProyectos extends StatefulWidget {
  const AltaProyectos({Key? key}) : super(key: key);

  @override
  _AltaProyectosState createState() => _AltaProyectosState();
}

class _AltaProyectosState extends State<AltaProyectos> {
  late Future<List<dynamic>> _proyectosFuture;
  List<dynamic> _proyectos = []; // Lista original de proyectos
  bool _showPagados =
      true; // Nuevo estado para controlar la visibilidad de proyectos pagados

  @override
  void initState() {
    super.initState();
    _proyectosFuture = obtenerProyectos();
    _proyectosFuture.then((proyectos) {
      if (mounted) {
        setState(() {
          _proyectos = proyectos;
        });
      }
    });
  }

  // Función para filtrar proyectos según la visibilidad actual
  List<dynamic> _filtrarProyectos() {
    var proyectosFiltrados = _proyectos;

    // Filtrar proyectos pagados
    if (!_showPagados) {
      proyectosFiltrados = proyectosFiltrados
          .where((proyecto) => proyecto['status'] == true)
          .toList();
    }

    return proyectosFiltrados;
  }

  void _startSearch() async {
    final dynamic selected = await showSearch(
      context: context,
      delegate: ProyectoSearch(proyectos: _filtrarProyectos()),
    );

    // Puedes realizar acciones adicionales si es necesario después de la búsqueda
    if (selected != null) {
      // Realiza alguna acción con el proyecto seleccionado
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(59),
        child: AppBar(
          backgroundColor: accentCanvasColor,
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Proyectos',
                  style: TextStyle(
                    fontFamily: 'GoogleSans',
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 5),
              // Nuevo texto para describir la página)
              Text(
                'Da de alta tus proyectos y administralos',
                style: TextStyle(
                    fontFamily: 'GoogleSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _startSearch,
            ),
            // Nuevo botón para cambiar la visibilidad de proyectos pagados
            IconButton(
              icon: Icon(_showPagados ? Icons.attach_money : Icons.money_off),
              onPressed: () {
                setState(() {
                  _showPagados = !_showPagados;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Al presionar el botón, navegar a la página AltaClientePage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AltaProyectoPage(),
            ),
          );
        },
        icon: const Icon(Icons.receipt),
        elevation: 3,
        label: const Row(children: [
          Text('Agregar Proyecto',
              style: TextStyle(fontFamily: 'GoogleSans', fontSize: 15))
        ]),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _proyectosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text(
              'Error al cargar los clientes',
              style: TextStyle(
                fontFamily: 'GoogleSans',
              ),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              'No hay clientes disponibles',
              style: TextStyle(
                fontFamily: 'GoogleSans',
              ),
            ));
          } else {
            // Mostrar la lista de clientes en la UI
            return GridView.builder(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.width > 800 ? 2 : 1,
                childAspectRatio: size.width / (size.width > 800 ? 500 : 255),
                crossAxisSpacing: 25,
                mainAxisSpacing: 20,
              ),
              itemCount: _filtrarProyectos().length,
              itemBuilder: (_, int index) {
                final proyecto = _filtrarProyectos()[index];
                return ProyectoCard(proyecto: proyecto);
              },
            );
          }
        },
      ),
    );
  }
}

class ProyectoSearch extends SearchDelegate<dynamic> {
  final List<dynamic> proyectos;

  ProyectoSearch({required this.proyectos});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = proyectos
        .where((proyecto) =>
            proyecto["name"].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Dos cards por fila
        crossAxisSpacing: 8.0, // Espaciado horizontal entre cards
        mainAxisSpacing: 8.0, // Espaciado vertical entre cards
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final proyecto = results[index];
        return ProyectoCard(proyecto: proyecto);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? proyectos
        : proyectos
            .where((proyecto) =>
                proyecto["name"].toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final suggestion = suggestionList[index];
        return ListTile(
          title: ProyectoCard(proyecto: suggestion),
          onTap: () {
            close(context, suggestion);
          },
        );
      },
    );
  }
}
