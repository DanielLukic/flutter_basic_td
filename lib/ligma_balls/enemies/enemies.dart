import 'package:dart_minilog/dart_minilog.dart';
import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../components/common.dart';
import '../util/extensions.dart';
import 'enemy_spawner.dart';

late Enemies enemies;

class Enemies extends Component with HasVisibility {
  final ObjectGroup group;
  final TiledComponent map;

  Enemies(this.group, this.map);

  final nursery = <EnemySpawner>[];

  bool active = false;

  bool get allDefeated {
    if (nursery.isNotEmpty) return false;
    for (final it in parent!.children) {
      if (it is Attacker) return false;
    }
    return true;
  }

  @override
  bool get isVisible => debug;

  @override
  void onLoad() {
    final enemies = group.objects.where((it) => it.class_ == 'Attacker');
    _addDebugOverlays(enemies);
    for (var it in enemies) {
      try {
        nursery.add(EnemySpawner(it));
      } catch (e, trace) {
        logError('failed creating spawner for ${it.name}: $e', trace);
      }
    }
  }

  void _addDebugOverlays(Iterable<TiledObject> enemies) {
    for (final it in enemies) {
      final tileIdx = entityTileIndex[it.name];
      if (tileIdx == null) continue;

      final sprite = map.tileSprite(tileIdx);

      final comp = SpriteComponent(
        sprite: sprite,
        position: Vector2(it.x + 8, it.y - 8),
        anchor: Anchor.center,
      );
      comp.decorator.addLast(PaintDecorator.grayscale(opacity: 0.75));
      add(comp);

      final idx = group.objects.indexOf(it).toString();
      add(
        TextComponent(
          text: idx,
          position: Vector2(it.x + 8, it.y - 8),
          anchor: Anchor.center,
          scale: Vector2(0.25, 0.25),
        ),
      );
    }
  }

  double _lifetime = 0;

  @override
  void update(double dt) {
    if (!active) return;

    _lifetime += dt;
    super.update(dt);

    final depleted = <EnemySpawner>[];
    for (final spawner in nursery) {
      final spawn = spawner.spawnWhen(_lifetime);
      if (spawn) {
        final enemy = spawner.spawn(map);
        if (enemy != null) parent?.add(enemy);
      }
      if (spawner.isDepleted) depleted.add(spawner);
    }
    for (final it in depleted) {
      nursery.remove(it);
    }
  }
}
