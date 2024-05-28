import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/debug.dart';
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

  void Function(Projectile) modify = (_) {};

  @override
  onLoad() => position = (parent as PositionComponent).size / 4;

  final _targets = <PositionComponent>[];

  PositionComponent? get _activeTarget => _targets.lastOrNull;
  double _reload = 0;

  @override
  void update(double dt) {
    final dead = _targets.where((it) => it.parent == null);
    _targets.removeWhere((it) => dead.contains(it));

    final target = _activeTarget;
    if (target == null) {
      return;
    } else if (_reload > 0) {
      _reload -= dt;
    } else {
      final origin = parent as PositionComponent;
      final it = fireProjectile(_projectile, origin, target);
      modify(it);
      _reload = _reloadTime;
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (_projectile.isTarget(other)) _targets.add(other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (_projectile.isTarget(other)) {
      _targets.remove(other);
    }
  }
}
