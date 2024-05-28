import 'package:flame/components.dart';
import 'package:ligma_balls/ligma_balls/components/ligma_world.dart';
import 'package:ligma_balls/ligma_balls/components/soundboard.dart';
import 'package:ligma_balls/ligma_balls/level/game_over_dialog.dart';
import 'package:ligma_balls/ligma_balls/level/level_complete_dialog.dart';

import '../adversaries/prime.dart';
import '../enemies/enemies.dart';

enum WinLoseState {
  stillPlaying,
  gameOver,
  levelComplete,
}

late WinLoseState state;

class WinLoseConditions extends Component {
  final Prime prime;
  final Enemies enemies;

  WinLoseConditions(this.prime, this.enemies) {
    priority = 10000;
  }

  @override
  onLoad() {
    state = WinLoseState.stillPlaying;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (state != WinLoseState.stillPlaying) {
      return;
    } else if (prime.remainingDamage == 0) {
      state = WinLoseState.gameOver;
      Future.delayed(const Duration(seconds: 1)).then((_) {
        soundboard.play(Sound.game_over);
        soundboard.play(Sound.ligma_balls);
      });
    } else if (enemies.allDefeated) {
      state = WinLoseState.levelComplete;
      world.score += (prime.remainingDamage.toInt() * 100);
      Future.delayed(const Duration(seconds: 1)).then((_) {
        soundboard.play(Sound.score);
        soundboard.play(Sound.deez_nutz);
      });
    }
    switch (state) {
      case WinLoseState.stillPlaying:
        break;
      case WinLoseState.gameOver:
        add(GameOverDialog());
      case WinLoseState.levelComplete:
        add(LevelCompleteDialog());
    }
  }
}
