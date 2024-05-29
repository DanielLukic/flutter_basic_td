import 'package:flame/components.dart';

import '../components/common.dart';
import '../components/dialog.dart';
import '../components/ligma_world.dart';
import '../util/bitmap_button.dart';
import '../util/bitmap_text.dart';
import '../util/fonts.dart';

class GameOverDialog extends Component {
  @override
  onLoad() async {
    final dialog = Dialog(
      await images.load('textbox.png'),
      width: 240,
      height: 100,
    );
    dialog.add(BitmapText(
      text: 'Game Over',
      position: Vector2(68, 12),
      font: menuFont,
      scale: 0.5,
      tint: textColor,
    ));
    dialog.add(BitmapText(
      text: 'Prime\'s Moustache(TM) has been destroyed!',
      position: Vector2(16, 32),
      font: textFont,
      scale: 0.5,
      tint: errorColor,
    ));
    dialog.add(BitmapButton(
      bgNinePatch: await images.load('buttonbox.png'),
      cornerSize: 8,
      text: 'Retry Level',
      position: Vector2(80, 60),
      size: Vector2(80, 24),
      fontScale: 0.5,
      shortcuts: ['Enter', ' '],
      onTap: (_) {
        world.loadLevel();
        parent?.remove(this);
      },
    ));
    add(dialog);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;
}
