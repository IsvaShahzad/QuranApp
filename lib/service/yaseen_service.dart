// yaseen_service.dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String> fetchAndSaveYaseen() async {
  final response = await http.get(Uri.parse('https://0852-119-73-100-175.ngrok-free.app/pdf/yaseen.pdf')); // Replace with your current Ngrok URL

  if (response.statusCode == 200) {
    // Get the temporary directory where we'll store the PDF file
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/yaseen.pdf';

    // Save the PDF data to the file
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return filePath;  // Return the file path where the PDF is saved
  } else {
    throw Exception('Failed to load Yaseen PDF');
  }
}
