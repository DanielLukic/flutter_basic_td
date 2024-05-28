import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';

import '../adversaries/prime.dart';
import '../adversaries/thor.dart';
import '../components/common.dart';
import '../components/pills.dart';
import '../components/trees.dart';
import '../defenders/placement.dart';
import '../enemies/enemies.dart';
import '../enemies/waypoints.dart';
import '../scoreboard/scoreboard.dart';
import '../util/extensions.dart';
import 'level_dialog.dart';
import 'win_lose_conditions.dart';

late GameLevel level;

late TiledComponent map;

class GameLevel extends Component {
  final int id;
  final String basename;

  GameLevel(this.id) : basename = 'level$id';

  double remainingPoints = 0;

  void addPoints(int count) {
    remainingPoints += count;
  }

  void subPoints(int count) {
    remainingPoints -= count;
    if (remainingPoints < 0) remainingPoints = 0;
  }

  @override
  onLoad() async {
    level = this;

    map = await TiledComponent.load(
      '$basename.tmx',
      Vector2(16.0, 16.0),
      useAtlas: !kIsWeb,
      layerPaintFactory: (it) => pixelArtLayerPaint(),
    );

    remainingPoints = map.intProperty('PlacementPoints').toDouble();

    map.setLayerHidden('Accessible');
    map.setLayerHidden('Entities');
    map.setLayerHidden('Pills');
    map.setLayerHidden('Trees');
    map.setLayerHidden('Waypoints');

    placement = Placement(map.tileMap);

    final pills = Pills(map, map.getLayer('Pills') as TileLayer);
    final trees = Trees(map, map.getLayer('Trees') as TileLayer);

    final wpLayer = map.getLayer('Waypoints') as ObjectGroup;
    waypoints = Waypoints(wpLayer);

    final entitiesLayer = map.getLayer('Entities') as ObjectGroup;
    enemies = Enemies(entitiesLayer, map);

    final thorEntity = entitiesLayer.objectByName('Thor');
    final primeEntity = entitiesLayer.objectByName('Prime');

    addAll([
      map,
      placement,
      pills,
      Scoreboard(),
      enemies,
      waypoints,
      Thor(thorEntity),
      prime = Prime(primeEntity),
      trees,
      if (showLevelDialog)
        LevelDialog('Level $id', map, ok: (it) {
          remove(it);
          startLevel();
        }),
      WinLoseConditions(prime, enemies),
    ]);
    enemies.active = !showLevelDialog;
  }

  late Prime prime;

  bool showLevelDialog = true;

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
