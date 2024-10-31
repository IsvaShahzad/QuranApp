import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VerseTranslationScreen extends StatefulWidget {
  final String surahNumber;
  final String ayahNumber;
  final String translationText;
  final String verseText; // Renamed from verseText to verseTxt

  VerseTranslationScreen({
    required this.surahNumber,
    required this.ayahNumber,
    required this.translationText,
    required this.verseText, // Updated to match the new parameter name
  });

  @override
  _VerseTranslationScreenState createState() => _VerseTranslationScreenState();
}

class _VerseTranslationScreenState extends State<VerseTranslationScreen> {
  String _arabicVerse = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArabicVerse();
  }

  Future<void> fetchArabicVerse() async {
    final url = 'http://api.alquran.cloud/v1/ayah/${widget.surahNumber}:${widget.ayahNumber}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _arabicVerse = data['data']['text'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load Arabic verse');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching Arabic verse: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verse Translation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ayah:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _arabicVerse, // Displaying the Arabic verse fetched from the API
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Translation:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.verseText, // Displaying the verse text passed from the previous screen
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}
