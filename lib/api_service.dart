import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String textApiUrl = 'http://api.alquran.cloud/v1/quran/quran-uthmani';
  final String audioApiUrl = 'http://api.alquran.cloud/v1/quran/ar.alafasy';

  Future<Map<String, dynamic>?> fetchQuranText() async {
    try {
      final response = await http.get(Uri.parse(textApiUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load Quran text data');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchQuranAudio() async {
    try {
      final response = await http.get(Uri.parse(audioApiUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load Quran audio data');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}