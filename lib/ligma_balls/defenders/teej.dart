import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ligma_balls/ligma_balls/components/pulsing.dart';

import '../components/auto_target_shooter.dart';
import '../components/common.dart';
import '../components/life.dart';
import '../components/projectiles.dart';
import '../components/taking_hits.dart';

class Teej extends SpriteComponent
    with CollisionCallbacks, Defender, Life, TakingHits {
  //
  Teej({required super.position, super.anchor = Anchor.center});

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('teej.png');

    final projectile = await makeProjectilePrototype(
      ProjectileKind.speech,
      isAttacker,
      100,
    );

    add(AutoTargetShooter(radius: 64, projectile: projectile, reloadTime: 3));
    add(CircleHitbox(radius: size.x / 2));
    add(Pulsing());

    addLifeIndicatorTo(this, maxHits: 5);
    initTakingHits(this);
  }
}
