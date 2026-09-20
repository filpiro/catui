import 'package:catui/catui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a section titles its options and closes with a border', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CatSection(
            title: 'Tema',
            description: 'Come appare l\'app',
            children: [Text('Primo'), Text('Secondo')],
          ),
        ),
      ),
    );

    expect(find.text('Tema'), findsOneWidget);
    expect(find.text('Come appare l\'app'), findsOneWidget);

    // The title reads heavier than the options under it.
    final context = tester.element(find.text('Tema'));
    final theme = Theme.of(context);
    expect(
      tester.widget<Text>(find.text('Tema')).style,
      theme.textTheme.titleMedium,
    );

    // Two options don't run together.
    final first = tester.getBottomLeft(find.text('Primo')).dy;
    expect(tester.getTopLeft(find.text('Secondo')).dy, greaterThan(first));

    final border =
        (tester
                    .widget<Container>(find.byType(Container))
                    .decoration!
                as BoxDecoration)
            .border!;
    expect(border.bottom.color, theme.colorScheme.outlineVariant);
  });

  testWidgets('a setting row puts the control at the far edge', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 600,
            child: CatSettingRow(
              title: 'Riassunto',
              description: 'Usa un modello locale',
              trailing: Switch(value: true, onChanged: (_) {}),
            ),
          ),
        ),
      ),
    );

    final title = tester.getTopLeft(find.text('Riassunto'));
    expect(find.text('Usa un modello locale'), findsOneWidget);

    final control = tester.getTopRight(find.byType(Switch));
    expect(control.dx, closeTo(600, 1));
    expect(title.dx, lessThan(tester.getTopLeft(find.byType(Switch)).dx));

    // The control keeps its own width, it is not stretched across the row.
    expect(tester.getSize(find.byType(Switch)).width, lessThan(100));
  });
}
