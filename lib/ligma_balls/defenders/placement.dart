import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

import '../components/common.dart';
import '../components/ligma_world.dart';
import '../components/smoke.dart';
import '../components/soundboard.dart';
import '../level/game_level.dart';
import '../util/extensions.dart';
import '../util/random.dart';
import '../util/tiled_map_overlay.dart';

late Placement placement;

mixin FreePlacementOnRemove on PositionComponent {
  @override
  void onRemove() {
    super.onRemove();
    placement.free(position);
  }
}

class Placement extends Component with HasVisibility {
  final RenderableTiledMap _map;

  Placement(this._map);

  @override
  bool get isVisible => debug;

  late int levelWidth;
  late int levelHeight;
  late List<bool> available;

  final bgOk = [37, 70, 65];

  @override
  void onLoad() {
    final bgap = _map.requireTileLayer('BackgroundAndPath');
    final rocks = _map.requireTileLayer('Rocks');
    final trees = _map.requireTileLayer('Trees');
    final attr = _map.requireTileLayer('Attribution');

    levelWidth = bgap.width;
    levelHeight = bgap.height;

    final accessible = _map.requireTileLayer('Accessible');
    final data = List.generate(bgap.width * bgap.height, (it) {
      var available = true;
      final bg = bgap.data![it];
      if (!bgOk.contains(bg)) available = false;
      if (rocks.data![it] != 0) available = false;
      if (trees.data![it] == 110) available = false;
      if (trees.data![it] == 111) available = false;
      if (attr.data![it] != 0) available = false;
      return available ? 269 : 0;
    });

    available = data.map((it) => it != 0).toList();

    accessible.data = data;
    accessible.tileData = Gid.generate(
      data,
      accessible.width,
      accessible.height,
    );
    _map.refresh(accessible);

    add(TiledMapOverlay(_map, accessible));

    indicator = map.tileSprite(268);
  }

  late Sprite indicator;

  var indicators = <SpriteComponent>[];

  tryPlace(Vector2 center, {double tilesWH = 2}) {
    final size = tilesWH * tileSize;
    final tl = center - Vector2.all(size / 4);
    tl.x = tl.x ~/ tileSize * tileSize;
    tl.y = tl.y ~/ tileSize * tileSize;
    if (indicators.isEmpty) {
      indicators = List.generate(4, (_) => SpriteComponent(sprite: indicator));
      for (final it in indicators) {
        level.add(it);
      }
    }
    indicators[0].position = tl;
    indicators[1].position = tl + Vector2(tileSize, 0);
    indicators[2].position = tl + Vector2(0, tileSize);
    indicators[3].position = tl + Vector2(tileSize, tileSize);

    validPlacement = true;
    for (final it in indicators) {
      final x = it.position.x ~/ tileSize;
      final y = it.position.y ~/ tileSize;
      if (x < 0 || y < 0 || x >= levelWidth || y >= levelHeight) {
        validPlacement = false;
      } else {
        final index = x + y * levelWidth;
        if (available[index]) {
          it.tint(Colors.white);
        } else {
          it.tint(Colors.red);
          validPlacement = false;
        }
      }
    }
  }

  bool validPlacement = false;

  executePlacement(PositionComponent Function(Vector2) create) {
    if (indicators.isEmpty) return;

    if (validPlacement) {
      level.add(create(indicators[3].position));
      for (final it in indicators) {
        final x = it.position.x ~/ tileSize;
        final y = it.position.y ~/ tileSize;
        available[x + y * levelWidth] = false;
      }
      world.score += 10;
      final center = indicators[3].position;
      const step = (pi * 2) / 16;
      final off = Vector2.zero();
      for (double rad = 0; rad < pi * 2; rad += step) {
        off.x = sin(rad) * tileSize / 3;
        off.y = cos(rad) * tileSize / 3;
        final move = MoveByEffect(
          off,
          CurvedEffectController(1, const ElasticOutCurve()),
        );
        final it = smokeAt(center + off + randomNormalizedVector() * 4);
        it.add(move);
      }
      soundboard.play(Sound.rock);
    }

    for (final it in indicators) {
      level.remove(it);
    }
    indicators = [];
  }

  free(Vector2 center, [double tilesWH = 2]) {
    final size = tilesWH * tileSize;
    final x = (center.x - size / 2) ~/ tileSize;
    final y = (center.y - size / 2) ~/ tileSize;
    for (int dy = 0; dy < tilesWH; dy++) {
      for (int dx = 0; dx < tilesWH; dx++) {
        available[x + dx + (y + dy) * levelWidth] = true;
      }
    }
  }
}
