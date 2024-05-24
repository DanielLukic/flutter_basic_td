import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../components/auto_target_shooter.dart';
import '../components/common.dart';
import '../components/life.dart';
import '../components/projectile.dart';
import '../components/smoke.dart';

class Prime extends SpriteComponent with CollisionCallbacks, Life {
  //
  final TiledObject object;

  Prime(this.object) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('prime.png');
    position = Vector2(object.x + 8, object.y - 8);
    priority = 50;
    add(CircleHitbox(isSolid: true, collisionType: CollisionType.active));
    addLifeIndicatorTo(this);
    maxHits = 10;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is AutoTargetShooter) return;
    onHit(this);
    if (other is Projectile) {
      other.add(RemoveEffect(delay: 0.1));
    } else {
      other.add(RemoveEffect(delay: 1));
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is AutoTargetShooter) return;
    if (random.nextBool()) {
      final dist = position.distanceTo(other.position);
      final dx = random.nextDouble() * dist / 2;
      final dy = random.nextDouble() * dist - dist / 2;
      smokeAt(other.position.translated(dx, dy.toDouble()));
    }
  }
}
