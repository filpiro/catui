import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';

import 'tokens.dart';

/// House colours Material's [ColorScheme] has no honest slot for.
class CatColors extends ThemeExtension<CatColors> {
  /// Fill behind a hovered neutral list row, at full strength; callers fade it
  /// in with alpha. `overlay0`, not `surface2`: one step off the page
  /// background disappears.
  final Color hoverSurface;

  const CatColors({required this.hoverSurface});

  /// Falls back to [ColorScheme.outline] (`overlay0` under [catTheme]) so a
  /// widget still works under a plain Material theme.
  static CatColors of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<CatColors>() ??
        CatColors(hoverSurface: theme.colorScheme.outline);
  }

  @override
  CatColors copyWith({Color? hoverSurface}) =>
      CatColors(hoverSurface: hoverSurface ?? this.hoverSurface);

  @override
  CatColors lerp(CatColors? other, double t) => other == null
      ? this
      : CatColors(
          hoverSurface: Color.lerp(hoverSurface, other.hoverSurface, t)!,
        );
}

/// The skin anything that lifts off the page wears: a dialog, a toast card.
/// One step off the page background (`mantle`), a hairline [ColorScheme.outlineVariant]
/// edge, the house corner — and no Material elevation tint, which is what makes
/// a stock dialog read as a different colour on every surface it opens over.
///
/// A [ShapeDecoration] because a card can hand it straight to a [Container]
/// while [catTheme] reads its `color` and `shape` for the dialog theme.
ShapeDecoration catSurfaceDecoration(ColorScheme scheme) => ShapeDecoration(
  color: scheme.surfaceContainerLow,
  shape: RoundedRectangleBorder(
    side: BorderSide(color: scheme.outlineVariant),
    borderRadius: BorderRadius.circular(AppTokens.radius),
  ),
);

/// Maps a catppuccin [flavor] onto a Material 3 [ThemeData].
///
/// The accent pair is the axis apps differ on; everything else is the house
/// style and is deliberately not parameterised. Both hues fall back to the
/// flavor's own, so a new app gets a coherent theme without stating a brand.
///
/// The foregrounds are not settable: [Flavor.base] contrasts against every
/// accent in the palette, in either brightness, because catppuccin accents all
/// sit mid-range. An accent from outside the palette is on its own.
ThemeData catTheme(
  Flavor flavor,
  Brightness brightness, {
  Color? primary,
  Color? secondary,
  bool? roundedPill,
}) {
  final scheme = ColorScheme(
    brightness: brightness,
    primary: primary ?? flavor.mauve,
    onPrimary: flavor.base,
    secondary: secondary ?? flavor.pink,
    onSecondary: flavor.base,
    // Muted container so NavigationRail indicator / selected segments stay subtle.
    secondaryContainer: flavor.surface1,
    onSecondaryContainer: flavor.text,
    error: flavor.red,
    onError: flavor.base,
    surface: flavor.base,
    onSurface: flavor.text,
    surfaceContainerLowest: flavor.crust,
    surfaceContainerLow: flavor.mantle,
    surfaceContainer: flavor.surface0,
    surfaceContainerHigh: flavor.surface1,
    surfaceContainerHighest: flavor.surface2,
    onSurfaceVariant: flavor.subtext0,
    outline: flavor.overlay0,
    outlineVariant: flavor.surface1,
  );

  const globalShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppTokens.radius)),
  );

  final buttonShape = roundedPill == true ? const StadiumBorder() : globalShape;
  final surface = catSurfaceDecoration(scheme);

  return ThemeData(
    colorScheme: scheme,
    extensions: [CatColors(hoverSurface: flavor.overlay0)],
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(iconSize: AppTokens.iconSize),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(shape: buttonShape),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(shape: buttonShape),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(shape: buttonShape),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(shape: buttonShape),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(shape: buttonShape),
    ),
    // The shared surface recipe, so a dialog and a toast are the same object.
    // The tint is off: the border does the lifting, not an elevation wash.
    dialogTheme: DialogThemeData(
      backgroundColor: surface.color,
      surfaceTintColor: Colors.transparent,
      shape: surface.shape,
    ),
    // Outlined everywhere, set once: a field in a dialog and a field on a page
    // are the same control, so no screen states its own border.
    inputDecorationTheme: const InputDecorationThemeData(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppTokens.radius)),
      ),
    ),
  );
}
