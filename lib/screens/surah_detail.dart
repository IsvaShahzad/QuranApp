import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quranapp/screens/translation.dart';
import 'package:quranapp/screens/verse.dart'; // Ensure this imports your VerseTranslationScreen

class SurahDetailScreen extends StatefulWidget {
  final Map surahText;
  final Map surahAudio;
  final String surahNumber;
  final String ayahNumber;
  final String verseText; // The actual verse text

  SurahDetailScreen({
    required this.surahText,
    required this.surahAudio,
    required this.ayahNumber,
    required this.surahNumber,
    required this.verseText,
  });

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isSurahPlaying = false; // Indicates continuous surah playback
  int currentAyahIndex = 0;

  void _playSurahAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        isPlaying = false;
        isSurahPlaying = false; // Stop continuous surah playback
      });
      return;
    }

    setState(() {
      isPlaying = true;
      isSurahPlaying = true; // Start continuous surah playback
      currentAyahIndex = 0;
    });

    // Play the first Ayah
    _playAyah(currentAyahIndex);
  }

  Future<void> _playAyah(int index) async {
    if (index < widget.surahText['ayahs'].length) {
      final audioUrl = widget.surahAudio['ayahs'][index]['audioSecondary'][0];
      await _audioPlayer.play(UrlSource(audioUrl));
    }
  }

  Future<void> _playSpecificAyah(int index) async {
    setState(() {
      isPlaying = true;
      isSurahPlaying = false; // Single ayah playback, not continuous
    });
    final audioUrl = widget.surahAudio['ayahs'][index]['audioSecondary'][0];
    await _audioPlayer.play(UrlSource(audioUrl));
  }

  void _navigateToTranslation(String verseText, String translationText, String surahNumber, String ayahNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerseTranslationScreen(
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          translationText: translationText, verseText: verseText,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        if (isSurahPlaying) {
          currentAyahIndex++;
          if (currentAyahIndex < widget.surahText['ayahs'].length) {
            _playAyah(currentAyahIndex);
          } else {
            setState(() {
              isPlaying = false;
              isSurahPlaying = false; // Surah playback completed
            });
          }
        } else {
          // If single ayah playback completes, reset play state
          setState(() {
            isPlaying = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                // Container for Surah Name
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://t4.ftcdn.net/jpg/08/60/31/89/360_F_860318940_RPEYG8qhieE8pyk4Fnc1N4qGEU2avo0q.jpg',
                      ),
                      fit: BoxFit.cover, // Use BoxFit.cover for better filling
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                  margin: const EdgeInsets.all(0), // Set margin to 0 to fill corners
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.surahText['englishName'],
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Center(
                        child: Text(
                          widget.surahText['englishNameTranslation'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Divider(
                        color: Colors.white, // Color of the divider
                        thickness: 0.6, // Thickness of the divider
                        indent: 20, // Indentation from the left
                        endIndent: 20, // Indentation from the right
                      ),
                      SizedBox(height: 4), // Space between the divider and the next text
                      Center(
                        child: Text(
                          '${widget.surahText['ayahs'].length} Verses',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _playSurahAudio,
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Colors.teal,
                            padding: EdgeInsets.all(8),
                          ),
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // Ayahs list
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.surahText['ayahs'].length,
                  itemBuilder: (context, index) {
                    final ayahText = widget.surahText['ayahs'][index];

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Color(0xffefefef),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min, // Allow the column to take minimal height
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      radius: 13,
                                      backgroundColor: Color(0xff008080),
                                      child: Text(
                                        '${ayahText['numberInSurah']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.play_arrow,
                                            color: Color(0xff008080),
                                            size: 25,
                                          ),
                                          onPressed: () => _playSpecificAyah(index),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.bookmark_border,
                                            color: Color(0xff008080),
                                            size: 25,
                                          ),
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context) => QuranTranslationScreen()),
                                                  (Route<dynamic> route) => false,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8), // Space between icon row and text
                                Container(
                                  width: double.infinity, // Ensures the text container takes the full width
                                  child: Text(
                                    ayahText['text'],
                                    style: TextStyle(fontSize: 23),
                                    textAlign: TextAlign.end, // Ensure left alignment within the text widget
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}