import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../defenders/neovim.dart';
import '../defenders/placement.dart';
import '../defenders/teej.dart';
import '../defenders/twitch.dart';
import '../util/bitmap_font.dart';
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

    final pos = Vector2(180, 16);
    final defenders = world.level!.defenders;
    for (final it in defenders) {
      add(DefenderIcon(it, pos));
      pos.x += 32;
    }

    add(LevelInfo(Vector2(120, 56)));
    add(PlacementPoints());
  }
}

class LevelInfo extends PositionComponent with TapCallbacks {
  LevelInfo(Vector2 position) {
    this.position = position;
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    final x = point.x;
    final y = point.y;
    if (x < 0 || y < 0 || x > 80 || y > 16) return false;
    return true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    if (!dev) return;
    if (event.localPosition.x > 40) {
      world.nextLevel();
    } else {
      world.prevLevel();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    menuFont.scale = 0.5;
    menuFont.tint(textColor);
    menuFont.drawText(canvas, 0, 0, 'Level ${level.id}');
  }
}

class PlacementPoints extends Component {
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    menuFont.scale = 0.25;
    menuFont.tint(textColor);
    menuFont.drawText(canvas, 120, 15, 'Defender\nBudget:');

    menuFont.scale = 0.5;
    menuFont.tint(textColor);
    menuFont.drawText(canvas, 120, 31, '\$${level.displayPoints.toInt()}');
  }
}

class DefenderIcon extends PositionComponent with DragCallbacks {
  final TiledObject object;

  late SpriteComponent image;

  DefenderIcon(this.object, Vector2 position) {
    final idx = entityTileIndex[object.name]!;
    final sprite = map.tileSprite(idx);
    add(image = SpriteComponent(sprite: sprite));
    this.position = position;
    size = Vector2.all(16);

    price = switch (object.name) {
      'NeoVim' => 80,
      'Teej' => 200,
      'Twitch' => 90,
      _ => throw ArgumentError('unknown defender: ${object.name}'),
    };
  }

  late int price;

  @override
  void update(double dt) {
    super.update(dt);
    if (level.remainingPoints >= price) {
      image.opacity = 1;
      available = true;
    } else {
      image.opacity = 0.5;
      available = false;
    }
  }

  bool available = true;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    menuFont.scale = 0.25;
    menuFont.tint(available ? textColor : errorColor);
    menuFont.drawText(canvas, 0, 20, '\$$price');
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
    return available;
  }

  SpriteComponent? dragged;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (!available) return;
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
      level.subPoints(price);
      return switch (object.name) {
        'NeoVim' => NeoVim(position: it),
        'Teej' => Teej(position: it),
        'Twitch' => Twitch(position: it),
        _ => throw ArgumentError('defender unknown: ${object.name}'),
      };
    });
  }
}
