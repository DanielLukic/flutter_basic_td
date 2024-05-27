import 'dart:math';
import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

import '../util/bitmap_font.dart';

const double tileSize = 16;

const textColor = Color(0xFFffcc80);
const successColor = Color(0xFF20ff10);
const errorColor = Color(0xFFff2010);

const double gameWidth = 320;
const double gameHeight = 320;
const double levelHeight = 15 * tileSize;

Paint pixelArtLayerPaint() => Paint()
  ..isAntiAlias = false
  ..filterQuality = FilterQuality.none;

typedef IsTarget = bool Function(PositionComponent);

bool isAttacker(PositionComponent it) => it is Attacker;

enum ProjectileKind {
  ligmaBalls,
  netflix,
  ocaml,
  speech,
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

late BitmapFont fancyFont;
late BitmapFont menuFont;
late BitmapFont textFont;

late Game game;
late Images images;

final random = Random();

final entityTileIndex = {
  'Goblin': 397,
  'Ghostling': 429,
  'Subscriber': 400,
  'Spider': 430,
  'Crab': 398,
  'Knight': 364,
  'NeoVim': 210,
  'Teej': 243,
  'Twitch': 212,
};

final entityInfo = {
  //
  // Attackers
  //
  'Goblin': 'A Twitch Goblin. Asks stupid questions in\nTwitch chat to get on'
      ' prime\'s nerves.',
  'Ghostling': 'A Twitch Lurker. Careful: Throws Ligma Balls\nand knows VIM! '
      'Interested in tech stuff!',
  'Subscriber': 'Thor\'s twitch subscribers are strong.\n'
      'Slow them down to hit them enough!',
  //
  // Defenders
  //
  'NeoVim': 'The NeoVIM editor. When attackers are hit,\n'
      'they will not be able to exit VIM!',
  'Teej': 'Teej talks about Ocaml and Elixir, making\n'
      'attackers very sleepy!',
  'Twitch': 'Use Twitch chat to throw intelligent \n'
      'opinions at attackers',
};
