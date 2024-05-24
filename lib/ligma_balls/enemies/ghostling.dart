import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ligma_balls/ligma_balls/enemies/projectile.dart';

import '../adversaries/prime.dart';
import '../components/common.dart';
import 'auto_target_shooter.dart';
import 'waypoints.dart';

class Ghostling extends SpriteComponent with Attacker {
  Ghostling({
    required super.position,
    required super.sprite,
    super.anchor = Anchor.center,
  });

  @override
  onLoad() async {
    add(AutoTargetShooter(
      projectile: await ligmaBalls(),
      isTarget: (it) => it is Prime || it is Defender,
    ));
    add(CircleHitbox(collisionType: CollisionType.passive));
  }

  double _waytime = 0;

  @override
  void update(double dt) {
    waypoints.setPositionAt(_waytime, 25, position);
    _waytime += dt;
  }
}
