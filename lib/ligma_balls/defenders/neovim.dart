import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:ligma_balls/ligma_balls/components/smoke.dart';

import '../components/common.dart';
import '../components/life.dart';
import '../enemies/projectile.dart';

class NeoVim extends SpriteComponent with CollisionCallbacks, Defender, Life {
  NeoVim({required super.position, super.anchor = Anchor.center});

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('neovim.png');
    add(CircleHitbox(radius: size.x / 2));
    addLifeIndicatorTo(this);
  }

  double _pulseTime = 0;

  @override
  void update(double dt) {
    final pulse = 1 + sin(_pulseTime * pi * 2) * 0.1;
    scale.x = pulse;
    scale.y = pulse;

    angle = _pulseTime * pi;

    _pulseTime += dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is! Projectile) return;
    final off = randomNormalizedVector() * other.size.x / 2;
    smokeAt(position + off);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is! Projectile) return;
    other.add(RemoveEffect(delay: 0.1));
    onHit(this);
  }
}
