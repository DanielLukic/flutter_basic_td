import 'dart:math';

import 'package:flame/camera.dart' hide Viewport;
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';

class FixedViewport extends MaxViewport implements ReadOnlyScaleProvider {
  //
  FixedViewport({
    required this.gameScreenSize,
    super.children,
  });

  final Vector2 gameScreenSize;

  @override
  Vector2 get virtualSize => gameScreenSize;

  @override
  Vector2 get scale => _transform.scale;

  final Transform2D _transform = Transform2D();

  final Vector2 _scaleVector = Vector2.all(1);

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onViewportResize() {
    super.onViewportResize();
    final scaleX = size.x ~/ gameScreenSize.x;
    final scaleY = size.y ~/ gameScreenSize.y;
    final scale = min(scaleX, scaleY);
    _scaleVector.setAll(scale.toDouble());
    _transform.scale = _scaleVector;
    final xOff = (size.x - gameScreenSize.x * scale) ~/ 2;
    final yOff = (size.y - gameScreenSize.y * scale) ~/ 2;
    _transform.position = Vector2(xOff.toDouble(), yOff.toDouble());
  }

  @override
  Vector2 globalToLocal(Vector2 point, {Vector2? output}) {
    final viewportPoint = super.globalToLocal(point, output: output);
    return _transform.globalToLocal(viewportPoint, output: output);
  }

  @override
  Vector2 localToGlobal(Vector2 point, {Vector2? output}) {
    final viewportPoint = _transform.localToGlobal(point, output: output);
    return super.localToGlobal(viewportPoint, output: output);
  }

  @override
  void transformCanvas(Canvas canvas) => canvas.transform2D(_transform);
}
