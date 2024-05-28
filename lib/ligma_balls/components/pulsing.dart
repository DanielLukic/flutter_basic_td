import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../util/random.dart';

// TODO make Effect plus EffectTarget?

class Pulsing extends Component {
  @override
  onLoad() {
    if (parent is! ScaleProvider) {
      throw StateError('parent has to be a ScaleProvider');
    }
  }

  double _pulseTime = random.nextDouble();

  @override
  void update(double dt) {
    final it = (parent as ScaleProvider);

    final pulse = 1 + sin(_pulseTime * pi * 2) * 0.1;
    it.scale.x = pulse;
    it.scale.y = pulse;

    _pulseTime += dt;
  }
}
