import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;
  const PdfViewerPage({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  File? localPdf;

  @override
  void initState() {
    super.initState();
    downloadPdf();
  }

  Future<void> downloadPdf() async {
  try {
    // Replace /image/ with /raw/ in the URL
    final rawPdfUrl = widget.pdfUrl.replaceFirst('/image/', '/raw/');
    print('Downloading from: $rawPdfUrl');

    final response = await http.get(Uri.parse(rawPdfUrl));
    print('Download response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/book.pdf');
      await file.writeAsBytes(response.bodyBytes);
      setState(() => localPdf = file);
    } else {
      throw Exception('HTTP error ${response.statusCode}');
    }
  } catch (e) {
    print('PDF download error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to load PDF')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading Book')),
      body: localPdf == null
          ? Center(child: CircularProgressIndicator())
          : SfPdfViewer.file(localPdf!),
    );
  }
}