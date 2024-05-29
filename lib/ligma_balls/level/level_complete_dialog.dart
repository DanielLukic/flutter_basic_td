import 'package:flame/components.dart';

import '../components/common.dart';
import '../components/dialog.dart';
import '../components/ligma_world.dart';
import '../util/bitmap_button.dart';
import '../util/bitmap_text.dart';
import '../util/fonts.dart';

class LevelCompleteDialog extends Component {
  @override
  onLoad() async {
    final dialog = Dialog(
      await images.load('textbox.png'),
      width: 240,
      height: 100,
    );
    dialog.add(BitmapText(
      text: 'Level Complete',
      position: Vector2(40, 12),
      font: menuFont,
      scale: 0.5,
      tint: textColor,
    ));
    dialog.add(BitmapText(
      text: 'Prime\'s Moustache(TM) has been saved!',
      position: Vector2(30, 32),
      font: textFont,
      scale: 0.5,
      tint: successColor,
    ));
    dialog.add(BitmapButton(
      bgNinePatch: await images.load('buttonbox.png'),
      cornerSize: 8,
      text: 'Replay Level',
      position: Vector2(30, 60),
      size: Vector2(80, 24),
      fontScale: 0.5,
      shortcuts: ['Enter', ' '],
      onTap: (_) {
        world.loadLevel();
        parent?.remove(this);
      },
    ));
    dialog.add(BitmapButton(
      bgNinePatch: await images.load('buttonbox.png'),
      cornerSize: 8,
      text: 'Continue',
      position: Vector2(130, 60),
      size: Vector2(80, 24),
      fontScale: 0.5,
      shortcuts: ['r'],
      onTap: (_) {
        world.nextLevel();
        parent?.remove(this);
      },
    ));
    add(dialog);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;
}
