import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';

import '../defenders/neovim.dart';
import '../defenders/placement.dart';
import '../defenders/teej.dart';
import '../defenders/twitch.dart';
import '../util/extensions.dart';
import 'common.dart';
import 'game_level.dart';
import 'ligma_world.dart';

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

    final pos = Vector2(160, 16);
    final defenders = world.level!.defenders;
    for (final it in defenders) {
      add(DefenderIcon(it, pos));
      pos.x += 24;
    }
  }
}

class DefenderIcon extends PositionComponent with DragCallbacks {
  final TiledObject object;

  DefenderIcon(this.object, Vector2 position) {
    final idx = entityTileIndex[object.name]!;
    final sprite = map.tileSprite(idx);
    add(SpriteComponent(sprite: sprite));
    this.position = position;
    size = Vector2.all(16);
  }

  @override
  onLoad() async {
    prototype = await game.loadSprite('${object.name.toLowerCase()}.png');
    startPos.setFrom(_parentPos);
    startPos.add(position);
  }

  late Sprite prototype;

  final startPos = Vector2.zero();

  Vector2 get _parentPos => (parent as PositionComponent).position;

  @override
  bool containsLocalPoint(Vector2 point) {
    if (point.x < 0 || point.y < 0) return false;
    if (point.x >= size.x || point.y >= size.y) return false;
    return true;
  }

  SpriteComponent? dragged;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (dragged != null) world.level!.remove(dragged!);
    dragged = SpriteComponent(sprite: prototype, anchor: Anchor.center);
    dragged!.priority = 800;
    dragged!.position = startPos + event.localPosition;
    world.level!.add(dragged!);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (dragged == null) return;
    dragged!.position = startPos + event.localEndPosition;
    placement.tryPlace(dragged!.position);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (dragged == null) return;
    if (dragged != null) world.level!.remove(dragged!);
    dragged = null;
    placement.executePlacement((it) {
      return switch (object.name) {
        "NeoVim" => NeoVim(position: it),
        "Teej" => Teej(position: it),
        "Twitch" => Twitch(position: it),
        _ => throw ArgumentError('defender unknown: ${object.name}'),
      };
    });
  }
}
