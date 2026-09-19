import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:catui/catui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('focusing a row action reveals the actions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HoverTile(
            title: const Text('row'),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            ],
          ),
        ),
      ),
    );
    double opacity() => tester.widget<Opacity>(find.byType(Opacity)).opacity;
    expect(opacity(), 0);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(opacity(), 1);

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    expect(opacity(), 0);
  });

  testWidgets('hovering fills with hoverSurface, inset and rounded', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: catTheme(catppuccin.mocha, Brightness.dark),
        home: const Scaffold(body: HoverTile(title: Text('row'))),
      ),
    );
    ListTile tile() => tester.widget<ListTile>(find.byType(ListTile));
    expect(tile().tileColor?.a, 0);

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: tester.getCenter(find.text('row')));
    addTearDown(gesture.removePointer);
    await tester.pumpAndSettle();

    expect(
      tile().tileColor,
      catppuccin.mocha.overlay0.withValues(alpha: 1),
      reason: 'the fill is the house hoverSurface, not surface2',
    );
    expect(
      tile().shape,
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppTokens.tileRadius)),
      ),
    );
    // Inset from both page edges by tileMargin, content a gutter inside that,
    // which is where a CatSectionHeader's own text sits on both sides.
    final page = tester.getSize(find.byType(Scaffold)).width;
    expect(tester.getTopLeft(find.byType(ListTile)).dx, AppTokens.tileMargin);
    expect(
      tester.getTopRight(find.byType(ListTile)).dx,
      page - AppTokens.tileMargin,
    );
    expect(
      tester.getTopLeft(find.text('row')).dx,
      CatSectionHeader.listPadding.left,
    );
  });

  testWidgets('a header and a row end at the same right edge', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: catTheme(catppuccin.mocha, Brightness.dark),
        home: const Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CatSectionHeader(title: 'day', trailing: Text('8:00')),
              HoverTile(title: Text('row'), actions: [Text('act')]),
            ],
          ),
        ),
      ),
    );
    expect(
      tester.getTopRight(find.text('8:00')).dx,
      tester.getTopRight(find.text('act')).dx,
    );
  });
}
