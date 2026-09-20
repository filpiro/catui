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

  /// The closing border. Off on a page's last section: a hairline with nothing
  /// under it separates the page from the window.
  final bool divider;

  const CatSection({
    super.key,
    required this.title,
    this.description,
    required this.children,
    this.divider = true,
  });

  /// Air above the title, then the body, then air before the border. One step
  /// up from [_gap], so two sections read further apart than two options
  /// inside one.
  static const _padding = EdgeInsets.symmetric(vertical: AppTokens.pagePadding);

  /// Gap under the title block, and between two options.
  static const _gap = AppTokens.gutter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        border: divider
            ? Border(
                bottom: BorderSide(color: theme.colorScheme.outlineVariant),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: _gap,
        children: [
          _Label(
            title: title,
            description: description,
            style: theme.textTheme.titleMedium,
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
      spacing: AppTokens.gutter,
      children: [
        Expanded(
          child: _Label(
            title: title,
            description: description,
            style: theme.textTheme.bodyLarge,
          ),
        ),
        // The control keeps its intrinsic width: a stretched switch or picker
        // is the bug, not the fix.
        trailing,
      ],
    );
  }
}

/// A title with an optional description under it, muted and one step smaller.
/// The two widgets above differ only in the title's weight.
class _Label extends StatelessWidget {
  final String title;
  final String? description;
  final TextStyle? style;

  const _Label({required this.title, this.description, this.style});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Text(title, style: style),
        if (description != null)
          Text(
            description!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
