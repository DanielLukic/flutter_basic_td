import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/common.dart';
import '../damage/life.dart';
import '../damage/taking_hits.dart';
import 'convert_on_sub.dart';
import 'waypoints.dart';

class Diablo extends SpriteComponent
    with Attacker, CollisionCallbacks, Life, TakingHits, ConvertOnSub {
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
    addLifeIndicatorTo(this, maxDamage: 25);
    initTakingHits(this);
    initConvertOnSub();
  }
}
