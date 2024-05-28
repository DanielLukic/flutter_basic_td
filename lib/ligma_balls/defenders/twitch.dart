import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/common.dart';
import '../components/soundboard.dart';
import '../damage/auto_target_shooter.dart';
import '../damage/life.dart';
import '../damage/projectiles.dart';
import '../damage/taking_hits.dart';
import 'placement.dart';

class Twitch extends SpriteComponent
    with CollisionCallbacks, Defender, FreePlacementOnRemove, Life, TakingHits {
  //
  Twitch({required super.position, super.anchor = Anchor.center});

  static const double targetRadius = 64;

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('twitch.png');

    final projectile = await makeProjectilePrototype(
      ProjectileKind.twitchChat,
      isAttacker,
      60,
    );

    add(AutoTargetShooter(
      radius: targetRadius,
      projectile: projectile,
      reloadTime: 2,
    ));
    add(CircleHitbox(radius: size.x / 2));

    addLifeIndicatorTo(this, maxDamage: 5, deathSound: Sound.explosion);
    initTakingHits(this);
  }
}
