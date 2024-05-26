import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';

import 'common.dart';

class Scoreboard extends PositionComponent {
  @override
  onLoad() async {
    add(await TiledComponent.load(
      'scoreboard.tmx',
      Vector2(16.0, 16.0),
      useAtlas: !kIsWeb,
      layerPaintFactory: (it) => pixelArtLayerPaint(),
    ));
    position = Vector2(0, 240);
    priority = 250;
  }
}
