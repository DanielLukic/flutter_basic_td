import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/common.dart';
import '../components/ligma_world.dart';

Future<SpriteAnimation> ligmaBalls() async => await game.loadSpriteAnimation(
    'balls.png',
    SpriteAnimationData.sequenced(
      amount: 16,
      amountPerRow: 8,
      stepTime: 0.05,
      textureSize: Vector2.all(16),
    ));

Future<SpriteAnimation> netflix() async => await game.loadSpriteAnimation(
      'netflix.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.05,
        textureSize: Vector2.all(16),
      ),
    );

Future<SpriteAnimation> twitchChat() async => await game.loadSpriteAnimation(
      'twitch_particle.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.05,
        textureSize: Vector2.all(12),
      ),
    );

Future<SpriteAnimation> vim() async => await game.loadSpriteAnimation(
      'vim.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.05,
        textureSize: Vector2.all(16),
      ),
    );

typedef IsTarget = bool Function(PositionComponent);

fireProjectile(
  SpriteAnimation it,
  PositionComponent origin,
  PositionComponent target,
  double speed,
  IsTarget isTarget,
) {
  final dir = (target.position - origin.position).normalized();
  final projectile = Projectile(
    animation: it,
    direction: dir,
    speed: speed,
    isTarget: isTarget,
  );
  projectile.position.setFrom(origin.position);
  world.level?.add(projectile);
}

class Projectile extends SpriteAnimationComponent {
  final Vector2 _direction;
  final double _speed;
  final IsTarget _isTarget;

  double _lifetime;

  Projectile({
    required super.animation,
    required Vector2 direction,
    required double speed,
    required IsTarget isTarget,
    double lifetime = 5,
    super.anchor = Anchor.center,
    super.key,
  })  : _lifetime = lifetime,
        _speed = speed,
        _isTarget = isTarget,
        _direction = direction {
    add(CircleHitbox(
      isSolid: true,
      collisionType: CollisionType.passive,
    ));
    priority = 200;
  }

  bool active = true;

  bool isTarget(PositionComponent it) => active && _isTarget(it);

  @override
  void update(double dt) {
    super.update(dt);
    if (_lifetime > 0) {
      _lifetime -= dt;
      if (active) {
        position += _direction * _speed * dt;
      }
    } else {
      removeFromParent();
    }
  }
}
