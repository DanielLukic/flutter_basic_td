import 'package:dart_minilog/dart_minilog.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../components/common.dart';
import '../util/extensions.dart';
import 'ghostling.dart';
import 'goblin.dart';

class EnemySpawner {
  final TiledObject _object;
  final List<double> spawnTimes = [];

  EnemySpawner(this._object) {
    final spec = _object.spawnSpec.split(' ');
    final times = double.parse(spec[0].replaceFirst('x', ''));
    final start = double.parse(spec[2].replaceFirst('s', ''));
    final step = double.parse(spec[4].replaceFirst('s', ''));
    var at = start;
    for (int i = 0; i < times; i++) {
      spawnTimes.add(at);
      at += step;
    }
  }

  double _lifetime = 0;

  bool get isDepleted => spawnTimes.isEmpty;

  bool spawnWhen(double lifetime) {
    final at = spawnTimes.firstOrNull;
    final result = at != null && _lifetime <= at && lifetime >= at;
    if (result) spawnTimes.removeAt(0);
    _lifetime = lifetime;
    return result;
  }

  int _nextPriority = 100;

  Component? spawn(TiledComponent map) {
    logInfo('spawn ${_object.name}');
    final pos = Vector2(24, 120);
    final it = switch (_object.name) {
      'Goblin' => _makeGoblin(pos, map),
      'Ghostling' => _makeGhostling(pos, map),
      _ => _makeGoblin(pos, map),
    };
    it.priority = _nextPriority--;
    return it;
  }

  Goblin _makeGoblin(Vector2 position, TiledComponent map) {
    final sprite = map.tileSprite(entityTileIndex['Goblin']!);
    return Goblin(position: position, sprite: sprite);
  }

  Ghostling _makeGhostling(Vector2 position, TiledComponent map) {
    final sprite = map.tileSprite(entityTileIndex['Ghostling']!);
    return Ghostling(position: position, sprite: sprite);
  }
}
