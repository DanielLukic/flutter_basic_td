import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ligma_balls/ligma_balls/components/projectile.dart';

import '../components/auto_target_shooter.dart';
import '../components/common.dart';
import '../components/life.dart';
import '../components/projectiles.dart';
import '../components/soundboard.dart';
import '../components/taking_hits.dart';
import 'free_placement.dart';

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

    addLifeIndicatorTo(this, maxDamage: 10, deathSound: Sound.explosion);
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
