import 'package:flame/components.dart';

import '../level/game_level.dart';
import '../util/random.dart';
import 'common.dart';

Smoke smokeAt(Vector2 position) {
  final smoke = Smoke(position: position);
  level.add(smoke);
  return smoke;
}

void smokeAround(Vector2 position, Vector2 size, [int? count]) {
  count ??= size.x ~/ 4;
  repeat(count, (_) {
    final at = randomNormalizedVector();
    at.x *= size.x;
    at.y *= size.y;
    level.add(Smoke(position: position + at));
  });
}

class Smoke extends SpriteAnimationComponent {
  Smoke({super.position})
      : super(
          size: Vector2.all(8),
          anchor: Anchor.center,
          removeOnFinish: true,
          priority: 500,
        );

  @override
  Future<void> onLoad() async {
    animation = await game.loadSpriteAnimation(
      'smoke.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.1,
        amount: 6,
        textureSize: Vector2.all(16),
        loop: false,
      ),
    );
  }
}
