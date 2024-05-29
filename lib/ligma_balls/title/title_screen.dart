import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../components/common.dart';
import '../components/ligma_world.dart';
import '../components/soundboard.dart';
import '../util/bitmap_button.dart';
import '../util/bitmap_text.dart';
import '../util/fonts.dart';

class TitleScreen extends Component {
  @override
  onLoad() async {
    final titleImage = await game.loadSprite('title.png');
    final title = SpriteComponent(
      sprite: titleImage,
      position: Vector2(0, 0),
      size: Vector2(gameWidth, gameHeight),
      anchor: Anchor.topLeft,
    );
    title.opacity = 0;
    title.add(OpacityEffect.to(1, EffectController(duration: 0.2)));

    add(title);
    title.add(RectangleComponent(
      position: Vector2(0, 0),
      size: Vector2(gameWidth, 30),
      paint: Paint()..color = const Color(0xC0000000),
    ));
    title.add(BitmapText(
      text: 'Ligma Balls',
      position: Vector2(160, 4),
      font: fancyFont,
      scale: 2,
      anchor: Anchor.topCenter,
    ));

    for (final at in [250, 350, 450, 1000]) {
      Future.delayed(Duration(milliseconds: at)).then((_) {
        soundboard.play(Sound.ligma_balls);
      });
    }

    final buttonImage = await images.load('buttonbox.png');

    doAt(2500, () {
      title.add(BitmapText(
        text: 'DEFEND',
        position: Vector2(160, 40),
        font: fancyFont,
        scale: 2,
        anchor: Anchor.topCenter,
      ));
      soundboard.play(Sound.rock);
      soundboard.play(Sound.rock);
    });
    doAt(3500, () {
      title.add(BitmapText(
        text: 'PRIME\'S',
        position: Vector2(160, 60),
        font: fancyFont,
        scale: 2,
        anchor: Anchor.topCenter,
      ));
      soundboard.play(Sound.rock);
      soundboard.play(Sound.rock);
    });
    doAt(4500, () {
      title.add(BitmapText(
        text: 'MUSTACHE(TM)',
        position: Vector2(160, 80),
        font: fancyFont,
        scale: 2,
        anchor: Anchor.topCenter,
      ));
      soundboard.play(Sound.rock);
      soundboard.play(Sound.rock);

      title.add(BitmapButton(
        bgNinePatch: buttonImage,
        text: 'Start',
        position: Vector2(100, 250),
        size: Vector2(120, 32),
        cornerSize: 8,
        onTap: (it) {
          it.removeFromParent();
          title.add(OpacityEffect.to(0, EffectController(duration: 0.2)));
          doAt(200, () => world.loadLevel());
        },
      ));
    });
  }

  void doAt(int millis, Function() what) {
    Future.delayed(Duration(milliseconds: millis)).then((_) => what());
  }
}
