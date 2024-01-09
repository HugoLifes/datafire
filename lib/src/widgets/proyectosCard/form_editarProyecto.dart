import 'package:datafire/src/services/proyectos.service.dart';
import 'package:flutter/material.dart';

class EditarProyectosForm extends StatefulWidget {
  final Map<String, dynamic>? proyecto;

  EditarProyectosForm({Key? key, required this.proyecto}) : super(key: key);

  @override
  _EditarProyectosFormState createState() => _EditarProyectosFormState();
}

class _EditarProyectosFormState extends State<EditarProyectosForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  DateTime? _inicioDate;
  DateTime? _finDate;
  final _costoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.proyecto?['name'] ?? '';
    _costoController.text = widget.proyecto?["costo"].toString() ?? "Sin costo total";
    _inicioDate = widget.proyecto?['fecha_inicio'] != null
        ? DateTime.parse(widget.proyecto?['fecha_inicio'])
        : null;
    _finDate = widget.proyecto?['fecha_fin'] != null
        ? DateTime.parse(widget.proyecto?['fecha_fin'])
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: formView(context),
        ),
      ),
    );
  }

  Container formView(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Proyecto',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa el nombre del proyecto';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            _buildDateTimePicker(
              labelText: 'Fecha de inicio',
              selectedDate: _inicioDate,
              onDateSelected: (date) {
                setState(() {
                  _inicioDate = date;
                });
              },
            ),
            const SizedBox(height: 16.0),
            _buildDateTimePicker(
              labelText: 'Fecha de finalización',
              selectedDate: _finDate,
              onDateSelected: (date) {
                setState(() {
                  _finDate = date;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _costoController,
              decoration: const InputDecoration(
                labelText: 'Costo total del proyecto',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa el costo del proyecto';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              child: FilledButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String nombre = _nombreController.text;
                    String fechaInicio = _inicioDate?.toString() ?? '';
                    String fechaFinalizada = _finDate?.toString() ?? '';
                    String costo = _costoController.text;

                    try {
                      await updateProyecto(widget.proyecto?["id"], nombre, fechaInicio, fechaFinalizada, costo);
                      print('Proyecto actualizado: $nombre');
                      // Muestra el Snackbar al actualizar el proyecto
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Proyecto actualizado correctamente'),
                        ),
                      );
                    } catch (error) {
                      print('Error al actualizar el proyecto: $error');
                    }
                  }
                },
                child: const Text('Sobreescribir'),
              ),
            ),
            const SizedBox(height: 6.0),
Container(
  width: double.infinity,
  child: IconButton.filled(
    icon: Icon(Icons.delete_forever),
    style: IconButton.styleFrom(
      backgroundColor: Colors.red,
    ),
onPressed: () async {
  // Mostrar un diálogo de confirmación antes de eliminar
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Eliminar Proyecto'),
        content: Text('¿Seguro que quieres eliminar este proyecto?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                Navigator.of(context).pop();

                // Mostrar un SnackBar 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Proyecto Eliminado...'),
                  ),
                );

                await deleteProyecto(widget.proyecto?["id"]);
                print('Proyecto eliminado');
              } catch (error) {
                print('Error al eliminar el proyecto: $error');
              }
            },
            child: Text('Confirmar'),
          ),
        ],
      );
    },
  );
},

  ),
),
Center(
  child: Row(
    children: [
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        margin: EdgeInsets.only(top: 30),
        width: 250,
        decoration: BoxDecoration(color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: const Color.fromARGB(101, 0, 0, 0), offset: Offset(0, 2), blurRadius: 4.0)]
        ),
        child: const Column(
          children: [        
            ListTile(
                title: Text("Total: \$2500", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                subtitle: Row(
                  children: [
                  Column(children: [
                    Text("Abonado", style: TextStyle(fontSize: 20, color: Colors.amber, fontWeight: FontWeight.w500)),
                    Text("\$400", style: TextStyle(fontSize: 20, color: Colors.amber, fontWeight: FontWeight.w500))
                  ], ),
                  SizedBox(width: 10,),
                  Column(children: [
                    Text("Restante", style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.w500)),
                    Text("\$400", style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.w500))
                  ]
                  ,)],
                ),
              )],
        )
      ),
      Column(
        children: [
          IconButton.filled(onPressed: (){}, icon: Icon(Icons.receipt),
          style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0), 
                    ),
                  )
          ),
          ),
          IconButton.filled(onPressed: (){}, icon: Icon(Icons.add),
          style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green),       
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ), 
                  )
                  ,
            )
          )
        ],
      )
    ],
  ),
)

          ],
        ),
      ),
    );
  }

  Widget _buildDateTimePicker({
    required String labelText,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    DateTime initialDate = selectedDate ?? DateTime.now();

    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null && pickedDate != selectedDate) {
          onDateSelected(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          fillColor: Colors.white,
          filled: true,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              selectedDate != null
                  ? "${selectedDate.toLocal()}".split(' ')[0]
                  : 'Seleccione una fecha',
            ),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}
