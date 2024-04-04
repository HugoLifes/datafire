import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:datafire/src/services/proyectosTrabajadores.service.dart';
import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:flutter/material.dart';

class Window3 extends StatefulWidget {
  final Map<String, dynamic>? proyecto;

  const Window3({super.key, required this.proyecto});

  @override
  _Window3State createState() => _Window3State();
}

class _Window3State extends State<Window3> {
  late Future<List<dynamic>> futureProjectWorkers;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureProjectWorkers = fetchProjectWorkers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<dynamic>>(
          future: futureProjectWorkers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No hay datos disponibles');
            } else {
              List<dynamic> workerProjects = snapshot.data!;
              List workerData = workerProjects
                  .where((cp) => cp['project_id'] == widget.proyecto?['id'])
                  .toList();

              return ListView.builder(
                shrinkWrap: true,
                itemCount: workerData.length,
                itemBuilder: (context, index) {
                  final worker = workerData[index];
                  return Card(
                    elevation: 5,
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        worker['worker_name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('ID Trabajador: ${worker['id']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteWorkerDialog(worker),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        if (!isLoading)
          ElevatedButton.icon(
            onPressed: () {
              _selectWorkersDialog(
                  context, widget.proyecto?["id"].toString() ?? "");
            },
            icon: const Icon(Icons.add),
            label: const Text("Añadir Trabajadores"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
      ],
    );
  }

  void _deleteWorkerDialog(dynamic worker) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: "Eliminar Trabajador del proyecto",
      desc: "¿Estás seguro que quieres eliminar este trabajador?",
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        setState(() => isLoading = true);
        await deleteProjectWorkers(worker['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trabajador eliminado correctamente')),
        );
        setState(() {
          futureProjectWorkers = fetchProjectWorkers();
          isLoading = false;
        });
      },
    ).show();
  }

  void _selectWorkersDialog(BuildContext context, String projectId) async {
    List<dynamic> todosLosTrabajadores =
        await fetchTrabajadores(); // Obtiene todos los trabajadores
    List<dynamic> proyectosTrabajadores =
        await fetchProjectWorkers(); // Obtiene todos los trabajadores por proyecto

    // Filtra para obtener solo los trabajadores relacionados con este proyecto específico
    List<dynamic> trabajadoresDelProyecto = proyectosTrabajadores
        .where((cp) => cp['project_id'].toString() == projectId)
        .toList();

    // Extrae los IDs de los trabajadores ya relacionados con el proyecto
    List<String> idsTrabajadoresDelProyecto = trabajadoresDelProyecto
        .map((cp) => cp['worker_id'].toString())
        .toList();

    // Filtra la lista de todos los trabajadores para excluir aquellos que ya están asignados al proyecto
    List<dynamic> trabajadoresParaMostrar = todosLosTrabajadores
        .where((trabajador) =>
            !idsTrabajadoresDelProyecto.contains(trabajador['id'].toString()))
        .toList();

    List<String> trabajadoresSeleccionados = [];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Selecciona trabajadores"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: trabajadoresParaMostrar.map((trabajador) {
                    bool isSelected = trabajadoresSeleccionados
                        .contains(trabajador["id"]?.toString() ?? "");
                    return CheckboxListTile(
                      title: Text(trabajador["name"]?.toString() ?? ""),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            if (value) {
                              trabajadoresSeleccionados
                                  .add(trabajador["id"]?.toString() ?? "");
                            } else {
                              trabajadoresSeleccionados
                                  .remove(trabajador["id"]?.toString() ?? "");
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                // Aquí se asume la existencia de una función postProjectWorker para asignar trabajadores al proyecto
                await Future.forEach(trabajadoresSeleccionados,
                    (dynamic workerId) async {
                  await postProjectWorker()
                      .addProjectWorker(projectId, workerId.toString());
                });
                setState(() {
                  futureProjectWorkers = fetchProjectWorkers();
                });
                Navigator.of(context).pop();
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}
