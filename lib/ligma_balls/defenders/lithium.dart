import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/common.dart';
import '../components/soundboard.dart';
import '../damage/auto_target_shooter.dart';
import '../damage/life.dart';
import '../damage/projectiles.dart';
import '../damage/taking_hits.dart';
import 'placement.dart';

class Lithium extends SpriteComponent
    with CollisionCallbacks, FreePlacementOnRemove, Defender, Life, TakingHits {
  //
  Lithium({required super.position, super.anchor = Anchor.center});

  static const double targetRadius = 32;

  @override
  onLoad() async {
    sprite = await game.loadSprite('lithium.png');

    final projectile = await makeProjectilePrototype(
      ProjectileKind.sub,
      isAttacker,
      100,
    );

    final shooter = AutoTargetShooter(
      radius: targetRadius,
      projectile: projectile,
      reloadTime: 3,
    );
    shooter.anchor = Anchor.center;

    add(shooter);
    add(CircleHitbox(radius: size.x / 2));

    addLifeIndicatorTo(this, maxDamage: 10, deathSound: Sound.explosion);
    initTakingHits(this);
  }
}
