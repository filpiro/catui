import 'package:flutter/material.dart';

import 'tokens.dart';

/// The frame every tab sits in: optional toolbar above, optional footer below,
/// optional FAB, optional max width, then the body. Tabs carry no title of
/// their own; the navigation already names them.
///
/// A list body brings its own scrolling and [AppTokens.fabClearance]. Set
/// [scroll] for a form or document body: it is wrapped in a scroll view with
/// [AppTokens.pagePadding], so a short window scrolls instead of overflowing.
class CatPage extends StatelessWidget {
  final Widget? toolbar;
  final Widget? footer;
  final Widget? fab;

  /// Content is top-left aligned and capped to this width when set.
  final double? maxWidth;
  final bool scroll;
  final Widget body;

  const CatPage({
    super.key,
    this.toolbar,
    this.footer,
    this.fab,
    this.maxWidth,
    this.scroll = false,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (toolbar != null)
          Padding(padding: AppTokens.toolbarPadding, child: toolbar),
        Expanded(
          child: scroll
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTokens.pagePadding),
                  child: body,
                )
              : body,
        ),
        if (footer != null)
          Padding(padding: AppTokens.toolbarPadding, child: footer),
      ],
    );
    if (maxWidth != null) {
      content = Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth!),
          child: content,
        ),
      );
    }
    return Scaffold(floatingActionButton: fab, body: content);
  }
}
