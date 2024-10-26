import 'package:flutter/material.dart';
import 'package:quranapp/surah_detail.dart';
import 'api_service.dart';

void main() {
  runApp(MyQuranApp());
}

class MyQuranApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Al-Quran with Text and Audio',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: QuranHomePage(),
    );
  }
}

class QuranHomePage extends StatefulWidget {
  @override
  _QuranHomePageState createState() => _QuranHomePageState();
}

class _QuranHomePageState extends State<QuranHomePage> {
  final ApiService apiService = ApiService();
  List surahTextList = [];
  List surahAudioList = [];

  @override
  void initState() {
    super.initState();
    loadQuranData();
  }

  Future<void> loadQuranData() async {
    final textData = await apiService.fetchQuranText();
    final audioData = await apiService.fetchQuranAudio();

    if (textData != null && audioData != null) {
      setState(() {
        surahTextList = textData['data']['surahs'];
        surahAudioList = audioData['data']['surahs'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Al-Quran with Text and Audio'),
      ),
      body: surahTextList.isEmpty || surahAudioList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: surahTextList.length,
        itemBuilder: (context, index) {
          final surahText = surahTextList[index];
          final surahAudio = surahAudioList[index];
          return ListTile(
            title: Text(surahText['englishName']),
            subtitle: Text('Verses: ${surahText['ayahs'].length}'),
            trailing: IconButton(
              icon: Icon(Icons.play_arrow, color: Colors.green),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahDetailScreen(
                    surahText: surahText,
                    surahAudio: surahAudio,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}