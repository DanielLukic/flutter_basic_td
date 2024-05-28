import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../components/common.dart';
import '../components/smoke.dart';
import '../util/random.dart';
import 'can_be_slowed_down.dart';
import 'life.dart';
import 'projectile.dart';

mixin TakingHits on CollisionCallbacks, Life {
  late PositionComponent _self;
  late bool Function(ProjectileKind) _doesCauseHit;
  late double Function(ProjectileKind) _modifier;

  void Function(ProjectileKind) whenHit = (_) {};

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
      }
      if (other.kind == ProjectileKind.poop) {
        if (_self case CanBeSlowedDown it) {
          it.slowDown(0.1);
        }
      }
      if (_doesCauseHit(other.kind)) {
        final poopModifier = other.kind == ProjectileKind.poop ? 0.25 : 1;
        onHit(_self, damage: _modifier(other.kind) * poopModifier);
      }
      if (stillAlive) {
        whenHit(other.kind);
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
