import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../enemies/can_be_slowed_down.dart';
import 'common.dart';
import 'life.dart';
import 'projectile.dart';
import 'smoke.dart';

mixin TakingHits on CollisionCallbacks, Life {
  late PositionComponent _self;
  late bool Function(ProjectileKind) _doesCauseHit;
  late double Function(ProjectileKind) _modifier;

  void initTakingHits(
    PositionComponent self, {
    bool Function(ProjectileKind)? whereKind,
    double Function(ProjectileKind)? modifier,
  }) {
    _self = self;
    _doesCauseHit = whereKind ?? (_) => true;
    _modifier = modifier ?? (_) => 1;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Projectile && other.isTarget(_self)) {
      other.active = false;
      other.add(RemoveEffect(delay: 0.1));
      smokeAround(other.position, _self.size / 2);
      if (other.kind == ProjectileKind.speech) {
        if (_self case CanBeSlowedDown it) {
          it.slowDown();
        }
      } else if (_doesCauseHit(other.kind)) {
        onHit(_self, damage: _modifier(other.kind));
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Projectile && other.isTarget(_self)) {
      final off = randomNormalizedVector() * other.size.x / 2;
      smokeAt(other.position + off);
    }
  }
}
