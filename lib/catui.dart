/// Shared house style: catppuccin theme, design tokens and the atomic widgets
/// built on top of them.
///
/// The palette and icon packages are re-exported so a consuming app declares
/// `catui` only and stays version-locked to the same glyphs and flavors.
library;

export 'package:catppuccin_flutter/catppuccin_flutter.dart';
export 'package:lucide_icons_flutter/lucide_icons.dart';

export 'src/row_actions.dart';
export 'src/segmented.dart';
export 'src/theme.dart';
export 'src/tokens.dart';
