import 'dart:convert';
import 'package:http/http.dart' as http;

// Function to fetch English translation of sajda ayahs
Future<Map<String, dynamic>> fetchSajdaAyahs() async {
  final response = await http.get(Uri.parse('http://api.alquran.cloud/v1/sajda/en.asad'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load sajda ayahs');
  }
}

// Function to fetch Arabic text of sajda ayahs
Future<Map<String, dynamic>> fetchSajdaAyahsArabic() async {
  final response = await http.get(Uri.parse('http://api.alquran.cloud/v1/sajda/quran-uthmani'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load sajda ayahs in Arabic');
  }
}
