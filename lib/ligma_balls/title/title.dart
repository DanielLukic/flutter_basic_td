import 'dart:ui';

import 'package:flame/components.dart';
import 'package:ligma_balls/ligma_balls/components/common.dart';
import 'package:ligma_balls/ligma_balls/components/soundboard.dart';
import 'package:ligma_balls/ligma_balls/util/bitmap_button.dart';
import 'package:ligma_balls/ligma_balls/util/bitmap_text.dart';
import 'package:ligma_balls/ligma_balls/util/fonts.dart';

import '../components/ligma_world.dart';

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
    add(title);
    add(RectangleComponent(
      position: Vector2(0, 0),
      size: Vector2(gameWidth, 30),
      paint: Paint()..color = const Color(0xC0000000),
    ));
    add(BitmapText(
      text: 'Ligma Balls',
      position: Vector2(40, 0),
      font: fancyFont,
      scale: 2,
    ));

    for (final at in [250, 350, 450, 1000]) {
      Future.delayed(Duration(milliseconds: at)).then((_) {
        soundboard.play(Sound.ligma_balls);
      });
    }

    final buttonImage = await images.load('buttonbox.png');

    doAt(2500, () {
      add(BitmapText(
        text: 'DEFEND',
        position: Vector2(90, 40),
        font: fancyFont,
        scale: 2,
      ));
      soundboard.play(Sound.rock);
      soundboard.play(Sound.rock);
    });
    doAt(3500, () {
      add(BitmapText(
        text: 'PRIME\'S',
        position: Vector2(85, 60),
        font: fancyFont,
        scale: 2,
      ));
      soundboard.play(Sound.rock);
      soundboard.play(Sound.rock);
    });
    doAt(4500, () {
      add(BitmapText(
        text: 'MUSTACHE(TM)',
        position: Vector2(20, 80),
        font: fancyFont,
        scale: 2,
      ));
      soundboard.play(Sound.rock);
      soundboard.play(Sound.rock);

      add(BitmapButton(
        bgNinePatch: buttonImage,
        text: 'Start',
        position: Vector2(100, 250),
        size: Vector2(120, 32),
        cornerSize: 8,
        onTap: () => world.loadLevel(),
      ));
    });
  }

  void doAt(int millis, Function() what) {
    Future.delayed(Duration(milliseconds: millis)).then((_) => what());
  }
}
