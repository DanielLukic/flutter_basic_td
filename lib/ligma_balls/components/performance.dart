import 'package:flame/components.dart';
import 'package:flame/text.dart';

import 'common.dart';

class Ticker {
  Ticker({int ticks = 60}) : _step = 1 / ticks;

  final double _step;

  double _remainder = 0;

  generateTicksFor(double dt, void Function(double) tick) {
    // for historic reasons i prefer constant ticks... ‾\_('')_/‾
    dt += _remainder;
    while (dt >= _step) {
      tick(_step);
      dt -= _step;
    }
    _remainder = dt;
  }
}

class RenderTps<T extends TextRenderer> extends TextComponent
    with HasVisibility {
  RenderTps({
    super.position,
    super.size,
    super.scale,
    super.anchor,
  }) : super(priority: double.maxFinite.toInt()) {
    add(fpsComponent);
  }

  final fpsComponent = FpsComponent();

  @override
  bool get isVisible => debug;

  @override
  void update(double dt) => text = '${fpsComponent.fps.toStringAsFixed(0)} TPS';
}

class RenderFps<T extends TextRenderer> extends TextComponent
    with HasVisibility {
  //
  final int Function() _time;

  RenderFps({
    super.position,
    super.size,
    super.scale,
    super.anchor,
    super.key,
    required int Function() time,
  })  : _time = time,
        super(priority: double.maxFinite.toInt());

  @override
  bool get isVisible => debug;

  @override
  void update(double dt) {
    final fps = (1000 / _time()).toStringAsFixed(0);
    text = '$fps FPS';
  }
}
