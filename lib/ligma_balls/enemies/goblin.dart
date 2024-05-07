import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ligma_balls/ligma_balls/enemies/projectile.dart';

import 'auto_target_shooter.dart';
import 'waypoints.dart';

class Goblin extends SpriteComponent {
  Goblin({
    required super.position,
    required super.sprite,
    super.anchor = Anchor.center,
  });

  @override
  onLoad() async {
    add(AutoTargetShooter(await twitchChat()));
    add(CircleHitbox(collisionType: CollisionType.passive));
  }

  double _waytime = 0;

  @override
  void update(double dt) {
    waypoints.setPositionAt(_waytime, 35, position);
    _waytime += dt;
  }
}
