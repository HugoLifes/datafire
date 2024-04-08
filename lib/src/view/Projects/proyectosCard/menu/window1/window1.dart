import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class Window1 extends StatefulWidget {
  final int projectId;

  const Window1({Key? key, required this.projectId}) : super(key: key);

  @override
  _Window1State createState() => _Window1State();
}

class _Window1State extends State<Window1> {
  String? pdfPath;

  @override
  void initState() {
    super.initState();
    // Aquí haces la llamada a la API para obtener el PDF
    // Reemplaza "getPdfPath" con el método adecuado para obtener el PDF
    getPdfPath(widget.projectId).then((path) {
      setState(() {
        pdfPath = path;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del proyecto'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            pdfPath != null
                ? Container(
                    height: 400, // Ajusta la altura según sea necesario
                    child: PDFView(
                      filePath: pdfPath!,
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Función para imprimir el PDF
                if (pdfPath != null) {
                  // Lógica para imprimir el PDF
                  // Esto puede variar según la plataforma
                  // Por ejemplo, para Android puedes usar la plataforma 'android_intent'
                  // y para iOS 'url_launcher'
                }
              },
              child: Text('Imprimir PDF'),
            ),
          ],
        ),
      ),
    );
  }

  // Método para obtener el path del PDF desde la API
  Future<String?> getPdfPath(int projectId) async {
    // Realiza la llamada a la API para obtener el PDF y retorna el path
    // Reemplaza esta lógica con la llamada real a tu API
    // Ejemplo:
    // String pdfPath = await myApiService.getPdfPath(projectId);
    // return pdfPath;
    return "http://localhost:3000/Api/v1/proyectos/$projectId/pdf";
  }
}
