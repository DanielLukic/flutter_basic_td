import 'package:dart_minilog/dart_minilog.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ligma_balls/ligma_balls/ligma_world.dart';

import 'components/common.dart';
import 'components/ligma_world.dart';
import 'components/performance.dart';
import 'components/soundboard.dart';
import 'util/bitmap_font.dart';
import 'util/fonts.dart';

class LigmaBallsGame extends FlameGame<LigmaWorld>
    with
        HasCollisionDetection,
        HasKeyboardHandlerComponents,
        HasPerformanceTracker {
  //
  final _ticker = Ticker(ticks: 120);

  LigmaBallsGame() : super(world: ActualLigmaWorld()) {
    game = this;
    world = this.world;
    images = this.images;

    if (kIsWeb) logAnsi = false;
  }

  @override
  onGameResize(Vector2 size) {
    super.onGameResize(size);
    camera = CameraComponent.withFixedResolution(
      width: gameWidth,
      height: gameHeight,
      hudComponents: [_ticks(), _frames()],
    );
    camera.viewfinder.anchor = Anchor.topLeft;
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
    soundboard.preload();

    fancyFont = await BitmapFont.loadDst(
      images,
      assets,
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
    if (dev) {
      world.loadLevel();
    } else {
      world.showTitle();
    }
  }

  @override
  update(double dt) =>
      _ticker.generateTicksFor(dt * _timeScale, (it) => super.update(it));

  double _timeScale = 1;

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (!dev) {
      return super.onKeyEvent(event, keysPressed);
    }
    if (event is KeyRepeatEvent) {
      return KeyEventResult.skipRemainingHandlers;
    }
    if (event is KeyDownEvent) {
      if (event.character == 'd') {
        debug = !debug;
        return KeyEventResult.handled;
      }
      if (event.character == 'f') {
        world.showFinish();
        return KeyEventResult.handled;
      }
      if (event.character == 'L') {
        world.prevLevel();
        return KeyEventResult.handled;
      }
      if (event.character == 'l') {
        world.nextLevel();
        return KeyEventResult.handled;
      }
      if (event.character == 'r') {
        world.loadLevel();
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
      if (event.character == 't') {
        world.showTitle();
        return KeyEventResult.handled;
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
