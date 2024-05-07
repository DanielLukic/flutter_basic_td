// import 'package:flame/components.dart';
// import 'package:flame/sprite.dart';
// import 'package:ligma_balls/ligma_balls_game.dart';
//
// class StarBackGroundCreator extends Component
//     with HasGameReference<LigmaBallsGame> {
//   late final SpriteSheet spriteSheet;
//
//   @override
//   Future<void> onLoad() async {
//     spriteSheet = SpriteSheet.fromColumnsAndRows(
//       image: await game.images.load('stars.png'),
//       rows: 4,
//       columns: 4,
//     );
//     _createInitialStars();
//   }
//
//   void _createInitialStars() {
//     const stripes = 20;
//     final stripeHeight = game.size.y / stripes;
//     for (var i = 0; i < stripes; i++) {
//       _createRowOfStars(i * stripeHeight, stripeHeight);
//     }
//   }
//
//   void _createRowOfStars(double y, double delta) {
//     const vStripes = 10;
//     final stripeWidth = game.size.x / vStripes;
//
//     for (var i = 0; i < vStripes; i++) {
//       // _createStarAt(
//       //   stripeWidth * i + (random.nextDouble() * stripeWidth),
//       //   y + (random.nextDouble() * delta),
//       // );
//     }
//   }
//
//   void _createStarAt(double x, double y) {
//     // final row = random.nextInt(3);
//     // final animation = spriteSheet.createAnimation(
//     //   row: row,
//     //   to: 4,
//     //   stepTime: 0.1,
//     // )..variableStepTimes = [2 + 58 * random.nextDouble(), 0.1, 0.1, 0.1];
//     //
//     // world.add(StarComponent(
//     //     animation: animation, position: Vector2(x, y), speed: row));
//   }
// }
