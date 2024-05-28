import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../components/ligma_world.dart';
import '../components/smoke.dart';
import '../components/soundboard.dart';
import '../util/random.dart';

mixin Life {
  late CircleComponent _life;
  late Sound _deathSound;
  late double maxDamage;

  double _damage = 0;

  double get remainingDamage => maxDamage - _damage;

  bool get stillAlive => remainingDamage > 0;

  addLifeIndicatorTo(
    PositionComponent parent, {
    Sound deathSound = Sound.death,
    required double maxDamage,
  }) {
    _deathSound = deathSound;
    parent.add(_life = CircleComponent(
      radius: 0,
      position: parent.size / 2,
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0x80FF0000),
    ));
    this.maxDamage = maxDamage;
  }

  onHit(PositionComponent it, {double damage = 1}) {
    soundboard.play(Sound.vim);
    if (_damage >= maxDamage) return;

    _damage += damage;
    if (_damage > maxDamage) _damage = maxDamage;
    _life.radius = it.size.x / 2 / maxDamage * _damage;
    if (_damage < maxDamage) return;
    world.score += (maxDamage * 5).toInt();
    it.add(RemoveEffect(delay: 0.25));
    soundboard.play(_deathSound);
    for (var i = 0; i < 10; i++) {
      smokeAt(it.position + randomNormalizedVector() * it.size.x / 2);
    }
  }
}
