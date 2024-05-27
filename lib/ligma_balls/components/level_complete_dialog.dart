import 'package:flame/components.dart';

import 'bitmap_button.dart';
import 'bitmap_text.dart';
import 'common.dart';
import 'dialog.dart';
import 'ligma_world.dart';

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
      onTap: () {
        world.loadLevel();
        parent?.remove(this);
      },
    ));
    dialog.add(BitmapButton(
      bgNinePatch: await images.load('buttonbox.png'),
      cornerSize: 8,
      text: 'Next Level',
      position: Vector2(130, 60),
      size: Vector2(80, 24),
      fontScale: 0.5,
      shortcuts: ['r'],
      onTap: () {
        world.nextLevel();
        parent?.remove(this);
      },
    ));
    add(dialog);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;
}
