import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';

import '../components/common.dart';
import '../level/game_level.dart';
import '../util/bitmap_text.dart';
import '../util/fonts.dart';
import 'defender_icon.dart';
import 'level_info.dart';
import 'placement_points.dart';
import 'score.dart';
import 'volume_indicator.dart';

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

    final pos = Vector2(180, 16);
    final defenders = level.defenders;
    for (final it in defenders) {
      add(DefenderIcon(it, pos));
      pos.x += 32;
    }
    add(BitmapText(
      text: '(Drag onto playfield)',
      position: Vector2(180, 45),
      tint: textColor,
      scale: 0.25,
    ));

    add(LevelInfo(Vector2(120, 56)));
    add(PlacementPoints());
    add(Score(position: Vector2(8, 15)));

    add(BitmapText(
      text: 'Volume:',
      position: Vector2(255, 45),
      tint: textColor,
      scale: 0.5,
    ));

    final volume = await images.load('volume.png');
    add(VolumeIndicator(volume, position: Vector2(255, 55)));
  }
}
