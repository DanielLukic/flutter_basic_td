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

fireProjectile(
  SpriteAnimation it,
  PositionComponent origin,
  PositionComponent target,
  double speed,
) {
  final dir = (target.position - origin.position).normalized();
  final projectile = Projectile(animation: it, direction: dir, speed: speed);
  projectile.position.setFrom(origin.position);
  world.level?.add(projectile);
}

class Projectile extends SpriteAnimationComponent {
  final Vector2 _direction;
  final double _speed;

  double _lifetime;

  Projectile({
    required super.animation,
    required Vector2 direction,
    required double speed,
    double lifetime = 5,
    super.anchor = Anchor.center,
    super.key,
  })  : _lifetime = lifetime,
        _speed = speed,
        _direction = direction {
    add(CircleHitbox(
      isSolid: true,
      collisionType: CollisionType.passive,
    ));
    priority = 200;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_lifetime > 0) {
      _lifetime -= dt;
      position += _direction * _speed * dt;
    } else {
      removeFromParent();
    }
  }
}
