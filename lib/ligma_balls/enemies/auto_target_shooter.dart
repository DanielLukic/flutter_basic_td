import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../adversaries/prime.dart';
import '../components/debug.dart';
import '../defenders/neovim.dart';
import 'projectile.dart';

class AutoTargetShooter extends PositionComponent with CollisionCallbacks {
  final SpriteAnimation _projectile;
  final double _reloadTime;

  AutoTargetShooter(this._projectile, {double reloadTime = 1})
      : _reloadTime = reloadTime {
    //
    add(CircleHitbox(
      radius: 32,
      position: Vector2.all(8),
      anchor: Anchor.center,
      collisionType: CollisionType.active,
    ));

    add(DebugCircleHitbox(
      radius: 32,
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
      fireProjectile(_projectile, origin, target, 80);
      _reload = _reloadTime;
    }
  }

  bool _isTarget(PositionComponent component) {
    return component is Prime || component is NeoVim;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (_isTarget(other)) _activeTarget = other;
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (_isTarget(other) && _activeTarget == other) _activeTarget = null;
  }
}
