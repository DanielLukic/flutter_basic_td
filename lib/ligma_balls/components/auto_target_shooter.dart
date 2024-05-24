import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'debug.dart';
import 'projectile.dart';

class AutoTargetShooter extends PositionComponent with CollisionCallbacks {
  final Projectile _projectile;
  final double _reloadTime;

  AutoTargetShooter({
    required Projectile projectile,
    double radius = 32,
    double reloadTime = 1,
  })  : _projectile = projectile,
        _reloadTime = reloadTime {
    //
    add(CircleHitbox(
      radius: radius,
      position: Vector2.all(8),
      anchor: Anchor.center,
      collisionType: CollisionType.active,
      isSolid: true,
    ));

    add(DebugCircleHitbox(
      radius: radius,
      position: Vector2.all(8),
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0x40000000),
      priority: 0,
    ));
  }

  PositionComponent? _activeTarget;
  double _reload = 0;

  @override
  void update(double dt) {
    final target = _activeTarget;
    if (target == null) {
      return;
    } else if (_reload > 0) {
      _reload -= dt;
    } else {
      final origin = parent as PositionComponent;
      fireProjectile(_projectile, origin, target);
      _reload = _reloadTime;
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (_projectile.isTarget(other)) _activeTarget = other;
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (_projectile.isTarget(other) && _activeTarget == other) {
      _activeTarget = null;
    }
  }
}
