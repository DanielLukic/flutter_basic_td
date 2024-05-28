import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../components/common.dart';
import '../components/smoke.dart';
import '../damage/projectile.dart';

class Thor extends SpriteComponent with CollisionCallbacks {
  //
  final TiledObject object;

  Thor(this.object) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('thor.png');
    position = Vector2(object.x + 8, object.y - 8);
    priority = 500;
    add(CircleHitbox(collisionType: CollisionType.active));
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Projectile) {
      other.active = false;
      other.add(RemoveEffect(delay: 0.25));
      smokeAround(other.position, Vector2.all(16));
    }
  }
}
