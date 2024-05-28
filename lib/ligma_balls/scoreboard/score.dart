import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import '../components/ligma_world.dart';
import '../util/bitmap_font.dart';
import '../util/fonts.dart';

class Score extends PositionComponent {
  final double minStep = 5;

  Score({required Vector2 position}) {
    this.position = position;
  }

  double displayValue = 0;

  @override
  void update(double dt) {
    super.update(dt);
    if (world.score == displayValue) return;
    var delta = (world.score - displayValue) * dt;
    if (delta.abs() < minStep) delta = delta < 0 ? -minStep : minStep;
    displayValue += delta;
    if ((world.score - displayValue).abs() < minStep) {
      displayValue = world.score.toDouble();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    menuFont.scale = 0.25;
    menuFont.tint(textColor);
    menuFont.drawText(canvas, 0, 0, 'Prime\nScore:');

    menuFont.scale = 0.5;
    menuFont.tint(textColor);
    menuFont.drawText(canvas, 0, 16, '${displayValue.toInt()}');
  }
}
