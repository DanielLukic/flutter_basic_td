import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:ligma_balls/ligma_balls/adversaries/prime.dart';
import 'package:ligma_balls/ligma_balls/components/common.dart';
import 'package:ligma_balls/ligma_balls/components/smoke.dart';
import 'package:ligma_balls/ligma_balls/enemies/projectile.dart';

import '../components/life.dart';
import 'auto_target_shooter.dart';
import 'waypoints.dart';

class Goblin extends SpriteComponent with Attacker, CollisionCallbacks, Life {
  Goblin({
    required super.position,
    required super.sprite,
    super.anchor = Anchor.center,
  });

  @override
  onLoad() async {
    _projectileAnim = await twitchChat();
    add(AutoTargetShooter(
      fire: _fire,
      isTarget: (it) => it is Prime || it is Defender,
    ));
    add(CircleHitbox(collisionType: CollisionType.active));
    addLifeIndicatorTo(this);
    maxHits = 1;
  }

  late SpriteAnimation _projectileAnim;

  void _fire(PositionComponent origin, PositionComponent target) {
    fireProjectile(_projectileAnim, origin, target, 40, _isTarget);
  }

  bool _isTarget(PositionComponent it) => it is Prime || it is Defender;

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
