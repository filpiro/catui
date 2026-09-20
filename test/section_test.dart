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
                    .widget<Container>(
                      find.descendant(
                        of: find.byType(CatSection),
                        matching: find.byType(Container),
                      ),
                    )
                    .decoration!
                as BoxDecoration)
            .border!;
    expect(border.bottom.color, theme.colorScheme.outlineVariant);
  });

  testWidgets('the last section closes without a hairline', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CatSection(
            title: 'Ultima',
            divider: false,
            children: [Text('Opzione')],
          ),
        ),
      ),
    );

    final decoration =
        tester
                .widget<Container>(
                  find.descendant(
                    of: find.byType(CatSection),
                    matching: find.byType(Container),
                  ),
                )
                .decoration!
            as BoxDecoration;
    expect(decoration.border, isNull);
  });

  testWidgets('prose keeps the document cap however wide the section is', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 1400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CatSection(
                  title: 'Conservazione',
                  description: 'Una descrizione abbastanza lunga da '
                      'superare la larghezza massima di una colonna di testo '
                      'quando la finestra è larga.',
                  children: [
                    CatSettingRow(
                      title: 'Riassunto',
                      description: 'Un modello locale su questo computer, '
                          'con una descrizione altrettanto lunga da mandare '
                          'a capo.',
                      trailing: Switch(value: true, onChanged: (_) {}),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    for (final text in [
      find.textContaining('superare la larghezza'),
      find.textContaining('altrettanto lunga'),
    ]) {
      expect(
        tester.getSize(text).width,
        lessThanOrEqualTo(AppTokens.formMaxWidth),
      );
    }
    // The control still sits at the far edge, not next to the capped text.
    expect(tester.getTopRight(find.byType(Switch)).dx, closeTo(1400, 1));
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
