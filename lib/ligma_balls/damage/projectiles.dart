import 'package:flame/components.dart';
import 'package:ligma_balls/ligma_balls/damage/projectile.dart';

import '../components/common.dart';

Future<Projectile> makeProjectilePrototype(
  ProjectileKind kind,
  IsTarget isTarget,
  double speed,
) async {
  final anim = await switch (kind) {
    ProjectileKind.ligmaBalls => _ligmaBalls(),
    ProjectileKind.netflix => _netflix(),
    ProjectileKind.ocaml => _ocaml(),
    ProjectileKind.poop => _poop(),
    ProjectileKind.speech => _speech(),
    ProjectileKind.sub => _sub(),
    ProjectileKind.twitchChat => _twitchChat(),
    ProjectileKind.vim => _vim(),
  };
  return Projectile(
    kind: kind,
    animation: anim,
    isTarget: isTarget,
    speed: speed,
  );
}

Future<SpriteAnimation> _ligmaBalls() async =>
    _loadAnim(filename: 'balls.png', frames: 16, perRow: 8);

Future<SpriteAnimation> _netflix() async =>
    _loadAnim(filename: 'netflix.png', frames: 1);

Future<SpriteAnimation> _ocaml() async =>
    _loadAnim(filename: 'ocaml.png', frames: 1);

Future<SpriteAnimation> _poop() async =>
    _loadAnim(filename: 'poop.png', frames: 1);

Future<SpriteAnimation> _speech() async =>
    _loadAnim(filename: 'speech.png', frames: 1);

Future<SpriteAnimation> _sub() async =>
    _loadAnim(filename: 'sub.png', frames: 1);

Future<SpriteAnimation> _twitchChat() async =>
    _loadAnim(filename: 'twitch_particle.png', frames: 1, size: 12);

Future<SpriteAnimation> _vim() async =>
    _loadAnim(filename: 'vim.png', frames: 1);

Future<SpriteAnimation> _loadAnim({
  required String filename,
  required int frames,
  int? perRow,
  double? size,
}) async =>
    await game.loadSpriteAnimation(
        filename,
        SpriteAnimationData.sequenced(
          amount: frames,
          amountPerRow: perRow ?? frames,
          stepTime: 0.05,
          textureSize: Vector2.all(size ?? 16),
        ));
