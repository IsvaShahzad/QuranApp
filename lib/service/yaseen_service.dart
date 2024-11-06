// import 'dart:typed_data';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
//
// Future<String> fetchAndSaveManzil(int yaseenNumber) async {
//   final response = await http.get(Uri.parse('https://3971-119-73-100-175.ngrok-free.app /pdfs/yaseen.pdf')); // Your Ngrok public URL
//
//   if (response.statusCode == 200) {
//     // Get the temporary directory where we'll store the PDF file
//     final directory = await getTemporaryDirectory();
//     final filePath = '${directory.path}/yaseen.pdf';
//
//     // Save the PDF data to the file
//     final file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//
//     return filePath;  // Return the file path where the PDF is saved
//   } else {
//     throw Exception('Failed to load Yaseen PDF');
//   }
// }
