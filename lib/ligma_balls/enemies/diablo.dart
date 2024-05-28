import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/common.dart';
import '../damage/life.dart';
import '../damage/taking_hits.dart';
import 'waypoints.dart';

class Diablo extends SpriteComponent
    with Attacker, CollisionCallbacks, Life, TakingHits {
  //
  Diablo({
    required super.position,
    required super.sprite,
    super.anchor = Anchor.center,
  });

  @override
  onLoad() async {
    add(CircleHitbox(collisionType: CollisionType.active));
    add(FollowWaypoints());
    addLifeIndicatorTo(this, maxDamage: 20);
    initTakingHits(this);
  }
}
