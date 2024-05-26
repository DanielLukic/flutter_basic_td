import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';

import '../adversaries/prime.dart';
import '../adversaries/thor.dart';
import '../defenders/placement.dart';
import '../enemies/enemies.dart';
import '../enemies/waypoints.dart';
import '../util/extensions.dart';
import '../util/tiled_map_overlay.dart';
import 'common.dart';
import 'level_dialog.dart';
import 'scoreboard.dart';

late GameLevel level;

late TiledComponent map;
late TileLayer trees;

class GameLevel extends Component {
  final int id;
  final String basename;

  GameLevel(this.id) : basename = 'level$id';

  @override
  onLoad() async {
    level = this;

    map = await TiledComponent.load(
      '$basename.tmx',
      Vector2(16.0, 16.0),
      useAtlas: !kIsWeb,
      layerPaintFactory: (it) => pixelArtLayerPaint(),
    );

    map.setLayerHidden('Accessible');
    map.setLayerHidden('Entities');
    map.setLayerHidden('Trees');
    map.setLayerHidden('Waypoints');

    placement = Placement(map.tileMap);

    trees = map.getLayer('Trees') as TileLayer;

    final wpLayer = map.getLayer('Waypoints') as ObjectGroup;
    waypoints = Waypoints(wpLayer);

    final entitiesLayer = map.getLayer('Entities') as ObjectGroup;
    enemies = Enemies(entitiesLayer, map);

    final thorEntity = entitiesLayer.objectByName('Thor');
    final primeEntity = entitiesLayer.objectByName('Prime');

    addAll([
      map,
      Scoreboard(),
      enemies,
      placement,
      waypoints,
      Thor(thorEntity),
      Prime(primeEntity),
      TiledMapOverlay(map.tileMap, trees),
      if (showLevelDialog)
        LevelDialog('Level $id', map, ok: (it) {
          remove(it);
          startLevel();
        }),
    ]);
    enemies.active = !showLevelDialog;
  }

  bool showLevelDialog = false;

  startLevel() {
    enemies.active = true;
  }

  Iterable<TiledObject> get attackers {
    final entities = map.tileMap.getLayer('Entities') as ObjectGroup;
    return entities.objects.where((it) => it.class_ == 'Attacker');
  }

  Iterable<TiledObject> get defenders {
    final entities = map.tileMap.getLayer('Entities') as ObjectGroup;
    return entities.objects.where((it) => it.class_ == 'Defender');
  }
}
