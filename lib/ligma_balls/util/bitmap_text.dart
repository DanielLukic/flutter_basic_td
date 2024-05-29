import 'dart:ui';

import 'package:flame/components.dart';

import 'bitmap_font.dart';
import 'fonts.dart';

class BitmapText extends PositionComponent {
  final String text;
  final BitmapFont font;
  final double fontScale;
  final Color? tint;

  BitmapText({
    required this.text,
    required Vector2 position,
    BitmapFont? font,
    double scale = 1,
    this.tint,
    Anchor anchor = Anchor.topLeft,
  })  : font = font ?? textFont,
        fontScale = scale {
    this.position = position;
    this.font.scale = fontScale;
    final w = this.font.lineWidth(text);
    final h = this.font.lineHeight();
    final x = anchor.x * w;
    final y = anchor.y * h;
    this.position.x -= x;
    this.position.y -= y;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    font.scale = fontScale;
    if (tint != null) font.tint(tint!);
    font.drawString(canvas, 0, 0, text);
  }
}
