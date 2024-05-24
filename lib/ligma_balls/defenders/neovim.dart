import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:ligma_balls/ligma_balls/components/smoke.dart';
import 'package:ligma_balls/ligma_balls/enemies/auto_target_shooter.dart';

import '../components/common.dart';
import '../components/life.dart';
import '../enemies/projectile.dart';

class NeoVim extends SpriteComponent with CollisionCallbacks, Defender, Life {
  NeoVim({required super.position, super.anchor = Anchor.center});

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('neovim.png');
    _bullet = await vim();
    add(AutoTargetShooter(
      radius: 128,
      fire: _fire,
      isTarget: (it) => it is Attacker,
    ));
    add(CircleHitbox(radius: size.x / 2));
    addLifeIndicatorTo(this);
  }

  late SpriteAnimation _bullet;

  void _fire(PositionComponent origin, PositionComponent target) {
    fireProjectile(_bullet, origin, target, 100, (it) => it is Attacker);
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
    if (other is Projectile && other.isTarget(this)) {
      final off = randomNormalizedVector() * other.size.x / 2;
      smokeAt(position + off);
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Projectile && other.isTarget(this)) {
      other.add(RemoveEffect(delay: 0.1));
      onHit(this);
    }
  }
}
