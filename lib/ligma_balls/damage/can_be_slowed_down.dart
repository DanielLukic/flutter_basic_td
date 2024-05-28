import 'package:flame/components.dart';

mixin CanBeSlowedDown on HasTimeScale {
  double _slowDownSeconds = 0;

  bool get isSlowedDown => _slowDownSeconds > 0;

  void slowDown([double factor = 1]) {
    _slowDownSeconds = 2 * factor;
    timeScale = 0.1;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_slowDownSeconds > 0) {
      _slowDownSeconds -= dt;
    } else {
      timeScale = 1;
    }
  }
}
