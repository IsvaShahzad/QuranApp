import 'dart:convert';
import 'package:http/http.dart' as http;

// Fetch Juz 30 from Muhammad Asad's translation
Future<Map<String, dynamic>> fetchJuz30Asad() async {
  final response = await http.get(Uri.parse('http://api.alquran.cloud/v1/juz/30/en.asad'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load Juz 30 Asad translation');
  }
}

// Fetch Juz 30 in Uthmani text
Future<Map<String, dynamic>> fetchJuz30Uthmani() async {
  final response = await http.get(Uri.parse('http://api.alquran.cloud/v1/juz/30/quran-uthmani'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load Juz 30 Uthmani text');
  }
}
