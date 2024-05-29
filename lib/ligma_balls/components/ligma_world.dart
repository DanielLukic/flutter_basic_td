import 'package:flame/components.dart';

late final LigmaWorld world;

abstract class LigmaWorld extends World {
  int score = 0;
  int startScore = 0;

  void showTitle();

  void prevLevel();

  void nextLevel();

  void loadLevel();

  void showFinish();
}
