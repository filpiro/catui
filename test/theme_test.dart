import 'package:catui/catui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accent falls back to the flavor, and each hue overrides alone', () {
    final stock = catTheme(catppuccin.mocha, Brightness.dark).colorScheme;
    expect(stock.primary, catppuccin.mocha.mauve);
    expect(stock.secondary, catppuccin.mocha.pink);

    // The common case: an app states a brand primary and leaves secondary be.
    final branded = catTheme(
      catppuccin.mocha,
      Brightness.dark,
      primary: catppuccin.mocha.green,
    ).colorScheme;
    expect(branded.primary, catppuccin.mocha.green);
    expect(branded.secondary, catppuccin.mocha.pink);

    // Foregrounds are the flavor's, never the accent's.
    expect(branded.onPrimary, catppuccin.mocha.base);
    expect(branded.onSecondary, catppuccin.mocha.base);
  });

  testWidgets('a bare TextField is outlined with the house radius', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: catTheme(catppuccin.latte, Brightness.light),
        home: const Scaffold(body: TextField()),
      ),
    );
    final border = tester
        .widget<InputDecorator>(find.byType(InputDecorator))
        .decoration
        .border;
    expect(border, isA<OutlineInputBorder>());
    expect(
      (border as OutlineInputBorder).borderRadius,
      BorderRadius.circular(AppTokens.radius),
    );
  });
}
