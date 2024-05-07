import 'package:dart_minilog/dart_minilog.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ligma_balls/viewport.dart';

import 'ligma_balls/components/common.dart';
import 'ligma_balls/components/ligma_world.dart';
import 'ligma_balls/components/performance.dart';
import 'ligma_balls/util/bitmap_font.dart';

late BitmapFont fancyFont;
late BitmapFont menuFont;
late BitmapFont textFont;

class LigmaBallsGame extends FlameGame<LigmaWorld>
    with
        HasCollisionDetection,
        HasKeyboardHandlerComponents,
        HasPerformanceTracker {
  //
  final _ticker = Ticker(ticks: 120);

  LigmaBallsGame() : super(world: world) {
    game = this;
    images = this.images;

    if (kIsWeb) logAnsi = false;
  }

  @override
  onGameResize(Vector2 size) {
    super.onGameResize(size);
    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewport = FixedViewport(
      gameScreenSize: Vector2(320, 320),
      children: [_ticks(), _frames()],
    );
  }

  _ticks() => RenderTps(
        scale: Vector2(0.25, 0.25),
        position: Vector2(0, 0),
        anchor: Anchor.topLeft,
      );

  _frames() => RenderFps(
        scale: Vector2(0.25, 0.25),
        position: Vector2(0, 8),
        anchor: Anchor.topLeft,
        time: () => renderTime,
      );

  @override
  onLoad() async {
    fancyFont = await BitmapFont.loadMono(
      images,
      'fonts/fancyfont.png',
      charWidth: 12,
      charHeight: 10,
    );
    menuFont = await BitmapFont.loadDst(
      images,
      assets,
      'fonts/menufont.png',
      charWidth: 24,
      charHeight: 24,
    );
    textFont = await BitmapFont.loadDst(
      images,
      assets,
      'fonts/textfont.png',
      charWidth: 12,
      charHeight: 12,
    );
    world.loadLevel(level);
  }

  int level = 1;

  @override
  update(double dt) =>
      _ticker.generateTicksFor(dt * _timeScale, (it) => super.update(it));

  double _timeScale = 1;

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyRepeatEvent) return KeyEventResult.skipRemainingHandlers;
    if (event is KeyDownEvent) {
      if (event.character == 'd') {
        debug = !debug;
        return KeyEventResult.handled;
      }
      if (event.character == 'r') {
        world.loadLevel(level);
        return KeyEventResult.handled;
      }
      if (event.character == 'S') {
        if (_timeScale > 0.125) _timeScale /= 2;
        return KeyEventResult.handled;
      }
      if (event.character == 's') {
        if (_timeScale < 4.0) _timeScale *= 2;
        return KeyEventResult.handled;
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
