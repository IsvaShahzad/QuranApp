  import 'dart:convert';
  import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quranapp/screens/main_screen.dart';
  import 'package:quranapp/screens/star.dart';
  import 'package:quranapp/screens/surah_detail.dart';
  import 'package:quranapp/screens/surah_names.dart';
import 'package:quranapp/screens/translation.dart';
  import 'service/api_service.dart';
  import 'package:shared_preferences/shared_preferences.dart';

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
        home: MainScreen(),
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
    List filteredSurahTextList = [];
    List filteredSurahAudioList = [];
    bool isLoading = true;  // Main loading flag for initial data loading
    bool isTileLoading = false; // Loading flag for individual list tile
    String searchQuery = "";

    @override
    void initState() {
      super.initState();
      loadQuranData();
    }

    Future<void> loadQuranData() async {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('quranData');

      if (cachedData != null) {
        setState(() {
          final data = jsonDecode(cachedData);
          surahTextList = data['text'];
          surahAudioList = data['audio'];
          filteredSurahTextList = surahTextList;
          filteredSurahAudioList = surahAudioList;
          isLoading = false;
        });
      } else {
        try {
          final textFuture = apiService.fetchQuranText();
          final audioFuture = apiService.fetchQuranAudio();
          final responses = await Future.wait([textFuture, audioFuture]);
          final textData = responses[0];
          final audioData = responses[1];

          if (textData != null && audioData != null) {
            setState(() {
              surahTextList = textData['data']['surahs'];
              surahAudioList = audioData['data']['surahs'];
              filteredSurahTextList = surahTextList;
              filteredSurahAudioList = surahAudioList;
              isLoading = false;

              final dataToCache = {
                'text': surahTextList,
                'audio': surahAudioList,
              };
              prefs.setString('quranData', jsonEncode(dataToCache));
            });
          }
        } catch (error) {
          setState(() {
            isLoading = false;
          });
          print('Error loading data: $error');
        }
      }
    }

    void _filterSurahs(String query) {
      setState(() {
        searchQuery = query;
        if (query.isEmpty) {
          filteredSurahTextList = surahTextList;
          filteredSurahAudioList = surahAudioList;
        } else {
          filteredSurahTextList = surahTextList.where((surah) {
            return surah['englishName']
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();

          filteredSurahAudioList = surahAudioList.where((surah) {
            return surah['englishName']
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();
        }
      });
    }

    Widget _buildQuickAccessSection() {
      List<Map<String, dynamic>> quickAccessSurahs = [
        ...surahTextList.take(8), // Get the first 8 Surahs from the API
      ];

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: quickAccessSurahs.length,
            itemBuilder: (context, index) {
              final surah = quickAccessSurahs[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahDetailScreen(
                          surahText: surah,
                          surahAudio: surahAudioList[index], // Ensure this is available
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: Color(0xff866c55),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  child: Text(
                    surah['englishName'],
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

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
                    'Reading Surah',
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
                Padding(
                  padding: EdgeInsets.only(right: 230),
                  child: Text(
                    'Quick access',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.grey[500],
                      fontSize: 15,
                    ),
                  ),
                ), // Space between search bar and quick access section
                SizedBox(height: 5), // Space between quick access and list tile
                _buildQuickAccessSection(), // Quick Access section
                SizedBox(height: 10), // Space between quick access and list tile
                isLoading
                    ? Center(
                  child: SpinKitThreeBounce(  // Use three bouncing dots as a loading indicator
                    color: Colors.grey,  // Set your desired color here
                    size: 20.0,
                  ),
                )
                    : Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.03,
                    ),
                    itemCount: filteredSurahTextList.length,
                    itemBuilder: (context, index) {
                      final surahText = filteredSurahTextList[index];
                      final surahAudio = filteredSurahAudioList[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                // Star Shape
                                Container(
                                  width: 30,
                                  height: 30,
                                  child: CustomPaint(
                                    painter: StarPainter('${index + 1}'),
                                  ),
                                ),
                                SizedBox(width: 20), // Space between star and English name
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        surahText['englishName'],
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: screenWidth * 0.045,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Text(
                                          '${surahText['englishNameTranslation']}',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Color(0xff725c48),
                                            fontSize: screenWidth * 0.035,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Arabic Name on the right
                                SizedBox(width: 20), // Space between text and Arabic name
                                Text(
                                  surahText['name'],
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: screenWidth * 0.059,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              setState(() {
                                isTileLoading = true;  // Set loading flag to true when tile is tapped
                              });

                              await Future.delayed(Duration(seconds: 2));  // Simulate delay
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SurahDetailScreen(
                                    surahText: surahText,
                                    surahAudio: surahAudio,
                                  ),
                                ),
                              );

                              setState(() {
                                isTileLoading = false;  // Set loading flag to false after navigation
                              });
                            },
                          ),
                          // if (isTileLoading)
                          //   Center(
                          //     child: SpinKitThreeBounce(
                          //       color: Colors.grey,
                          //       size: 20.0,
                          //     ),
                          //   ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            if (isTileLoading)  // Show loading spinner when any tile is being processed
              SpinKitThreeBounce(
                color: Colors.grey,
                size: 30.0,
              ),
          ],
        ),
      );
    }
  }
