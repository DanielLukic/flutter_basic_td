import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../components/common.dart';
import '../util/random.dart';

late Waypoints waypoints;

class FollowWaypoints extends Component {
  double _waytime = 0;

  @override
  onLoad() {
    if (parent is! PositionComponent) {
      throw StateError('parent has to be a PositionComponent');
    }
  }

  Path? chosenPath;

  @override
  void update(double dt) {
    chosenPath ??= waypoints.choosePath();

    final position = (parent as PositionComponent).position;
    waypoints.setPositionAt(chosenPath!, _waytime, 25, position);
    _waytime += dt;
    if (waypoints.reachedEnd(chosenPath!, _waytime, 25)) {
      parent?.add(RemoveEffect(delay: 0.1));
    }
  }
}

typedef Path = List<(Vector2, double)>;

class Waypoints extends Component with HasVisibility {
  final ObjectGroup group;

  late final List<Path> paths;

  Path choosePath() => paths.random(random);

  Waypoints(this.group) {
    if (group.objects.isEmpty) {
      throw ArgumentError('Waypoints layer has to contain Points or Polylines');
    }
    if (group.objects.first.isPoint) {
      final points = group.objects.map((it) => it.position);
      paths = [_makePath(points.toList())];
    } else {
      paths = [];
      for (final p in group.objects) {
        if (!p.isPolyline) {
          throw ArgumentError('Unsupported waypoint type: ${p.type}');
        }
        final points = p.polyline.map((it) => Vector2(
              p.position.x + it.x,
              p.position.y + it.y,
            ));
        paths.add(_makePath(points.toList()));
      }
    }
  }

  Path _makePath(List<Vector2> points) {
    final Path path = [];
    for (final it in points) {
      path.add((it, 0));

      final comp = CircleComponent(
        position: Vector2(it.x, it.y),
        radius: 4,
        anchor: Anchor.center,
        paint: Paint()
          ..color = const Color(0x80000000)
          ..style = PaintingStyle.fill,
      );
      add(comp);

      final idx = points.indexOf(it).toString();
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

    return path;
  }

  void setPositionAt(Path path, double waytime, double speed, Vector2 out) {
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

  bool reachedEnd(Path path, double waytime, double speed) {
    var at = waytime * speed;
    for (var i = 0; i < path.length - 1; i++) {
      final a = path[i];
      if (at <= a.$2) return false;
      at -= a.$2;
    }
    return true;
  }

  @override
  bool get isVisible => debug;
}
