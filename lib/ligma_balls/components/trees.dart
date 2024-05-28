import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../defenders/placement.dart';
import '../util/extensions.dart';
import 'common.dart';

class Trees extends Component {
  TiledComponent map;
  TileLayer layer;

  Trees(this.map, this.layer);

  final tiles = <int, SpriteComponent>{};

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
          final tile = SpriteComponent(sprite: sprite, position: pos);
          if (id != 109 && id != 110) {
            tiles[idx] = tile;
            tile.priority = 250;
          }
          add(tile);
        }
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final key in tiles.keys) {
      tiles[key]!.opacity = placement.available[key] ? 1 : 0.5;
    }
  }
}
