import 'package:datafire/src/forms%20alta/alta_form_proyectos.dart';
import 'package:datafire/src/model/data.dart';
import 'package:datafire/src/view/Projects/proyectosCard/cardProyecto.dart';
import 'package:flutter/material.dart';

class AltaProyectos extends StatefulWidget {
  const AltaProyectos({Key? key}) : super(key: key);

  @override
  _AltaProyectosState createState() => _AltaProyectosState();
}

class _AltaProyectosState extends State<AltaProyectos> with SingleTickerProviderStateMixin {
  late Future<List<dynamic>> _proyectosFuture;
  List<dynamic> _proyectos = []; // Lista original de proyectos
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _proyectosFuture = obtenerProyectos();
    _proyectosFuture.then((proyectos) {
      setState(() {
        _proyectos = proyectos;
      });
    });

    _tabController = TabController(vsync: this, length: 2); // Dos pestañas: Terminados y No Terminados
  }

  void _startSearch() async {
    final dynamic selected = await showSearch(
      context: context,
      delegate: ProyectoSearch(proyectos: _proyectos),
    );

    // Puedes realizar acciones adicionales si es necesario después de la búsqueda
    if (selected != null) {
      // Realiza alguna acción con el proyecto seleccionado
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: const Text("Proyectos"),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _startSearch,
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Terminados'),
              Tab(text: 'No Terminados'),
            ],
          ),
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
        elevation: 4,
        label: const Row(children: [
          Text('Agregar Proyecto', style: TextStyle(fontSize: 15))
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pestaña de Proyectos Terminados
          _buildProyectosView(terminados: true),

          // Pestaña de Proyectos No Terminados
          _buildProyectosView(terminados: false),
        ],
      ),
    );
  }

  Widget _buildProyectosView({required bool terminados}) {
    final proyectosToShow = _proyectos.where((proyecto) => proyecto["terminado"] == terminados).toList();

    return FutureBuilder<List<dynamic>>(
      // Utiliza la lista filtrada de proyectos según su estado de terminación
      future: Future.value(proyectosToShow),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar los proyectos'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay proyectos disponibles'));
        } else {
          // Mostrar la lista de proyectos en la UI
          final proyectos = snapshot.data as List<dynamic>;
          var size;
          return GridView.builder(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: size.width > 800 ? 2 : 1,
              childAspectRatio: size.width / (size.width > 800 ? 500 : 255),
              crossAxisSpacing: 25,
              mainAxisSpacing: 20,
            ),
            itemCount: proyectos.length,
            itemBuilder: (_, int index) {
              final proyecto = proyectos[index];
              return ProyectoCard(proyecto: proyecto);
            },
          );
        }
      },
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
