import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ligma_balls/ligma_balls/enemies/projectile.dart';

import 'auto_target_shooter.dart';
import 'waypoints.dart';

class Ghostling extends SpriteComponent {
  Ghostling({
    required super.position,
    required super.sprite,
    super.anchor = Anchor.center,
  });

  @override
  onLoad() async {
    add(AutoTargetShooter(await ligmaBalls()));
    add(CircleHitbox(collisionType: CollisionType.passive));
  }

  double _waytime = 0;

  @override
  void update(double dt) {
    waypoints.setPositionAt(_waytime, 25, position);
    _waytime += dt;
  }
}
