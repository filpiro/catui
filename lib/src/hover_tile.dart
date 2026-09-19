import 'package:flutter/material.dart';

import 'theme.dart';
import 'tokens.dart';

/// Tracks mouse hover and hands [builder] a 0..1 fade value that eases over
/// [AppTokens.hoverFade]. Every hoverable surface (list rows, board tiles)
/// drives its highlight from here so they all fade alike.
class HoverFade extends StatefulWidget {
  /// [t] is the eased hover amount; [hovered] the raw state; [child] is
  /// [child] passed through, built once.
  final Widget Function(
    BuildContext context,
    double t,
    bool hovered,
    Widget? child,
  )
  builder;
  final Widget? child;

  const HoverFade({super.key, required this.builder, this.child});

  @override
  State<HoverFade> createState() => _HoverFadeState();
}

class _HoverFadeState extends State<HoverFade> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: TweenAnimationBuilder<double>(
        duration: AppTokens.hoverFade,
        tween: Tween(end: _hover ? 1.0 : 0.0),
        child: widget.child,
        builder: (context, t, child) =>
            widget.builder(context, t, _hover, child),
      ),
    );
  }
}

/// List row with mouse-hover highlight and hover-only actions. The actions
/// also appear while focus is inside the row, so Tab never lands on an
/// invisible button.
class HoverTile extends StatefulWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;

  /// Revealed on hover or focus; space is reserved so rows don't shift.
  final List<Widget> actions;
  final VoidCallback? onTap;
  final bool dense;

  const HoverTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.onTap,
    this.dense = false,
  });

  @override
  State<HoverTile> createState() => _HoverTileState();
}

class _HoverTileState extends State<HoverTile> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final highlight = CatColors.of(context).hoverSurface;
    // The highlight is driven from HoverFade rather than ListTile's own
    // hoverColor: InkResponse ignores hover when every callback is null, and
    // rows that aren't tappable still need to light up.
    return HoverFade(
      builder: (context, t, hover, _) {
        final revealed = hover || _focused;
        // The fill is inset and rounded, so it reads as a tile rather than a
        // full-bleed wash. The ListTile's own 16 gutter then puts the content
        // at tileMargin + gutter, where a CatSectionHeader's text also sits.
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTokens.tileMargin),
          child: ListTile(
            dense: widget.dense,
            tileColor: highlight.withValues(alpha: t),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppTokens.tileRadius),
              ),
            ),
            // Stock ink hover would stack on top of the color above.
            hoverColor: Colors.transparent,
            leading: widget.leading,
            title: widget.title,
            subtitle: widget.subtitle,
            onTap: widget.onTap,
            trailing: widget.actions.isEmpty
                ? null
                : Focus(
                    // Focus-within tracker only: never a stop itself.
                    canRequestFocus: false,
                    skipTraversal: true,
                    onFocusChange: (f) => setState(() => _focused = f),
                    child: IgnorePointer(
                      ignoring: !revealed,
                      child: Opacity(
                        opacity: revealed ? 1 : 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: widget.actions,
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
