import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:ligma_balls/ligma_balls/defenders/neovim.dart';

import '../adversaries/prime.dart';
import '../adversaries/thor.dart';
import '../defenders/placement.dart';
import '../enemies/enemies.dart';
import '../enemies/waypoints.dart';
import '../util/extensions.dart';
import '../util/tiled_map_overlay.dart';
import 'level_dialog.dart';

class GameLevel extends Component {
  final int id;
  final String basename;

  GameLevel(this.id) : basename = 'level$id';

  Paint _layerPaint() => Paint()
    ..isAntiAlias = false
    ..filterQuality = FilterQuality.none;

  @override
  Future<void> onLoad() async {
    final map = await TiledComponent.load(
      '$basename.tmx',
      Vector2(16.0, 16.0),
      useAtlas: !kIsWeb,
      layerPaintFactory: (it) => _layerPaint(),
    );

    map.setLayerHidden('Accessible');
    map.setLayerHidden('Entities');
    map.setLayerHidden('Trees');
    map.setLayerHidden('Waypoints');

    final scoreboard = await TiledComponent.load(
      'scoreboard.tmx',
      Vector2(16.0, 16.0),
      useAtlas: !kIsWeb,
      layerPaintFactory: (it) => _layerPaint(),
    );
    scoreboard.position = Vector2(0, 240);
    scoreboard.priority = 250;

    final accessible = map.getLayer('Accessible') as TileLayer;
    placement = Placement(map.tileMap, accessible);

    final trees = map.getLayer('Trees') as TileLayer;

    final wpLayer = map.getLayer('Waypoints') as ObjectGroup;
    waypoints = Waypoints(wpLayer);

    final entitiesLayer = map.getLayer('Entities') as ObjectGroup;
    enemies = Enemies(entitiesLayer, map);

    final thorEntity = entitiesLayer.objectByName('Thor');
    final primeEntity = entitiesLayer.objectByName('Prime');

    addAll([
      map,
      scoreboard,
      enemies,
      placement,
      waypoints,
      Thor(thorEntity),
      Prime(primeEntity),
      NeoVim(position: Vector2(64, 32)),
      NeoVim(position: Vector2(128, 32)),
      TiledMapOverlay(map.tileMap, trees),
      LevelDialog('Level $id', map, ok: (it) {
        remove(it);
        startLevel();
      }),
    ]);
  }

  startLevel() {
    enemies.active = true;
  }
}
