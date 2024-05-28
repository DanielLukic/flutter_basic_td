import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart' hide Image;

import '../components/common.dart';
import '../defenders/dipshit.dart';
import '../defenders/lithium.dart';
import '../defenders/neovim.dart';
import '../defenders/placement.dart';
import '../defenders/teej.dart';
import '../defenders/twitch.dart';
import '../level/game_level.dart';
import '../util/bitmap_font.dart';
import '../util/extensions.dart';
import '../util/fonts.dart';

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
      'Dipshit' => 250,
      'Lithium' => 400,
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
    if (dragged != null) level.remove(dragged!);
    dragged = SpriteComponent(sprite: prototype, anchor: Anchor.center);
    dragged!.priority = 800;
    dragged!.position = startPos + event.localPosition;
    level.add(dragged!);

    final radius = switch (object.name) {
      'Dipshit' => Dipshit.targetRadius,
      'Lithium' => Lithium.targetRadius,
      'NeoVim' => NeoVim.targetRadius,
      'Teej' => Teej.targetRadius,
      'Twitch' => Twitch.targetRadius,
      _ => throw ArgumentError('defender unknown: ${object.name}'),
    };
    final targetArea = CircleComponent(radius: radius, anchor: Anchor.center);
    targetArea.paint.color = Colors.black;
    targetArea.position = Vector2(dragged!.width / 2, dragged!.height / 2);
    targetArea.opacity = 0.25;
    dragged!.add(targetArea);
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
    if (dragged != null) level.remove(dragged!);
    dragged = null;
    placement.executePlacement((it) {
      level.subPoints(price);
      return switch (object.name) {
        'Dipshit' => Dipshit(position: it),
        'Lithium' => Lithium(position: it),
        'NeoVim' => NeoVim(position: it),
        'Teej' => Teej(position: it),
        'Twitch' => Twitch(position: it),
        _ => throw ArgumentError('defender unknown: ${object.name}'),
      };
    });
  }
}
