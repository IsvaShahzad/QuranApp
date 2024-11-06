import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quranapp/service/manzil_service.dart';  // Import your service
import 'package:flutter_pdfview/flutter_pdfview.dart';  // Import the PDF view package
import 'package:flutter_spinkit/flutter_spinkit.dart';  // Import the SpinKit package

// Manzil Screen Widget
class ManzilScreen extends StatelessWidget {
  final int manzilNumber;

  ManzilScreen({this.manzilNumber = 1});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(  // Use FutureBuilder to handle async PDF download and display
        future: fetchAndSaveManzil(manzilNumber),  // Fetch and save PDF using Ngrok URL
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitThreeBounce(  // Use three bouncing dots as a loading indicator
                color: Colors.grey,  // Set your desired color here
                size: 20.0,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));  // Handle any errors
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No PDF data available'));  // Handle case where no data is returned
          }

          // PDF file path received, now show it
          return PDFView(
            filePath: snapshot.data,  // Pass the file path to PDFView to render the PDF
          );
        },
      ),
    );
  }
}
