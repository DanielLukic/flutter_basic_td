import 'package:flame/components.dart';

import 'placement.dart';

mixin FreePlacementOnRemove on PositionComponent {
  @override
  void onRemove() {
    super.onRemove();
    placement.free(position);
  }
}
