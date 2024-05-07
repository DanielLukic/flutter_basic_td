import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../components/common.dart';
import '../util/tiled_map_overlay.dart';

late Placement placement;

class Placement extends Component with HasVisibility {
  final RenderableTiledMap _map;
  final Layer layer;

  Placement(this._map, this.layer);

  @override
  bool get isVisible => debug;

  @override
  void onLoad() => add(TiledMapOverlay(_map, layer));
}
