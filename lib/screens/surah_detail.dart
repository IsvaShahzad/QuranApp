import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quranapp/screens/translation.dart';
import 'package:quranapp/screens/verse.dart';

class SurahDetailScreen extends StatefulWidget {
  final Map surahText;
  final Map surahAudio;

  SurahDetailScreen({
    required this.surahText,
    required this.surahAudio,
  });

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isSurahPlaying = false;
  int currentAyahIndex = 0;

  void _playSurahAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        isPlaying = false;
        isSurahPlaying = false;
      });
      return;
    }

    setState(() {
      isPlaying = true;
      isSurahPlaying = true;
      currentAyahIndex = 0;
    });

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
      isSurahPlaying = false;
    });
    final audioUrl = widget.surahAudio['ayahs'][index]['audioSecondary'][0];
    await _audioPlayer.play(UrlSource(audioUrl));
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
              isSurahPlaying = false;
            });
          }
        } else {
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Surah header
            Padding(
              padding: EdgeInsets.only(top: 60),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/3.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                      bottom: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                      bottom: Radius.circular(30),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Text(
                              widget.surahText['englishName'],
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            widget.surahText['englishNameTranslation'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${widget.surahText['ayahs'].length} Verses',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10), // Space below header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Image.asset(
                'assets/images/bismillah.jpg',
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Ayah list with end alignment
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.surahText['ayahs'].length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
              itemBuilder: (context, index) {
                final ayahText = widget.surahText['ayahs'][index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffe7dfd9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: Color(0xff866c55),
                              child: Text(
                                '${ayahText['numberInSurah']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.play_arrow,
                                color: Color(0xff866c55),
                                size: 25,
                              ),
                              onPressed: () => _playSpecificAyah(index),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.bookmark_border,
                                color: Color(0xff866c55),
                                size: 25,
                              ),
                              onPressed: () {
                                // Bookmark action here
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: Text(
                        ayahText['text'],
                        style: TextStyle(fontSize: 23),
                        textAlign: TextAlign.end, // Right-align all ayahs
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
