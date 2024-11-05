import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchManzil(int manzilNumber) async {
  final response = await http.get(Uri.parse('https://api.quranhub.com/v1/manzil/$manzilNumber'));

  if (response.statusCode == 200) {
    return json.decode(utf8.decode(response.bodyBytes)); // Ensure proper UTF-8 decoding
  } else {
    throw Exception('Failed to load Manzil data');
  }
}
