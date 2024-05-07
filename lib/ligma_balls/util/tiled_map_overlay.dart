import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'extensions.dart';

class TiledMapOverlay extends Component {
  final RenderableTiledMap _map;
  final Layer _layer;

  TiledMapOverlay(this._map, this._layer) {
    priority = 200;
  }

  @override
  void render(Canvas canvas) => _map.renderSingleLayer(canvas, _layer);
}
