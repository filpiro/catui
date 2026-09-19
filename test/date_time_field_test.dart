import 'package:catui/catui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget w) => MaterialApp(home: Scaffold(body: w));

void main() {
  testWidgets('shows placeholder when unset, formatted value when set', (t) async {
    await t.pumpWidget(_wrap(CatDateTimeField(
      label: 'Fine', placeholder: 'in corso', value: null, onChanged: (_) {},
    )));
    expect(find.text('in corso'), findsOneWidget);
    await t.pumpWidget(_wrap(CatDateTimeField(
      label: 'Fine', value: DateTime(2026, 1, 2, 3, 4), onChanged: (_) {},
    )));
    expect(find.text('02/01/2026 03:04'), findsOneWidget);
  });

  testWidgets('tap picks date then time and reports it', (t) async {
    DateTime? got;
    await t.pumpWidget(_wrap(CatDateTimeField(
      label: 'Inizio', value: DateTime(2026, 1, 2, 3, 4), onChanged: (v) => got = v,
    )));
    await t.tap(find.byType(CatDateTimeField));
    await t.pumpAndSettle();
    await t.tap(find.text('OK'));
    await t.pumpAndSettle();
    await t.tap(find.text('OK'));
    await t.pumpAndSettle();
    expect(got, DateTime(2026, 1, 2, 3, 4));
  });
}
