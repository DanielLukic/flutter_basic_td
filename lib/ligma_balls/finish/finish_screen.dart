import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:ligma_balls/ligma_balls/components/common.dart';
import 'package:ligma_balls/ligma_balls/components/soundboard.dart';
import 'package:ligma_balls/ligma_balls/util/bitmap_text.dart';
import 'package:ligma_balls/ligma_balls/util/fonts.dart';

import '../components/ligma_world.dart';
import '../util/bitmap_button.dart';

class FinishScreen extends Component {
  @override
  onLoad() async {
    final titleImage = await game.loadSprite('finish.png');
    final title = SpriteComponent(
      sprite: titleImage,
      position: Vector2(0, 0),
      size: Vector2(gameWidth, gameHeight),
      anchor: Anchor.topLeft,
    );
    title.opacity = 0;
    title.add(OpacityEffect.to(1, EffectController(duration: 0.2)));
    add(title);

    const text = 'You successfully defended Prime\'s Mustache(TM)!';
    final words = text.split(' ');
    const delay = 400;
    var at = delay;
    double y = 75;
    for (final word in words) {
      final yy = y;
      doAt(at, () {
        title.add(BitmapText(
          text: word,
          position: Vector2(160, yy),
          font: fancyFont,
          scale: 2,
          anchor: Anchor.topCenter,
        ));
        soundboard.play(Sound.rock);
        soundboard.play(Sound.rock);
      });
      at += delay;
      y += 30;
    }

    final buttonImage = await images.load('buttonbox.png');

    doAt(at, () {
      soundboard.play(Sound.deez_nutz);
      title.add(BitmapButton(
        bgNinePatch: buttonImage,
        text: 'Yeah!',
        position: Vector2(100, y + 20),
        size: Vector2(120, 32),
        cornerSize: 8,
        onTap: (it) {
          it.removeFromParent();
          title.add(OpacityEffect.to(0, EffectController(duration: 0.2)));
          doAt(200, () => world.showTitle());
        },
      ));
    });
  }

  void doAt(int millis, Function() what) {
    Future.delayed(Duration(milliseconds: millis)).then((_) => what());
  }
}
