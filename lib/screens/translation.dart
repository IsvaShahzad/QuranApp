import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuranTranslationScreen extends StatefulWidget {
  @override
  _QuranTranslationScreenState createState() => _QuranTranslationScreenState();
}

class _QuranTranslationScreenState extends State<QuranTranslationScreen> {
  List<dynamic> _surahs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuranTranslation();
  }

  Future<void> fetchQuranTranslation() async {
    final url = 'http://api.alquran.cloud/v1/quran/en.asad';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _surahs = data['data']['surahs'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load Quran translation');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching Quran translation: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quran Translation'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _surahs.length,
        itemBuilder: (context, index) {
          final surah = _surahs[index];
          return ExpansionTile(
            title: Text(
              '${surah['englishName']} (${surah['englishNameTranslation']})',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text('Surah ${surah['number']} - ${surah['revelationType']}'),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: surah['ayahs'].length,
                itemBuilder: (context, ayahIndex) {
                  final ayah = surah['ayahs'][ayahIndex];
                  return ListTile(
                    title: Text(
                      ayah['text'],
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text('Ayah ${ayah['numberInSurah']}'),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
