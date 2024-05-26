import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

extension ObjectGroupExtensions on ObjectGroup {
  TiledObject objectByName(String name) =>
      objects.firstWhere((it) => it.name == name);
}

extension RenderableTiledMapExtensions on RenderableTiledMap {
  TileLayer requireTileLayer(String name) {
    final it = getLayer(name);
    if (it == null) throw ArgumentError('Required layer $name not found');
    return it as TileLayer;
  }

  void refresh(Layer layer) {
    final it = renderableLayers.firstWhere((it) => it.layer.id == layer.id);
    it.refreshCache();
  }

  void renderSingleLayer(Canvas canvas, Layer layer) {
    final it = renderableLayers.firstWhere((it) => it.layer.id == layer.id);
    it.render(canvas, camera);
  }

  void setLayerHidden(Layer layer) {
    final index = renderableLayers.indexWhere((it) => it.layer.id == layer.id);
    setLayerVisibility(index, visible: false);
  }

  int? intOptProp(String name) => map.intOptProp(name);

  int intProperty(String name) => map.intProperty(name);

  String stringProperty(String name) => map.stringProperty(name);
}

extension TiledComponentExtensions on TiledComponent {
  T? getLayer<T extends Layer>(String name) => tileMap.getLayer<T>(name);

  void setLayerHidden(String name) {
    final it = tileMap.getLayer(name);
    if (it != null) tileMap.setLayerHidden(it);
  }

  int? intOptProp(String name) => tileMap.intOptProp(name);

  int intProperty(String name) => tileMap.intProperty(name);

  String stringProperty(String name) => tileMap.stringProperty(name);

  Sprite tileSprite(int index) {
    final image = atlases().first.$2;
    final tiles = tileMap.map.tilesetByName('tiles');
    final tile = tiles.tiles[index];
    final rect = tiles.computeDrawRect(tile);
    final pos = Vector2(rect.left.toDouble(), rect.top.toDouble());
    final size = Vector2(rect.width.toDouble(), rect.height.toDouble());
    return Sprite(image, srcPosition: pos, srcSize: size);
  }
}

extension TiledMapExtensions on TiledMap {
  int? intOptProp(String name) {
    for (final it in properties) {
      if (it.name == name && it.type == PropertyType.int) {
        return it.value as int;
      }
    }
    return null;
  }

  int intProperty(String name) =>
      properties.firstWhere((it) => it.name == name).value as int;

  String stringProperty(String name) =>
      properties.firstWhere((it) => it.name == name).value.toString();
}

extension TiledObjectExtensions on TiledObject {
  String get spawnSpec =>
      properties.firstWhere((it) => it.name == 'SpawnSpec').value.toString();
}
