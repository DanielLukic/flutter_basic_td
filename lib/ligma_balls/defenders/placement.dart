import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../components/common.dart';
import '../util/extensions.dart';
import '../util/tiled_map_overlay.dart';

late Placement placement;

class Placement extends Component with HasVisibility {
  final RenderableTiledMap _map;

  Placement(this._map);

  @override
  bool get isVisible => debug;

  late List<bool> available;

  @override
  void onLoad() {
    final bgap = _map.requireTileLayer('BackgroundAndPath');
    final rocks = _map.requireTileLayer('Rocks');
    final trees = _map.requireTileLayer('Trees');
    final attr = _map.requireTileLayer('Attribution');

    final accessible = _map.requireTileLayer('Accessible');
    final data = List.generate(bgap.width * bgap.height, (it) {
      var available = true;
      final bg = bgap.data![it];
      if (bg != 37) available = false;
      if (rocks.data![it] != 0) available = false;
      if (trees.data![it] == 110) available = false;
      if (trees.data![it] == 111) available = false;
      if (attr.data![it] != 0) available = false;
      return available ? 269 : 0;
    });
    available = data.map((it) => it == 0).toList();

    accessible.data = data;
    accessible.tileData = Gid.generate(
      data,
      accessible.width,
      accessible.height,
    );
    _map.refresh(accessible);

    add(TiledMapOverlay(_map, accessible));
  }
}
