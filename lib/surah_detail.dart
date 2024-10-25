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
    } else {
      final audioUrl = widget.surahAudio['ayahs'][0]['audioSecondary'][0];
      await _audioPlayer.play(UrlSource(audioUrl)); // Wrap audio URL with UrlSource
    }
    setState(() {
      isPlaying = !isPlaying;
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
      body: SingleChildScrollView( // Wrap Column with SingleChildScrollView
        child: Stack(
          children: [
            Column(
              children: [
                // Container for Surah Name
                Container(
                  width: double.infinity,
                  // Remove fixed height to fit the content dynamically
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://img.freepik.com/free-photo/abstract-luxury-gradient-blue-background-smooth-dark-blue-with-black-vignette-studio-banner_1258-63452.jpg", // Replace with your network image URL
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40), // Increased padding
                  margin: const EdgeInsets.all(1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.surahText['englishNameTranslation'],
                          style: TextStyle(
                            fontSize: 30, // Increased font size
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Center(
                        child: Text(
                          'Total Ayahs: ${widget.surahText['ayahs'].length}',
                          style: TextStyle(
                            fontSize: 18, // Increased font size
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      SizedBox(height: 20), // Space between text and button
                      Center(
                        child: ElevatedButton(
                          onPressed: _playSurahAudio,
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(), // Circular shape
                            backgroundColor: Colors.blue, // Button color
                            padding: EdgeInsets.all(8), // Button padding
                          ),
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 24, // Icon size
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10), // Add some spacing after the container
                // ListView for Ayahs
                ListView.builder(
                  shrinkWrap: true, // Use shrinkWrap to prevent overflow
                  physics: NeverScrollableScrollPhysics(), // Disable scrolling for ListView
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
                          borderRadius: BorderRadius.circular(2), // Rounded corners
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
                              SizedBox(height: 22), // Space between text and subtitle
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
