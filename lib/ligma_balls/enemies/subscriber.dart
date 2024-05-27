import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/common.dart';
import '../components/life.dart';
import '../components/taking_hits.dart';
import 'can_be_slowed_down.dart';
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
