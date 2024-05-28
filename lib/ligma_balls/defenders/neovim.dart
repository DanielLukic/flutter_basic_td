import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/common.dart';
import '../components/soundboard.dart';
import '../damage/auto_target_shooter.dart';
import '../damage/life.dart';
import '../damage/projectiles.dart';
import '../damage/taking_hits.dart';
import 'placement.dart';

class NeoVim extends SpriteComponent
    with CollisionCallbacks, FreePlacementOnRemove, Defender, Life, TakingHits {
  //
  NeoVim({required super.position, super.anchor = Anchor.center});

  static const double targetRadius = 64;

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('neovim.png');

    final projectile = await makeProjectilePrototype(
      ProjectileKind.vim,
      isAttacker,
      60,
    );

    add(
      AutoTargetShooter(radius: targetRadius, projectile: projectile)
        ..anchor = Anchor.center,
    );
    add(CircleHitbox(radius: size.x / 2));

    addLifeIndicatorTo(this, maxDamage: 5, deathSound: Sound.explosion);
    initTakingHits(this);
  }
}
