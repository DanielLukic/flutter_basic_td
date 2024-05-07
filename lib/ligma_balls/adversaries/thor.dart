import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../components/common.dart';

class Thor extends SpriteComponent {
  //
  final TiledObject object;

  Thor(this.object) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('thor.png');
    position = Vector2(object.x + 8, object.y - 8);
    priority = 500;
  }
}
