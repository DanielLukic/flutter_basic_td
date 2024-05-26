import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../adversaries/prime.dart';
import '../components/auto_target_shooter.dart';
import '../components/common.dart';
import '../components/life.dart';
import '../components/projectile.dart';
import '../components/projectiles.dart';
import '../components/smoke.dart';
import 'waypoints.dart';

class Goblin extends SpriteComponent with Attacker, CollisionCallbacks, Life {
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

    addLifeIndicatorTo(this, maxHits: 1);
  }

  double _waytime = 0;

  @override
  void update(double dt) {
    waypoints.setPositionAt(_waytime, 35, position);
    _waytime += dt;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Projectile && other.isTarget(this)) {
      onHit(this);
      other.active = false;
      other.add(RemoveEffect(delay: 0.25));
      smokeAround(other.position, Vector2.all(16));
    }
  }
}
