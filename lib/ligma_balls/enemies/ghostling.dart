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

class Ghostling extends SpriteComponent
    with
        HasTimeScale,
        Attacker,
        CanBeSlowedDown,
        CollisionCallbacks,
        Life,
        TakingHits {
  //
  Ghostling({
    required super.position,
    required super.sprite,
    super.anchor = Anchor.center,
  });

  @override
  onLoad() async {
    final projectile = await makeProjectilePrototype(
      ProjectileKind.ligmaBalls,
      isDefender,
      40,
    );

    add(AutoTargetShooter(projectile: projectile));
    add(CircleHitbox(collisionType: CollisionType.active));
    add(FollowWaypoints());

    addLifeIndicatorTo(this, maxDamage: 2);
    initTakingHits(this, whereKind: (it) => it != ProjectileKind.vim);
  }
}
