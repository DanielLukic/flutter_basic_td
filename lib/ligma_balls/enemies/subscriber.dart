import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/common.dart';
import '../damage/can_be_slowed_down.dart';
import '../damage/life.dart';
import '../damage/taking_hits.dart';
import 'waypoints.dart';

class Subscriber extends SpriteComponent
    with
        HasTimeScale,
        Attacker,
        CanBeSlowedDown,
        CollisionCallbacks,
        Life,
        TakingHits {
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
    addLifeIndicatorTo(this, maxDamage: 10);
    initTakingHits(this);
  }
}
