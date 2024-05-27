import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../components/auto_target_shooter.dart';
import '../components/common.dart';
import '../components/life.dart';
import '../components/projectiles.dart';
import '../components/pulsing.dart';
import '../components/taking_hits.dart';
import 'free_placement.dart';

class NeoVim extends SpriteComponent
    with CollisionCallbacks, FreePlacementOnRemove, Defender, Life, TakingHits {
  //
  NeoVim({required super.position, super.anchor = Anchor.center});

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('neovim.png');

    final projectile = await makeProjectilePrototype(
      ProjectileKind.vim,
      isAttacker,
      60,
    );

    add(AutoTargetShooter(radius: 64, projectile: projectile));
    add(CircleHitbox(radius: size.x / 2));
    add(Pulsing());

    addLifeIndicatorTo(this, maxHits: 5);
    initTakingHits(this);
  }
}
