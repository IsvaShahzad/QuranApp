import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';  // For loading spinner
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ManzilScreen extends StatefulWidget {
  final int manzilNumber;

  ManzilScreen({this.manzilNumber = 1});

  @override
  _ManzilScreenState createState() => _ManzilScreenState();
}

class _ManzilScreenState extends State<ManzilScreen> {
  bool isLoading = true;
  String pdfUrl = "https://drive.google.com/uc?export=download&id=1O_yT7hDj0jSmN_xGu-djH82TWhhI2dh_"; // Google Drive link

  late String filePath;

  @override
  void initState() {
    super.initState();
    downloadPdf();  // Start the download process as soon as the screen is initialized
  }

  // Function to download the PDF
  Future<void> downloadPdf() async {
    try {
      // Show a loading spinner and get the temporary directory to store the PDF
      final dir = await getTemporaryDirectory();
      filePath = "${dir.path}/manzil.pdf";  // Specify the file path

      // Download the PDF asynchronously without blocking UI
      final response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode == 200) {
        // Save the PDF to the file path asynchronously
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Update the UI to stop showing the loading spinner
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("Failed to download PDF: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error downloading PDF: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
        child: SpinKitThreeBounce(
          color: Colors.grey,
          size: 20.0,
        ),
      )
          : PDFView(
        filePath: filePath,  // Pass the downloaded file path to PDFView
      ),
    );
  }
}
