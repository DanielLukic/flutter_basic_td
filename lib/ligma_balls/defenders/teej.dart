import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/auto_target_shooter.dart';
import '../components/common.dart';
import '../components/life.dart';
import '../components/projectiles.dart';
import '../components/pulsing.dart';
import '../components/taking_hits.dart';
import 'free_placement.dart';

class Teej extends SpriteComponent
    with CollisionCallbacks, Defender, FreePlacementOnRemove, Life, TakingHits {
  //
  Teej({required super.position, super.anchor = Anchor.center});

  static const double targetRadius = 64;

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('teej.png');

    final projectile = await makeProjectilePrototype(
      ProjectileKind.speech,
      isAttacker,
      100,
    );

    add(AutoTargetShooter(
      radius: targetRadius,
      projectile: projectile,
      reloadTime: 3,
    ));
    add(CircleHitbox(radius: size.x / 2));

    addLifeIndicatorTo(this, maxDamage: 5);
    initTakingHits(this);
  }
}
