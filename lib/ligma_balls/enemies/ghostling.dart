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

class Ghostling extends SpriteComponent
    with Attacker, CollisionCallbacks, Life {
  //
  Ghostling({
    required super.position,
    required super.sprite,
    super.anchor = Anchor.center,
  });

  @override
  onLoad() async {
    add(AutoTargetShooter(
      fire: _fire,
      isTarget: (it) => it is Prime || it is Defender,
    ));
    add(CircleHitbox(collisionType: CollisionType.active));
    addLifeIndicatorTo(this);
    maxHits = 2;

    _bullet = await makeProjectilePrototype(
      ProjectileKind.ligmaBalls,
      (it) => it is Prime || it is Defender,
    );
  }

  late Projectile _bullet;

  void _fire(PositionComponent origin, PositionComponent target) {
    fireProjectile(_bullet, origin, target, 80, _isTarget);
  }

  bool _isTarget(PositionComponent it) => it is Prime || it is Defender;

  double _waytime = 0;

  @override
  void update(double dt) {
    waypoints.setPositionAt(_waytime, 25, position);
    _waytime += dt;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Projectile && other.isTarget(this)) {
      other.active = false;
      other.add(RemoveEffect(delay: 0.25));
      smokeAround(other.position, Vector2.all(16));
      if (other.kind != ProjectileKind.vim) onHit(this);
    }
  }
}
