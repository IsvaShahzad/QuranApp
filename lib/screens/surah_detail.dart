import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
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
                            backgroundColor: Colors.blue,
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
                          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 13),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffefefef),
                                    borderRadius: BorderRadius.circular(12), // Round corners
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  child: Row(
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
                                              Icons.translate, // Use translation icon
                                              color: Color(0xff008080),
                                              size: 25,
                                            ),
                                            onPressed: () {
                                              // Fetch the translation text here
                                              String translationText = ayahText['translation'] ?? 'Translation not available.';

                                              // Navigate to the VerseTranslationScreen with the required parameters
                                              _navigateToTranslation(ayahText['text'], translationText, widget.surahNumber, ayahText['numberInSurah'].toString());
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  ayahText['text'],
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Divider(), // Add a divider after each verse
                            ],
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
