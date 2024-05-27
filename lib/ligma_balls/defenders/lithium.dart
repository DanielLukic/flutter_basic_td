import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/auto_target_shooter.dart';
import '../components/common.dart';
import '../components/life.dart';
import '../components/projectiles.dart';
import '../components/soundboard.dart';
import '../components/taking_hits.dart';
import 'free_placement.dart';

class Lithium extends SpriteComponent
    with CollisionCallbacks, FreePlacementOnRemove, Defender, Life, TakingHits {
  //
  Lithium({required super.position, super.anchor = Anchor.center});

  static const double targetRadius = 80;

  @override
  onLoad() async {
    sprite = await game.loadSprite('lithium.png');

    final projectile = await makeProjectilePrototype(
      ProjectileKind.sub,
      isAttacker,
      200,
    );

    add(
      AutoTargetShooter(radius: targetRadius, projectile: projectile)
        ..anchor = Anchor.center,
    );
    add(CircleHitbox(radius: size.x / 2));

    addLifeIndicatorTo(this, maxDamage: 10, deathSound: Sound.explosion);
    initTakingHits(this);
  }
}
