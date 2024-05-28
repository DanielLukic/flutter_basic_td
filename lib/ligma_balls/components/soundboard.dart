import 'package:dart_minilog/dart_minilog.dart';
import 'package:flame_audio/flame_audio.dart';

enum Sound {
  death,
  explosion,
  deez_nutz,
  game_over,
  ligma,
  ligma_balls,
  rock,
  score,
  swoosh,
  vim,
}

final soundboard = Soundboard();

class Soundboard {
  double masterVolume = 0.1;

  preload() async {
    for (final it in Sound.values) {
      logInfo('cache $it');
      await FlameAudio.audioCache.load('${it.name}.ogg');
    }
  }

  play(Sound sound, {double? volume}) {
    volume ??= sound.volume;
    volume *= masterVolume;
    FlameAudio.play('${sound.name}.ogg', volume: volume);
  }
}

extension on Sound {
  double get volume {
    if (this == Sound.deez_nutz) {
      return 1;
    } else if (this == Sound.ligma_balls) {
      return 1;
    } else {
      return 0.5;
    }
  }
}
