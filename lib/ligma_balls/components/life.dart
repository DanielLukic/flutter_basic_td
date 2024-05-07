import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'common.dart';
import 'smoke.dart';

mixin Life {
  late CircleComponent _life;

  int _hits = 0;

  int maxHits = 5;

  addLifeIndicatorTo(PositionComponent parent) {
    parent.add(_life = CircleComponent(
      radius: 0,
      position: parent.size / 2,
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0x80FF0000),
    ));
  }

  onHit(PositionComponent it) {
    _hits++;
    if (_hits > maxHits) _hits = maxHits;
    _life.radius = it.size.x / 2 / maxHits * _hits;
    if (_hits < maxHits) return;
    it.add(RemoveEffect(delay: 0.25));
    for (var i = 0; i < 10; i++) {
      smokeAt(it.position + randomNormalizedVector() * it.size.x / 2);
    }
  }
}
