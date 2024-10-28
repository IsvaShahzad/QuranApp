import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SurahDetailScreen extends StatefulWidget {
  final Map surahText;
  final Map surahAudio;

  SurahDetailScreen({required this.surahText, required this.surahAudio});

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int currentAyahIndex = 0;

  // List of pastel colors
  final List<Color> pastelColors = [
    Color(0xFFFFF0DA), // Light Peach
    Color(0xFFD3EBCD), // Light Green
    Color(0xFFDCF2F8), // Light Blue
    Color(0xFFFFD1DC), // Light Pink
  ];

  void _playSurahAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
      return;
    }

    setState(() {
      isPlaying = true;
      currentAyahIndex = 0; // Reset to the first Ayah
    });

    // Play the first Ayah
    _playAyah(currentAyahIndex);
  }

  Future<void> _playAyah(int index) async {
    if (index < widget.surahText['ayahs'].length) {
      final audioUrl = widget.surahAudio['ayahs'][index]['audioSecondary'][0]; // Get the audio URL for the current Ayah
      await _audioPlayer.play(UrlSource(audioUrl)); // Play the Ayah audio
    }
  }

  @override
  void initState() {
    super.initState();
    // Set up the listener for when the audio finishes playing
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        // Move to the next Ayah
        currentAyahIndex++;
        if (currentAyahIndex < widget.surahText['ayahs'].length) {
          _playAyah(currentAyahIndex); // Play the next Ayah
        } else {
          setState(() {
            isPlaying = false; // Stop playback when all Ayahs have been played
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
                // ListView for Ayahs
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.surahText['ayahs'].length,
                  itemBuilder: (context, index) {
                    final ayahText = widget.surahText['ayahs'][index];
                    final backgroundColor = pastelColors[index % pastelColors.length];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
                      child: Card(
                        elevation: 1,
                        color: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                ayahText['text'],
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 23),
                              ),
                              SizedBox(height: 22),
                              Text(
                                'Ayah ${ayahText['numberInSurah']}',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
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