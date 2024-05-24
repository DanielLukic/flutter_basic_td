import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:ligma_balls/ligma_balls/enemies/projectile.dart';

import '../adversaries/prime.dart';
import '../components/common.dart';
import '../components/smoke.dart';
import 'auto_target_shooter.dart';
import 'waypoints.dart';

class Ghostling extends SpriteComponent with Attacker, CollisionCallbacks {
  Ghostling({
    required super.position,
    required super.sprite,
    super.anchor = Anchor.center,
  });

  @override
  onLoad() async {
    _projectileAnim = await ligmaBalls();
    add(AutoTargetShooter(
      fire: _fire,
      isTarget: (it) => it is Prime || it is Defender,
    ));
    add(CircleHitbox(collisionType: CollisionType.active));
  }

  late SpriteAnimation _projectileAnim;

  void _fire(PositionComponent origin, PositionComponent target) {
    fireProjectile(_projectileAnim, origin, target, 80, _isTarget);
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
    }
  }
}
