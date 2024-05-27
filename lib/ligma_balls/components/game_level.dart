import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';

import '../adversaries/prime.dart';
import '../adversaries/thor.dart';
import '../defenders/placement.dart';
import '../enemies/enemies.dart';
import '../enemies/waypoints.dart';
import '../util/extensions.dart';
import 'common.dart';
import 'level_dialog.dart';
import 'pills.dart';
import 'scoreboard.dart';
import 'trees.dart';
import 'win_lose_conditions.dart';

late GameLevel level;

late TiledComponent map;

class GameLevel extends Component {
  final int id;
  final String basename;

  GameLevel(this.id) : basename = 'level$id';

  double displayPoints = 0;

  double remainingPoints = 0;

  void addPoints(int count) {
    remainingPoints += count;
  }

  void subPoints(int count) {
    remainingPoints -= count;
    if (remainingPoints < 0) remainingPoints = 0;
  }

  final double minStep = 5;

  @override
  void update(double dt) {
    super.update(dt);
    if (remainingPoints != displayPoints) {
      var delta = (remainingPoints - displayPoints) * dt;
      if (delta.abs() < minStep) delta = delta < 0 ? -minStep : minStep;
      displayPoints += delta;
    }
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

    displayPoints = map.intProperty('PlacementPoints').toDouble();
    remainingPoints = displayPoints;

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
