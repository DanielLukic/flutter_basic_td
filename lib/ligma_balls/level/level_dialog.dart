import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';

import '../components/common.dart';
import '../util/extensions.dart';
import '../util/fonts.dart';
import '../util/nine_patch_image.dart';
import 'game_level.dart';

class LevelDialog extends Component
    with KeyboardHandler, DragCallbacks, TapCallbacks {
  //
  final String title;
  final TiledComponent map;
  final Function(LevelDialog)? ok;
  late final String description;

  LevelDialog(this.title, this.map, {this.ok}) {
    description = map.stringProperty('Description');
    priority = 10000;
    if (dev) add(RemoveEffect(delay: 2, onComplete: _dismiss));
  }

  late NinePatchImage background;
  final int cornerSize = 8;

  late Iterable<TiledObject> attackers;
  late Iterable<TiledObject> defenders;

  @override
  onLoad() async {
    background = NinePatchImage(await images.load('textbox.png'));

    textFont.paint.colorFilter = const ColorFilter.mode(
      Color(0xFFffcc80),
      BlendMode.srcATop,
    );
    textFont.scale = 0.5;

    attackers = level.attackers;
    defenders = level.defenders;
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onTapUp(TapUpEvent event) => _dismiss();

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyRepeatEvent) return true;
    if (event is KeyUpEvent && event.logicalKey.keyLabel == ' ') _dismiss();
    return super.onKeyEvent(event, keysPressed);
  }

  void _dismiss() {
    final callback = ok ?? (it) => parent?.remove(this);
    callback(this);
  }

  @override
  void render(Canvas canvas) {
    double height = 120 + attackers.length * 24 + defenders.length * 24;
    height = (height + 15) ~/ 16 * 16;

    background.draw(canvas, 32, 32, 256, height);

    textFont.drawString(canvas, 140, 40, title);
    textFont.drawText(canvas, 40, 56, description);

    double y = 120;

    textFont.drawString(canvas, 40, 110, 'Attackers:');
    for (final it in attackers) {
      final idx = entityTileIndex[it.name]!;
      final sprite = map.tileSprite(idx);
      sprite.render(canvas, position: Vector2(40, y));
      final info = entityInfo[it.name]!;
      textFont.drawText(canvas, 64, y + 2, info);
      y += 24;
    }

    textFont.drawString(canvas, 40, y, 'Defenders:');
    y += 10;
    for (final it in defenders) {
      final idx = entityTileIndex[it.name]!;
      final sprite = map.tileSprite(idx);
      sprite.render(canvas, position: Vector2(40, y));
      final info = entityInfo[it.name]!;
      textFont.drawText(canvas, 64, y + 1, info);
      y += 24;
    }

    textFont.drawText(
      canvas,
      80,
      40 + height - 24,
      'Defend Prime\'s Moustache (TM)!',
    );
  }
}
