import 'package:flutter/material.dart';

import 'tokens.dart';

/// Small filled label: a status badge next to a title, or a keyboard key-cap
/// in a shortcut list. Same corner as every other surface, so a badge sitting
/// on a row reads as part of the house style rather than a stray pill.
///
/// Colours default to the neutral container pair; pass [background] /
/// [foreground] for a badge that has to carry meaning (accent, error).
class CatTag extends StatelessWidget {
  final String label;
  final Color? background;
  final Color? foreground;
  final TextAlign? textAlign;

  const CatTag(
    this.label, {
    super.key,
    this.background,
    this.foreground,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: background ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTokens.radius),
      ),
      child: Text(
        label,
        textAlign: textAlign,
        // labelMedium, not labelSmall: a key-cap has to stay readable as the
        // only text in its column, and a badge at 12sp still reads as a badge.
        style: theme.textTheme.labelMedium?.copyWith(
          color: foreground ?? theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
