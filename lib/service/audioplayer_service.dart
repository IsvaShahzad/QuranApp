import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();

  factory AudioPlayerService() {
    return _instance;
  }

  AudioPlayerService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int currentAyahIndex = 0;

  void play(String audioUrl) async {
    if (isPlaying) {
      await _audioPlayer.pause();
    }
    await _audioPlayer.play(UrlSource(audioUrl));
    isPlaying = true;

    // Setup listener for player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        isPlaying = false; // Mark as not playing when completed
        currentAyahIndex++; // Move to next Ayah
      }
    });
  }

  void pause() async {
    await _audioPlayer.pause();
    isPlaying = false;
  }

  void stop() async {
    await _audioPlayer.stop();
    isPlaying = false;
    currentAyahIndex = 0;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
