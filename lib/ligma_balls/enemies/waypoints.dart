import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../components/common.dart';

late Waypoints waypoints;

class Waypoints extends Component with HasVisibility {
  final ObjectGroup group;

  final path = <(Vector2, double)>[];

  Waypoints(this.group) {
    for (final it in group.objects) {
      path.add((Vector2(it.x, it.y), 0));

      final comp = CircleComponent(
        position: Vector2(it.x, it.y),
        radius: 4,
        anchor: Anchor.center,
        paint: Paint()
          ..color = const Color(0x80000000)
          ..style = PaintingStyle.fill,
      );
      add(comp);

      final idx = group.objects.indexOf(it).toString();
      add(
        TextComponent(
          text: idx,
          position: Vector2(it.x, it.y),
          anchor: Anchor.center,
          scale: Vector2(0.25, 0.25),
        ),
      );
    }

    for (var i = 0; i < path.length - 1; i++) {
      final a = path[i];
      final b = path[i + 1];
      final dx = b.$1.x - a.$1.x;
      final dy = b.$1.y - a.$1.y;
      final dist = sqrt(dx * dx + dy * dy);
      path[i] = (a.$1, dist);
    }
  }

  void setPositionAt(double waytime, double speed, Vector2 out) {
    var at = waytime * speed;
    for (var i = 0; i < path.length - 1; i++) {
      final a = path[i];
      final b = path[i + 1];
      if (at <= a.$2) {
        final t = at / a.$2;
        out.x = lerpDouble(a.$1.x, b.$1.x, t) ?? a.$1.x;
        out.y = lerpDouble(a.$1.y, b.$1.y, t) ?? a.$1.y;
        return;
      }
      at -= a.$2;
    }
  }

  @override
  bool get isVisible => debug;
}
