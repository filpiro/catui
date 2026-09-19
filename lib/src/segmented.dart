import 'package:flutter/material.dart';

import 'tokens.dart';

/// A single-choice group drawn as separate buttons instead of one joined bar.
///
/// Material's [SegmentedButton] cannot do this: its render box lays segments
/// out edge to edge and paints a single outer border with dividers, none of
/// which is reachable from [ButtonStyle], so the gap has to come from not
/// using it. Selected reads as [FilledButton], the rest as [OutlinedButton],
/// which keeps the whole thing on the house button theme for free.
class CatSegmented<T> extends StatelessWidget {
  /// Value to label, in display order.
  final Map<T, String> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  /// Optional icon per value. A segment with an icon shows only the icon and
  /// uses its label as tooltip and semantic label.
  final Map<T, IconData> icons;

  const CatSegmented({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.icons = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppTokens.segmentGap,
      runSpacing: AppTokens.segmentGap,
      children: [
        for (final MapEntry(key: value, value: label) in segments.entries)
          _segment(value, label),
      ],
    );
  }

  Widget _segment(T value, String label) {
    final icon = icons[value];
    final child = icon == null
        ? Text(label)
        : Icon(icon, size: 18, semanticLabel: label);
    void onPressed() => onChanged(value);
    final button = value == selected
        ? FilledButton(onPressed: onPressed, child: child)
        : OutlinedButton(onPressed: onPressed, child: child);
    return icon == null ? button : Tooltip(message: label, child: button);
  }
}
