import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

const double tileSize = 16;

const double gameWidth = 320;
const double gameHeight = 320;
const double levelHeight = 15 * tileSize;

Paint pixelArtLayerPaint() => Paint()
  ..isAntiAlias = false
  ..filterQuality = FilterQuality.none;

typedef IsTarget = bool Function(PositionComponent);

bool isAttacker(PositionComponent it) => it is Attacker;

enum ProjectileKind {
  poop,
  ligmaBalls,
  netflix,
  ocaml,
  speech,
  sub,
  twitchChat,
  vim,
}

mixin Attacker {}
mixin Defender {}

void repeat(int count, void Function(int) func) {
  for (var i = 0; i < count; i++) {
    func(i);
  }
}

bool debug = false;
bool dev = kDebugMode;

late Game game;
late Images images;

final entityTileIndex = {
  'Diablo': 245,
  'Goblin': 397,
  'Ghostling': 429,
  'Subscriber': 400,
  'Dipshit': 244,
  'Lithium': 213,
  'NeoVim': 210,
  'Teej': 243,
  'Twitch': 212,
};

final entityInfo = {
  //
  // Attackers
  //
  'Diablo': 'The beast from hell!\nIs there even a way to stop this?!',
  'Goblin': 'Thor\'s Goblin. Asks stupid questions in\nTwitch chat to get on'
      ' prime\'s nerves.',
  'Ghostling': 'Thor\'s Lurker. Careful: Throws Ligma Balls\nand knows VIM! '
      'Interested in tech stuff!',
  'Subscriber': 'Thor\'s twitch subscribers are strong.\n'
      'Slow them down to hit them enough!',
  //
  // Defenders
  //
  'Dipshit': 'Dipshit.. well.. dips attackers in..\nwell.. shit!',
  'Lithium': 'Lithium gifts subs to attackers.\nPotentially converting them!',
  'NeoVim': 'The NeoVIM editor. When attackers are hit,\n'
      'they will not be able to exit VIM!',
  'Teej': 'Teej talks about Ocaml and Elixir, making\n'
      'attackers very sleepy!',
  'Twitch': 'Use Twitch chat to throw intelligent \n'
      'opinions at attackers',
};
