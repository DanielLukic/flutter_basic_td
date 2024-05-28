import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' hide Image;

import '../components/soundboard.dart';

class VolumeIndicator extends PositionComponent
    with DragCallbacks, TapCallbacks {
  //
  final Image image;
  final double steps;

  VolumeIndicator(
    this.image, {
    this.steps = 10,
    required Vector2 position,
  }) {
    this.position = position;
    size = Vector2(
      image.width.toDouble() + 4,
      image.height.toDouble() + 4,
    );
  }

  final backPaint = Paint()
    ..colorFilter =
        const ColorFilter.mode(Color(0x80000000), BlendMode.srcATop);

  final paint = Paint();

  late final Rect rect = Rect.fromLTWH(0, 0, width, height);
  late final RRect rrect = RRect.fromRectAndRadius(
    rect,
    const Radius.circular(4),
  );

  @override
  render(Canvas canvas) {
    canvas.drawRRect(rrect, backPaint);

    final width = image.width * soundboard.masterVolume;
    final h = image.height.toDouble();
    final src = Rect.fromLTWH(2, 2, width, h);
    canvas.drawImageRect(image, src, src, paint);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    final rel = (event.localPosition.x / width).clamp(0, width).toDouble();
    soundboard.masterVolume = rel;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    final rel = (event.localEndPosition.x / width).clamp(0, width).toDouble();
    soundboard.masterVolume = rel;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    final rel = (event.localPosition.x / width).clamp(0, width).toDouble();
    soundboard.masterVolume = rel;
  }
}
