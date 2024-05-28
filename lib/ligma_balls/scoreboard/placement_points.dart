import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' hide Image;

import '../level/game_level.dart';
import '../util/bitmap_font.dart';
import '../util/fonts.dart';

class PlacementPoints extends Component {
  final double minStep = 5;

  double displayPoints = 0;

  @override
  void update(double dt) {
    super.update(dt);
    if (level.remainingPoints == displayPoints) return;

    var delta = (level.remainingPoints - displayPoints) * dt;
    if (delta.abs() < minStep) {
      displayPoints = level.remainingPoints;
    } else {
      displayPoints += delta;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    menuFont.scale = 0.25;
    menuFont.tint(textColor);
    menuFont.drawText(canvas, 120, 15, 'Defender\nBudget:');

    menuFont.scale = 0.5;
    menuFont.tint(textColor);
    menuFont.drawText(canvas, 120, 31, '\$${displayPoints.toInt()}');
  }
}
