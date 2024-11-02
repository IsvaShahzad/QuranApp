import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchManzilAsad() async {
  final response = await http.get(Uri.parse('http://api.alquran.cloud/v1/manzil/7/en.asad'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load Manzil Asad data');
  }
}

Future<Map<String, dynamic>> fetchManzilUthmani() async {
  final response = await http.get(Uri.parse('http://api.alquran.cloud/v1/manzil/7/quran-uthmani'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load Manzil Uthmani data');
  }
}
