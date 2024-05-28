import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/common.dart';
import '../level/game_level.dart';

Projectile fireProjectile(
  Projectile prototype,
  PositionComponent origin,
  PositionComponent target,
) {
  final dir = (target.position - origin.position).normalized();
  final projectile = prototype.clone();
  projectile.direction = dir;
  projectile.position.setFrom(origin.position);
  level.add(projectile);
  return projectile;
}

class Projectile extends SpriteAnimationComponent {
  final ProjectileKind kind;
  final IsTarget _isTarget;

  double speed;
  double lifetime;

  late Vector2 direction;

  Projectile({
    required this.kind,
    required super.animation,
    required IsTarget isTarget,
    required this.speed,
    this.lifetime = 5,
    super.anchor = Anchor.center,
    super.key,
  }) : _isTarget = isTarget {
    size = Vector2(8, 8);
    add(CircleHitbox(
      isSolid: true,
      collisionType: CollisionType.passive,
    ));
    priority = 200;
  }

  Projectile clone() => Projectile(
        kind: kind,
        animation: super.animation,
        speed: speed,
        lifetime: lifetime,
        isTarget: _isTarget,
      );

  bool active = true;

  bool isTarget(PositionComponent it) => active && _isTarget(it);

  @override
  onLoad() => _lifetime = lifetime;

  late double _lifetime;

  @override
  void update(double dt) {
    super.update(dt);
    if (_lifetime > 0) {
      _lifetime -= dt;
      if (active) {
        position += direction * speed * dt;
      }
    } else {
      removeFromParent();
    }
  }
}
