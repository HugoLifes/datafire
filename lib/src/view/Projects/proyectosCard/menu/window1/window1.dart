import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:printing/printing.dart';

class Window1 extends StatelessWidget {
  final Map<String, dynamic>? proyecto;

  const Window1({Key? key, this.proyecto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          proyecto != null ? buildProjectDetails(context) : buildEmptyState(),
        ],
      ),
    );
  }

  Widget buildProjectDetails(BuildContext context) {
    List<Widget> projectDetails = proyecto!.entries.map((entry) {
      return Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: const Icon(Icons.check_circle_outline),
          title: Text(entry.key,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${entry.value}'),
        ),
      );
    }).toList();

    projectDetails.add(
      Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => _viewPDF(context, proyecto!['id']),
            child: const Text('Ver PDF'),
          ),
        ),
      ),
    );

    return Column(
      children: projectDetails,
    );
  }

  Widget buildEmptyState() {
    return const Center(
      child: Text('No hay detalles del proyecto para mostrar.'),
    );
  }

  Future<void> _viewPDF(BuildContext context, int projectId) async {
    String url =
        'https://data-fire-product.up.railway.app/Api/v1/proyectos/$projectId/pdf';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Uint8List pdfData = response.bodyBytes;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(pdfData: pdfData),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al obtener el PDF')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectarse a la API: $e')),
      );
    }
  }
}

class PDFViewerPage extends StatelessWidget {
  final Uint8List pdfData;

  const PDFViewerPage({Key? key, required this.pdfData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista previa del PDF'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _printPDF(context),
          ),
        ],
      ),
      body: SfPdfViewer.memory(pdfData),
    );
  }

  Future<void> _printPDF(BuildContext context) async {
    await Printing.layoutPdf(
      onLayout: (format) => pdfData,
    );
  }
}
