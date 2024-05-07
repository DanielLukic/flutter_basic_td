// import 'package:flame/components.dart';
//
// import '../ligma_balls_game.dart';
//
// class StarComponent extends SpriteAnimationComponent
//     with HasGameReference<LigmaBallsGame> {
//   final int _speed;
//   late double _dy;
//
//   StarComponent({super.animation, super.position, int speed = 0})
//       : _speed = speed,
//         super(priority: -10) {
//     _setRandomSpeed();
//   }
//
//   void _setRandomSpeed() {
//     // _dy = 50 + _speed * random.nextDouble() * 100;
//   }
//
//   @override
//   void update(double dt) {
//     super.update(dt);
//     y += dt * _dy;
//     if (y >= game.size.y) {
//       y -= game.size.y + 10;
//       _setRandomSpeed();
//     }
//   }
// }
