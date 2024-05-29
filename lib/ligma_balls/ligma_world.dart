import 'package:ligma_balls/ligma_balls/finish/finish_screen.dart';

import 'components/common.dart';
import 'components/ligma_world.dart';
import 'level/game_level.dart';
import 'title/title_screen.dart';

class ActualLigmaWorld extends LigmaWorld {
  GameLevel? level;

  int levelId = dev ? 4 : 1;

  @override
  void showTitle() {
    _removeLevel();
    _resetScore();
    _removeTitle();
    add(TitleScreen());
  }

  void _resetScore() {
    score = 0;
    startScore = 0;
  }

  void _removeTitle() {
    children.whereType<TitleScreen>().forEach((it) => it.removeFromParent);
  }

  @override
  void prevLevel() {
    _resetScore();
    if (levelId > 1) levelId--;
    world.loadLevel();
  }

  @override
  void nextLevel() {
    startScore = score;
    game.assets.readBinaryFile('tiles/level${levelId + 1}.tmx').then((_) {
      levelId++;
      world.loadLevel();
    }, onError: (_) {
      showFinish();
    });
  }

  @override
  void loadLevel() {
    score = startScore;
    _removeTitle();
    _removeLevel();
    add(level = GameLevel(levelId));
  }

  void _removeLevel() {
    if (level != null) remove(level!);
    level = null;
  }

  @override
  void showFinish() {
    _removeLevel();
    _removeTitle();
    add(FinishScreen());
  }
}
