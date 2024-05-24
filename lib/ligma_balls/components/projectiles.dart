import 'package:flame/components.dart';
import 'package:ligma_balls/ligma_balls/components/projectile.dart';

import 'common.dart';

Future<Projectile> makeProjectilePrototype(
  ProjectileKind kind,
  IsTarget isTarget,
) async {
  final anim = await switch (kind) {
    ProjectileKind.ligmaBalls => _ligmaBalls(),
    ProjectileKind.netflix => _netflix(),
    ProjectileKind.twitchChat => _twitchChat(),
    ProjectileKind.vim => _vim(),
  };
  return Projectile(kind: kind, animation: anim, isTarget: isTarget);
}

Future<SpriteAnimation> _ligmaBalls() async =>
    _loadAnim(filename: 'balls.png', frames: 16);

Future<SpriteAnimation> _netflix() async =>
    _loadAnim(filename: 'netflix.png', frames: 1);

Future<SpriteAnimation> _twitchChat() async =>
    _loadAnim(filename: 'twitch_particle.png', frames: 1, size: 12);

Future<SpriteAnimation> _vim() async =>
    _loadAnim(filename: 'vim.png', frames: 1);

Future<SpriteAnimation> _loadAnim({
  required String filename,
  required int frames,
  double? size,
}) async =>
    await game.loadSpriteAnimation(
        filename,
        SpriteAnimationData.sequenced(
          amount: frames,
          stepTime: 0.05,
          textureSize: Vector2.all(size ?? 16),
        ));
