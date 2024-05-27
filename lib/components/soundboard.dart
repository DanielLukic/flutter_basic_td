import 'package:dart_minilog/dart_minilog.dart';
import 'package:flame_audio/flame_audio.dart';

enum Sound {
  death,
  explosion,
  game_over,
  rock,
  score,
  swoosh,
  vim,
}

final soundboard = Soundboard();

class Soundboard {
  preload() async {
    for (final it in Sound.values) {
      logInfo('cache $it');
      await FlameAudio.audioCache.load('${it.name}.ogg');
    }
  }

  play(Sound sound, {double volume = 0.5}) {
    FlameAudio.play('${sound.name}.ogg', volume: volume);
  }
}
