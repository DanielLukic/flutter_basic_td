import 'package:flame/components.dart';

import 'game_level.dart';

final world = LigmaWorld();

class LigmaWorld extends World {
  GameLevel? level;

  void loadLevel(int id) {
    if (level != null) remove(level!);
    add(level = GameLevel(id));
  }
}
