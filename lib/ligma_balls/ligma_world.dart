import 'components/common.dart';
import 'components/ligma_world.dart';
import 'level/game_level.dart';
import 'title/title.dart';

class ActualLigmaWorld extends LigmaWorld {
  GameLevel? level;

  int levelId = dev ? 3 : 1;

  @override
  void showTitle() {
    _removeTitle();
    add(TitleScreen());
  }

  void _removeTitle() {
    children.whereType<TitleScreen>().forEach((it) => it.removeFromParent);
  }

  @override
  void prevLevel() {
    if (levelId > 1) levelId--;
    world.loadLevel();
  }

  @override
  void nextLevel() {
    game.assets.readBinaryFile('tiles/level${levelId + 1}.tmx').then((_) {
      levelId++;
      world.loadLevel();
    }, onError: (_) {
      world.loadLevel();
    });
  }

  @override
  void loadLevel() {
    _removeTitle();
    if (level != null) remove(level!);
    add(level = GameLevel(levelId));
  }
}
