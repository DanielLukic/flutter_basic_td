import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ligma_balls/ligma_balls/adversaries/prime.dart';
import 'package:ligma_balls/ligma_balls/components/common.dart';
import 'package:ligma_balls/ligma_balls/enemies/projectile.dart';

import 'auto_target_shooter.dart';
import 'waypoints.dart';

class Goblin extends SpriteComponent with Attacker {
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
    add(CircleHitbox(collisionType: CollisionType.passive));
  }

  late SpriteAnimation _projectileAnim;

  void _fire(PositionComponent origin, PositionComponent target) {
    fireProjectile(_projectileAnim, origin, target, 40);
  }

  double _waytime = 0;

  @override
  void update(double dt) {
    waypoints.setPositionAt(_waytime, 35, position);
    _waytime += dt;
  }
}
