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

  const CatSegmented({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppTokens.segmentGap,
      runSpacing: AppTokens.segmentGap,
      children: [
        for (final MapEntry(key: value, value: label) in segments.entries)
          value == selected
              ? FilledButton(
                  onPressed: () => onChanged(value),
                  child: Text(label),
                )
              : OutlinedButton(
                  onPressed: () => onChanged(value),
                  child: Text(label),
                ),
      ],
    );
  }
}
