import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../components/common.dart';
import '../components/smoke.dart';
import '../damage/projectile.dart';
import '../level/win_lose_conditions.dart';

class Thor extends SpriteComponent with CollisionCallbacks {
  //
  final TiledObject object;

  Thor(this.object) : super(anchor: Anchor.center);

  @override
  onLoad() async {
    sprite = await game.loadSprite('thor.png');
    position = Vector2(object.x + 8, object.y - 8);
    priority = 500;
    add(CircleHitbox(collisionType: CollisionType.active));

    ligmaBalls = SpriteComponent(
      sprite: await game.loadSprite('ligma_balls.png'),
      anchor: Anchor.centerLeft,
    );
    ligmaBalls.position.x += size.x * 2 / 3;
    ligmaBalls.position.y += size.y / 3;
  }

  late SpriteComponent ligmaBalls;

  @override
  void update(double dt) {
    super.update(dt);
    if (state != WinLoseState.gameOver) return;
    if (ligmaBalls.parent != null) return;
    add(ligmaBalls);
    priority = 20000;
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
