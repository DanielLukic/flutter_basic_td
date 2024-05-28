import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/common.dart';
import '../components/soundboard.dart';
import '../damage/auto_target_shooter.dart';
import '../damage/life.dart';
import '../damage/projectile.dart';
import '../damage/projectiles.dart';
import '../damage/taking_hits.dart';
import 'placement.dart';

class Dipshit extends SpriteComponent
    with CollisionCallbacks, FreePlacementOnRemove, Defender, Life, TakingHits {
  //
  Dipshit({required super.position, super.anchor = Anchor.center});

  static const double targetRadius = 48;

  @override
  onLoad() async {
    sprite = await game.loadSprite('dipshit.png');

    final projectile = await makeProjectilePrototype(
      ProjectileKind.poop,
      isAttacker,
      80,
    );
    projectile.lifetime = 1;

    add(
      AutoTargetShooter(
        radius: targetRadius,
        projectile: projectile,
        reloadTime: 0.1,
      )
        ..modify = modify
        ..anchor = Anchor.center,
    );
    add(CircleHitbox(radius: size.x / 2));

    addLifeIndicatorTo(this, maxDamage: 3, deathSound: Sound.explosion);
    initTakingHits(this);
  }

  @override
  update(double dt) => _poopAngle += dt * pi;

  double _poopAngle = 0;

  Vector2 overrideDirection = Vector2.zero();

  void modify(Projectile it) {
    overrideDirection.x = sin(_poopAngle);
    overrideDirection.y = cos(_poopAngle);
    it.direction.setFrom(overrideDirection);
  }
}
