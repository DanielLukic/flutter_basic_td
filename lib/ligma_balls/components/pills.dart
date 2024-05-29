import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:ligma_balls/ligma_balls/components/ligma_world.dart';

import '../defenders/placement.dart';
import '../level/game_level.dart';
import '../util/extensions.dart';
import 'common.dart';
import 'pulsing.dart';

class Pills extends Component {
  TiledComponent map;
  TileLayer layer;

  Pills(this.map, this.layer);

  final tiles = <int, (int, SpriteComponent)>{};

  @override
  onLoad() {
    final w = layer.width;
    final h = layer.height;
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        final idx = x + y * w;
        final id = layer.data![idx] - 1;
        if (id != -1) {
          final sprite = map.tileSprite(id);
          final pos = Vector2(x * tileSize, y * tileSize);
          pos.x += tileSize / 2;
          pos.y += tileSize;
          final pill = SpriteComponent(
            sprite: sprite,
            position: pos,
            anchor: Anchor.bottomCenter,
          );
          pill.add(Pulsing());
          tiles[idx] = (id, pill);
          add(pill);
        }
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final consume = <int>[];
    for (final key in tiles.keys) {
      if (placement.available[key]) continue;
      consume.add(key);
    }
    for (final key in consume) {
      final it = tiles.remove(key)!;
      level.addPoints(it.$1 == 234 ? 15 : 30);
      world.score += 5;
      remove(it.$2);
    }
  }
}
