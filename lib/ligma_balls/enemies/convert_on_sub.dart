import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/common.dart';
import '../components/pulsing.dart';
import '../damage/life.dart';
import '../damage/taking_hits.dart';
import '../level/game_level.dart';
import '../util/extensions.dart';
import '../util/random.dart';

class RotatingSub extends PositionComponent with CollisionCallbacks {
  double rotation;

  RotatingSub(this.rotation);

  final base = Vector2.zero();

  @override
  onLoad() async {
    base.setFrom(position);

    final image = await game.loadSprite('sub.png');
    final sprite = SpriteComponent(sprite: image, anchor: Anchor.center);
    sprite.size = Vector2.all(8);
    add(sprite);

    add(CircleHitbox(
      radius: 4,
      anchor: Anchor.center,
      collisionType: CollisionType.active,
    ));
  }

  @override
  update(double dt) {
    final dx = sin(rotation) * tileSize;
    final dy = cos(rotation) * tileSize;
    position.x = base.x + dx;
    position.y = base.y + dy;
    rotation += dt * pi * 2;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other case Life it) {
      it.onHit(it as PositionComponent);
      parent?.remove(this);
    }
  }
}

class Convert extends PositionComponent implements Defender {
  Convert(Sprite sprite, PositionComponent ref) {
    add(SpriteComponent(sprite: sprite));
    anchor = Anchor.center;
    position = ref.position;
    size = ref.size;
    add(Pulsing());
    const step = pi / 4;
    for (double angle = 0; angle < pi * 2; angle += step) {
      final sub = RotatingSub(angle);
      sub.position = ref.size / 2;
      add(sub);
    }
  }
}

mixin ConvertOnSub on TakingHits {
  late double probability;

  void initConvertOnSub({double probability = 1}) {
    this.probability = probability;
    whenHit = (it) {
      if (it == ProjectileKind.sub && random.nextDouble() <= probability) {
        convert();
      }
    };
  }

  void convert() {
    parent?.remove(this);
    final sprite = map.tileSprite(entityTileIndex['Diablo']!);
    parent?.add(Convert(sprite, this as PositionComponent));
  }
}
