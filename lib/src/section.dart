import 'package:flutter/material.dart';

import 'tokens.dart';

/// A block of a settings-style page: a title, an optional one-line
/// description, then the options, closed by a hairline bottom border.
///
/// The section owns every gap it needs, so a page is a list of sections and
/// restates no spacing and no text style of its own. Heavier than a
/// [CatSectionHeader], which labels a group inside a list.
class CatSection extends StatelessWidget {
  final String title;
  final String? description;

  /// The interactive options, spaced apart so two of them don't run together.
  final List<Widget> children;

  const CatSection({
    super.key,
    required this.title,
    this.description,
    required this.children,
  });

  /// Air above the title, then the body, then air before the border.
  static const padding = EdgeInsets.symmetric(vertical: AppTokens.gutter);

  /// Gap under the title block, and between two options.
  static const gap = 12.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: gap,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              if (description != null)
                Text(
                  description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          ...children,
        ],
      ),
    );
  }
}

/// One option inside a [CatSection]: label and optional description on the
/// left, the control on the right, edge to edge.
///
/// Replaces a zero-padded [SwitchListTile]: the tile's own paddings and text
/// styles fought the section's rhythm.
class CatSettingRow extends StatelessWidget {
  final String title;
  final String? description;
  final Widget trailing;

  const CatSettingRow({
    super.key,
    required this.title,
    this.description,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: AppTokens.gutter,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(title, style: theme.textTheme.bodyLarge),
              if (description != null)
                Text(
                  description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        // The control keeps its intrinsic width: a stretched switch or picker
        // is the bug, not the fix.
        trailing,
      ],
    );
  }
}
