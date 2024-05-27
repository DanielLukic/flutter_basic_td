import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:ligma_balls/ligma_balls/components/ligma_world.dart';

import 'common.dart';
import 'smoke.dart';

mixin Life {
  late CircleComponent _life;

  double _damage = 0;

  late double maxDamage;

  double get remainingDamage => maxDamage - _damage;

  addLifeIndicatorTo(PositionComponent parent, {required double maxDamage}) {
    parent.add(_life = CircleComponent(
      radius: 0,
      position: parent.size / 2,
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0x80FF0000),
    ));
    this.maxDamage = maxDamage;
  }

  onHit(PositionComponent it, {double damage = 1}) {
    _damage += damage;
    if (_damage > maxDamage) _damage = maxDamage;
    _life.radius = it.size.x / 2 / maxDamage * _damage;
    if (_damage < maxDamage) return;
    world.score += (maxDamage * 5).toInt();
    it.add(RemoveEffect(delay: 0.25));
    for (var i = 0; i < 10; i++) {
      smokeAt(it.position + randomNormalizedVector() * it.size.x / 2);
    }
  }
}
