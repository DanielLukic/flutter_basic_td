import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';

import '../components/common.dart';
import '../components/ligma_world.dart';
import '../level/game_level.dart';
import '../util/bitmap_font.dart';
import '../util/fonts.dart';

class LevelInfo extends PositionComponent with TapCallbacks {
  LevelInfo(Vector2 position) {
    this.position = position;
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    final x = point.x;
    final y = point.y;
    if (x < 0 || y < 0 || x > 80 || y > 16) return false;
    return true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    if (!dev) return;
    if (event.localPosition.x > 40) {
      world.nextLevel();
    } else {
      world.prevLevel();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    menuFont.scale = 0.5;
    menuFont.tint(textColor);
    menuFont.drawText(canvas, 0, 0, 'Level ${level.id}');
  }
}
