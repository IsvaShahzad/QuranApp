// yaseen_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quranapp/service/yaseen_service.dart'; // Import the Yaseen service
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Import the PDF view package
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import flutter_spinkit package

class YaseenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: fetchAndSaveYaseen(), // Fetch and save Yaseen PDF using Ngrok URL
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitThreeBounce(
                color: Colors.grey, // Set the color of the dots
                size: 20.0,         // Set the size of the dots
              ),
            ); // Show three dots while fetching PDF
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Handle any errors
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No PDF data available')); // Handle case where no data is returned
          }

          // PDF file path received, now show it
          return PDFView(
            filePath: snapshot.data, // Pass the file path to PDFView to render the PDF
          );
        },
      ),
    );
  }
}
