import 'dart:ui';

import '../components/common.dart';

class NinePatchImage {
  final Image image;
  final int cornerSize;

  late final double _size = cornerSize.toDouble();

  NinePatchImage(this.image, {this.cornerSize = 16});

  Rect get _topLeft => Rect.fromLTWH(0, 0, _size, _size);

  Rect get _top => Rect.fromLTWH(_size, 0, _size, _size);

  Rect get _topRight => Rect.fromLTWH(_size * 2, 0, _size, _size);

  Rect get _left => Rect.fromLTWH(0, _size, _size, _size);

  Rect get _right => Rect.fromLTWH(_size * 2, _size, _size, _size);

  Rect get _center => Rect.fromLTWH(_size, _size, _size, _size);

  Rect get _bottomLeft => Rect.fromLTWH(0, _size * 2, _size, _size);

  Rect get _bottom => Rect.fromLTWH(_size, _size * 2, _size, _size);

  Rect get _bottomRight => Rect.fromLTWH(_size * 2, _size * 2, _size, _size);

  final paint = pixelArtLayerPaint();

  draw(Canvas canvas, double left, double top, double width, double height) {
    if (width ~/ cornerSize * cornerSize != width) {
      throw ArgumentError('must be multiple of $cornerSize: $width');
    }
    if (height ~/ cornerSize * cornerSize != height) {
      throw ArgumentError('must be multiple of $cornerSize: $height');
    }

    final yTiles = height ~/ cornerSize;
    final xTiles = width ~/ cornerSize;
    final yLast = yTiles - 1;
    final xLast = xTiles - 1;

    Rect dst;
    for (var y = 0; y < yTiles; y++) {
      for (var x = 0; x < xTiles; x++) {
        final Rect src;
        if (x == 0 && y == 0) {
          src = _topLeft;
        } else if (x == xLast && y == 0) {
          src = _topRight;
        } else if (x == 0 && y == yLast) {
          src = _bottomLeft;
        } else if (x == xLast && y == yLast) {
          src = _bottomRight;
        } else if (y == 0) {
          src = _top;
        } else if (y == yLast) {
          src = _bottom;
        } else if (x == 0) {
          src = _left;
        } else if (x == xLast) {
          src = _right;
        } else {
          src = _center;
        }

        final yy = top + y * cornerSize;
        final xx = left + x * cornerSize;
        dst = Rect.fromLTWH(xx, yy, _size, _size);

        canvas.drawImageRect(image, src, dst, paint);
      }
    }
  }
}
