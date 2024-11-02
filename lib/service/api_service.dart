import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String textApiUrl = 'http://api.alquran.cloud/v1/quran/quran-uthmani';
  final String audioApiUrl = 'http://api.alquran.cloud/v1/quran/ar.alafasy';
  final String translationApiUrl = 'http://api.alquran.cloud/v1/quran/en.asad';

  // New Indopak script API URL
  final String indopakApiUrl = 'https://api.quran.com/api/v4/quran/verses/indopak';

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

  Future<dynamic> fetchQuranTranslation() async {
    final response = await http.get(Uri.parse(translationApiUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Quran translation');
    }
  }

  // New method to fetch Indopak script
  Future<Map<String, dynamic>?> fetchIndopakScript() async {
    try {
      final response = await http.get(Uri.parse(indopakApiUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load Indopak script data');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  void getIndopakScript() async {
    ApiService apiService = ApiService();
    var indopakData = await apiService.fetchIndopakScript();

    if (indopakData != null) {
      // Handle the Indopak script data
      print(indopakData); // or process it as needed
    } else {
      print('Failed to fetch Indopak script');
    }
  }

}
