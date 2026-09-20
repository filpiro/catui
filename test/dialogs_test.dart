import 'package:catui/catui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps a page whose only button opens [open].
Future<void> pumpOpener(
  WidgetTester tester,
  Future<void> Function(BuildContext) open, {
  ThemeData? theme,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: theme ?? catTheme(catppuccin.mocha, Brightness.dark),
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => open(context),
            child: const Text('go'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('go'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('confirm returns the pressed answer', (tester) async {
    bool? answer;
    Future<void> open(BuildContext context) async {
      answer = await catConfirm(
        context,
        title: 'Delete?',
        message: 'Gone for good.',
        confirm: 'Delete',
        cancel: 'Cancel',
        danger: true,
      );
    }

    await pumpOpener(tester, open);
    expect(find.text('Gone for good.'), findsOne);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(answer, isFalse);

    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(answer, isTrue);
  });

  testWidgets('danger confirm is painted with error', (tester) async {
    await pumpOpener(
      tester,
      (context) => catConfirm(
        context,
        title: 'Delete?',
        confirm: 'Delete',
        cancel: 'Cancel',
        danger: true,
      ),
    );
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Delete'),
    );
    final scheme = catTheme(catppuccin.mocha, Brightness.dark).colorScheme;
    expect(button.style!.backgroundColor!.resolve({}), scheme.error);
  });

  testWidgets('text input: empty blocks confirm, Enter submits trimmed', (
    tester,
  ) async {
    String? name;
    Future<void> open(BuildContext context) async {
      name = await catTextInput(
        context,
        title: 'Rename',
        label: 'Name',
        confirm: 'Save',
        cancel: 'Cancel',
        initial: 'old',
      );
    }

    await pumpOpener(tester, open);
    // Focus lands in the field.
    expect(tester.widget<TextField>(find.byType(TextField)).autofocus, isTrue);

    await tester.enterText(find.byType(TextField), '   ');
    await tester.pump();
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );

    await tester.enterText(find.byType(TextField), '  new  ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(name, 'new');
  });

  for (final (name, flavor, brightness) in [
    ('light', catppuccin.latte, Brightness.light),
    ('dark', catppuccin.mocha, Brightness.dark),
  ]) {
    testWidgets('both dialogs wear the shared surface in $name', (
      tester,
    ) async {
      final theme = catTheme(flavor, brightness);

      for (final open in [
        (BuildContext c) =>
            catConfirm(c, title: 't', confirm: 'ok', cancel: 'no'),
        (BuildContext c) => catTextInput(
          c,
          title: 't',
          label: 'l',
          confirm: 'ok',
          cancel: 'no',
        ),
      ]) {
        await pumpOpener(tester, (c) async => open(c), theme: theme);

        final material = tester.widget<Material>(
          find
              .descendant(
                of: find.byType(AlertDialog),
                matching: find.byType(Material),
              )
              .first,
        );
        expect(material.color, flavor.mantle);
        expect(
          material.shape,
          RoundedRectangleBorder(
            side: BorderSide(color: flavor.surface1),
            borderRadius: BorderRadius.circular(AppTokens.radius),
          ),
        );

        // The route outlives a re-pump, so the next dialog would open behind it.
        await tester.tap(find.text('no'));
        await tester.pumpAndSettle();
      }
    });
  }

  testWidgets('a new snack replaces the current one', (tester) async {
    final key = GlobalKey<ScaffoldMessengerState>();
    await tester.pumpWidget(
      MaterialApp(scaffoldMessengerKey: key, home: const Scaffold()),
    );
    catSnack(key.currentState!, 'first');
    catSnack(key.currentState!, 'second');
    await tester.pumpAndSettle();
    expect(find.text('first'), findsNothing);
    expect(find.text('second'), findsOne);
  });
}
