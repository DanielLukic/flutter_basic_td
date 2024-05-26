import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/common.dart';
import '../components/life.dart';
import 'taking_hits.dart';
import 'waypoints.dart';

class Subscriber extends SpriteComponent
    with Attacker, CollisionCallbacks, Life, TakingHits {
  //
  Subscriber({
    required super.position,
    required super.sprite,
    super.anchor = Anchor.center,
  });

  @override
  onLoad() async {
    add(CircleHitbox(collisionType: CollisionType.active));
    add(FollowWaypoints());
    addLifeIndicatorTo(this, maxHits: 10);
    initTakingHits(this);
  }
}
