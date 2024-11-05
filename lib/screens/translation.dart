import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quranapp/screens/star.dart';
import 'package:quranapp/screens/surah_detail.dart';
import 'package:quranapp/screens/verse.dart';

class QuranTranslationScreen extends StatefulWidget {
  @override
  _QuranTranslationScreenState createState() => _QuranTranslationScreenState();
}

class _QuranTranslationScreenState extends State<QuranTranslationScreen> {
  List<dynamic> _surahs = [];
  bool _isLoading = true;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchQuranTranslation();
  }

  Future<void> fetchQuranTranslation() async {
    final url = 'http://api.alquran.cloud/v1/quran/en.asad'; // Change to your desired translation
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

  void _filterSurahs(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  // void _navigateToSurahDetail(List<dynamic> ayahs, String surahNumber, String surahName) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => SurahDetailScreen(
  //         surahNumber: surahNumber,
  //         surahName: surahName,
  //         ayahs: ayahs,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: screenHeight * 0.11),
              Padding(
                padding: EdgeInsets.only(right: 235),
                child: Text(
                  'Al-Quran,',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 140),
                child: Text(
                  'Translations',
                  style: TextStyle(fontSize: 25, fontFamily: 'Montserrat'),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: TextField(
                  onChanged: _filterSurahs,
                  decoration: InputDecoration(
                    hintText: 'Search Surah',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: screenWidth * 0.04,
                      fontFamily: 'Montserrat',
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search, size: screenWidth * 0.06),
                  ),
                  cursorColor: Colors.black,
                ),
              ),
              SizedBox(height: 15),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.03,
                  ),
                  itemCount: _surahs.length,
                  itemBuilder: (context, index) {
                    final surah = _surahs[index];
                    if (_searchQuery.isNotEmpty &&
                        !surah['englishName']
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase())) {
                      return Container(); // Skip this item if it doesn't match the search query
                    }
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      leading: Container(
                        width: 40,
                        height: 40,
                        child: CustomPaint(
                          painter: StarPainter('${index + 1}'), // Assuming StarPainter is defined
                        ),
                      ),
                      title: Text(
                        '${surah['englishName']} (${surah['englishNameTranslation']})',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text('Surah ${surah['number']} - ${surah['revelationType']}'),
                      onTap: () {
                        // _navigateToSurahDetail(surah['ayahs'], surah['number'].toString(), surah['englishName']);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
