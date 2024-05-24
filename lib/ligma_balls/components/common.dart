import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

typedef IsTarget = bool Function(PositionComponent);

bool isAttacker(PositionComponent it) => it is Attacker;

enum ProjectileKind {
  ligmaBalls,
  netflix,
  twitchChat,
  vim,
}

mixin Attacker {}
mixin Defender {}

Vector2 randomNormalizedVector() => Vector2.random(random) - Vector2.random();

void repeat(int count, void Function(int) func) {
  for (var i = 0; i < count; i++) {
    func(i);
  }
}

bool debug = false;
bool dev = kDebugMode;

late Game game;
late Images images;

final random = Random();

final entityTileIndex = {
  'Goblin': 397,
  'Ghostling': 429,
  'Spider': 430,
  'Crab': 398,
  'Knight': 364,
  'NeoVim': 210,
  'Twitch': 212,
};

final entityInfo = {
  'Goblin': 'A Twitch Goblin. Asks stupid questions in\nTwitch chat to get on'
      ' prime\'s nerves.',
  'Ghostling': 'A Twitch Lurker. Careful: Throws Ligma Balls\nand knows VIM! '
      'Interested in tech stuff!',
  'NeoVim': 'The NeoVIM editor. When attackers are hit,\n'
      'they will not be able to exit VIM!',
  'Twitch': 'Use Twitch chat to throw intelligent \n'
      'opinions at attackers',
};
