import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';

import '../util/nine_patch_image.dart';
import 'common.dart';

class Dialog extends PositionComponent
    with KeyboardHandler, DragCallbacks, TapCallbacks {
  //
  final NinePatchImage background;
  final int cornerSize;

  Dialog(
    Image bgNinePatchImage, {
    required double width,
    required double height,
    this.cornerSize = 8,
  }) : background = NinePatchImage(bgNinePatchImage) {
    size = Vector2(width, height);
    position = Vector2((gameWidth - width) / 2, (gameHeight - height) / 2);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) => true;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final w = width ~/ cornerSize * cornerSize.toDouble();
    final h = height ~/ cornerSize * cornerSize.toDouble();
    background.draw(canvas, 0, 0, w, h);
  }
}
