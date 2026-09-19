import 'package:flutter/material.dart';

import 'tokens.dart';

/// The label that opens a group: a list's day or category header, a form's
/// section label.
///
/// One widget so every group in an app reads at the same weight and sits at
/// the same distance from what it introduces. [leading] is an identity mark
/// (a colour dot, an icon), [trailing] a value for the whole group (a total,
/// a count) pushed to the far edge.
class CatSectionHeader extends StatelessWidget {
  final Widget? leading;
  final String title;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  /// Header of a list section: indented to the list's own gutter.
  const CatSectionHeader({
    super.key,
    this.leading,
    required this.title,
    this.trailing,
  }) : padding = listPadding;

  /// Header inside a form or any already-padded column: same rhythm above and
  /// below, no gutter of its own.
  const CatSectionHeader.inline({
    super.key,
    this.leading,
    required this.title,
    this.trailing,
  }) : padding = inlinePadding;

  /// Generous above (the gap separates it from the previous group), tight
  /// below (it belongs to what follows). Sideways it matches a [HoverTile]'s
  /// content — the tile's inset fill plus the gutter inside it — so the header
  /// and the rows under it share both edges.
  static const listPadding = EdgeInsets.fromLTRB(
    AppTokens.tileMargin + AppTokens.gutter,
    16,
    AppTokens.tileMargin + AppTokens.gutter,
    4,
  );
  static const inlinePadding = EdgeInsets.fromLTRB(0, 16, 0, 4);

  /// Gap between [leading] and the title.
  static const double _leadingGap = 8;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleSmall;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: _leadingGap),
          ],
          // Expanded, not Flexible + Spacer: a Spacer is itself flex 1, so it
          // splits the free space with the title and the trailing value stops
          // halfway across the row instead of at the right edge.
          Expanded(
            child: Text(title, style: style, overflow: TextOverflow.ellipsis),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
