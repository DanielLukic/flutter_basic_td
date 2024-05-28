import 'package:flame/components.dart';

import '../level/game_level.dart';
import 'common.dart';

final world = LigmaWorld();

class LigmaWorld extends World {
  GameLevel? level;

  int levelId = dev ? 3 : 1;

  int score = 0;

  void prevLevel() {
    if (levelId > 1) levelId--;
    world.loadLevel();
  }

  void nextLevel() {
    game.assets.readBinaryFile('tiles/level${levelId + 1}.tmx').then((_) {
      levelId++;
      world.loadLevel();
    }, onError: (_) {
      world.loadLevel();
    });
  }

  void loadLevel() {
    if (level != null) remove(level!);
    add(level = GameLevel(levelId));
  }
}
