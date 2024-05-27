import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/cache.dart';

extension BitmapFontExtensions on BitmapFont {
  void tint(Color color) {
    paint.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
  }
}

abstract class BitmapFont {
  static loadMono(
    Images images,
    String filename, {
    required int charWidth,
    required int charHeight,
  }) async {
    final image = await images.load(filename);
    return MonospacedBitmapFont(image, charWidth, charHeight);
  }

  static loadDst(
    Images images,
    AssetsCache assets,
    String filename, {
    required int charWidth,
    required int charHeight,
  }) async {
    final image = await images.load(filename);
    final dst = await assets.readBinaryFile(
      filename.replaceFirst('.png', '.dst'),
    );
    return DstBitmapFont(image, dst, charWidth, charHeight);
  }

  double scale = 1;
  double lineSpacing = 2;
  Paint paint = Paint();

  double lineHeight();

  double lineWidth(String line);

  drawString(Canvas canvas, double x, double y, String string);

  drawText(Canvas canvas, double x, double y, String text);
}

class MonospacedBitmapFont extends BitmapFont {
  final Image _image;
  final int _charWidth;
  final int _charHeight;
  final int _charsPerRow;

  MonospacedBitmapFont(this._image, this._charWidth, this._charHeight)
      : _charsPerRow = _image.width ~/ _charWidth;

  final _cache = <int, Rect>{};

  Rect _cachedSrc(int charCode) => _cache.putIfAbsent(charCode, () {
        final x = (charCode - 32) % _charsPerRow;
        final y = (charCode - 32) ~/ _charsPerRow;
        final rect = Rect.fromLTWH(
          x.toDouble() * _charWidth,
          y.toDouble() * _charHeight,
          _charWidth.toDouble(),
          _charHeight.toDouble(),
        );
        return rect;
      });

  Rect _dst(double x, double y) => Rect.fromLTWH(
        x.toDouble(),
        y.toDouble(),
        _charWidth.toDouble() * scale,
        _charHeight.toDouble() * scale,
      );

  @override
  double lineHeight() => _charHeight * scale;

  @override
  double lineWidth(String line) => line.length * _charWidth * scale;

  @override
  drawString(Canvas canvas, double x, double y, String string) {
    for (final c in string.codeUnits) {
      final src = _cachedSrc(c);
      final dst = _dst(x, y);
      canvas.drawImageRect(_image, src, dst, paint);
      x += _charWidth * scale;
    }
  }

  @override
  drawText(Canvas canvas, double x, double y, String text) {
    final lines = text.split('\n');
    for (final line in lines) {
      drawString(canvas, x, y, line);
      y += _charHeight * scale + lineSpacing;
    }
  }
}

class DstBitmapFont extends BitmapFont {
  final Image _image;
  final Uint8List _dst;
  final int _charWidth;
  final int _charHeight;
  final int _charsPerRow;

  DstBitmapFont(this._image, this._dst, this._charWidth, this._charHeight)
      : _charsPerRow = _image.width ~/ _charWidth;

  final _cache = <int, Rect>{};

  Rect _cachedSrc(int charCode) => _cache.putIfAbsent(charCode, () {
        final x = (charCode - 32) % _charsPerRow;
        final y = (charCode - 32) ~/ _charsPerRow;
        final width = _dst[charCode - 32];
        final rect = Rect.fromLTWH(
          x.toDouble() * _charWidth,
          y.toDouble() * _charHeight,
          width.toDouble(),
          _charHeight.toDouble(),
        );
        return rect;
      });

  Rect _dstRect(double x, double y, double width) => Rect.fromLTWH(
        x.toDouble(),
        y.toDouble(),
        width * scale,
        _charHeight.toDouble() * scale,
      );

  @override
  double lineHeight() => _charHeight * scale;

  @override
  double lineWidth(String line) {
    double x = 0;
    for (final c in line.codeUnits) {
      final src = _cachedSrc(c);
      x += src.width * scale;
    }
    return x;
  }

  @override
  drawString(Canvas canvas, double x, double y, String string) {
    for (final c in string.codeUnits) {
      final src = _cachedSrc(c);
      final dst = _dstRect(x, y, src.width);
      canvas.drawImageRect(_image, src, dst, paint);
      x += src.width * scale;
    }
  }

  @override
  drawText(Canvas canvas, double x, double y, String text) {
    final lines = text.split('\n');
    for (final line in lines) {
      drawString(canvas, x, y, line);
      y += _charHeight * scale + lineSpacing;
    }
  }
}
