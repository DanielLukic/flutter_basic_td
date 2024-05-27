import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../adversaries/prime.dart';
import '../components/auto_target_shooter.dart';
import '../components/common.dart';
import '../components/life.dart';
import '../components/projectiles.dart';
import '../components/taking_hits.dart';
import 'can_be_slowed_down.dart';
import 'waypoints.dart';

class Goblin extends SpriteComponent
    with
        HasTimeScale,
        Attacker,
        CanBeSlowedDown,
        CollisionCallbacks,
        Life,
        TakingHits {
  //
  Goblin({
    required super.position,
    required super.sprite,
    super.anchor = Anchor.center,
  });

  @override
  onLoad() async {
    final projectile = await makeProjectilePrototype(
      ProjectileKind.twitchChat,
      isDefender,
      40,
    );

    add(AutoTargetShooter(projectile: projectile));
    add(CircleHitbox(collisionType: CollisionType.active));
    add(FollowWaypoints());

    addLifeIndicatorTo(this, maxDamage: 1);
    initTakingHits(this);
  }
}
