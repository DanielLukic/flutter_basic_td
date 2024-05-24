import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../components/auto_target_shooter.dart';
import '../components/common.dart';
import '../components/life.dart';
import '../components/projectile.dart';
import '../components/projectiles.dart';
import '../components/smoke.dart';

class Twitch extends SpriteComponent with CollisionCallbacks, Defender, Life {
  Twitch({required super.position, super.anchor = Anchor.center});

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('twitch.png');

    add(AutoTargetShooter(
      radius: 64,
      fire: _fire,
      isTarget: isAttacker,
    ));
    add(CircleHitbox(radius: size.x / 2));
    addLifeIndicatorTo(this);

    _bullet = await makeProjectilePrototype(
      ProjectileKind.twitchChat,
      isAttacker,
    );
  }

  late Projectile _bullet;

  void _fire(PositionComponent origin, PositionComponent target) {
    fireProjectile(_bullet, origin, target, 100);
  }

  double _pulseTime = 0;

  @override
  void update(double dt) {
    final pulse = 1 + sin(_pulseTime * pi * 2) * 0.1;
    scale.x = pulse;
    scale.y = pulse;
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
