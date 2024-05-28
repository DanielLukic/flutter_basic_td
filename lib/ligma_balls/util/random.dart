import 'dart:math';

import 'package:flame/components.dart';

final random = Random();

Vector2 randomNormalizedVector() => Vector2.random(random) - Vector2.random();
