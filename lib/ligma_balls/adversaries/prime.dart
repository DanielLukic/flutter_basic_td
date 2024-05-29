import 'package:dart_minilog/dart_minilog.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:ligma_balls/ligma_balls/level/win_lose_conditions.dart';

import '../components/common.dart';
import '../components/smoke.dart';
import '../components/soundboard.dart';
import '../damage/auto_target_shooter.dart';
import '../damage/life.dart';
import '../damage/projectile.dart';
import '../util/random.dart';

bool isDefender(PositionComponent it) => it is Defender || it is Prime;

class Prime extends SpriteComponent with CollisionCallbacks, Life {
  //
  final TiledObject object;

  Prime(this.object) : super(anchor: Anchor.center);

  @override
  onLoad() async {
    sprite = await game.loadSprite('prime.png');
    position = Vector2(object.x + 8, object.y - 8);
    priority = 50;
    add(CircleHitbox(isSolid: true, collisionType: CollisionType.active));
    addLifeIndicatorTo(this, maxDamage: 10);

    deezNutz = SpriteComponent(
      sprite: await game.loadSprite('deez_nutz.png'),
      anchor: Anchor.centerRight,
    );
    deezNutz.position.x += size.x / 3;
    deezNutz.position.y += size.y / 3;
  }

  late SpriteComponent deezNutz;

  @override
  void update(double dt) {
    super.update(dt);
    if (state != WinLoseState.levelComplete) return;
    if (deezNutz.parent != null) return;
    add(deezNutz);
    priority = 20000;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is AutoTargetShooter) return;
    if (other case Life it) {
      onHit(this, damage: it.remainingDamage);
      logInfo('prime remaining hits: $remainingDamage');
    }
    if (other is Projectile) {
      other.add(RemoveEffect(delay: 0.1));
      soundboard.play(Sound.vim);
    } else {
      other.add(RemoveEffect(delay: 0.5));
      soundboard.play(Sound.ligma);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is AutoTargetShooter) return;
    if (random.nextBool()) {
      final dist = position.distanceTo(other.position);
      final dx = random.nextDouble() * dist / 2;
      final dy = random.nextDouble() * dist - dist / 2;
      smokeAt(other.position.translated(dx, dy.toDouble()));
    }
  }
}
