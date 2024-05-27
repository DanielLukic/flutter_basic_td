import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:ligma_balls/ligma_balls/components/ligma_world.dart';

import 'common.dart';
import 'smoke.dart';

mixin Life {
  late CircleComponent _life;

  int _hits = 0;

  late int maxHits;

  int get remainingHits => maxHits - _hits;

  addLifeIndicatorTo(PositionComponent parent, {required int maxHits}) {
    parent.add(_life = CircleComponent(
      radius: 0,
      position: parent.size / 2,
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0x80FF0000),
    ));
    this.maxHits = maxHits;
  }

  onHit(PositionComponent it, {int count = 1}) {
    _hits += count;
    if (_hits > maxHits) _hits = maxHits;
    _life.radius = it.size.x / 2 / maxHits * _hits;
    if (_hits < maxHits) return;
    world.score += maxHits * 5;
    it.add(RemoveEffect(delay: 0.25));
    for (var i = 0; i < 10; i++) {
      smokeAt(it.position + randomNormalizedVector() * it.size.x / 2);
    }
  }
}
