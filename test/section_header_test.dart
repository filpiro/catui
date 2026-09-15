import 'package:catui/catui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('leading and trailing are optional, the title is not', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              CatSectionHeader(
                leading: Icon(Icons.circle),
                title: 'Con tutto',
                trailing: Text('4h 15m'),
              ),
              CatSectionHeader.inline(title: 'Solo titolo'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Con tutto'), findsOneWidget);
    expect(find.text('4h 15m'), findsOneWidget);
    expect(find.byIcon(Icons.circle), findsOneWidget);
    expect(find.text('Solo titolo'), findsOneWidget);

    // Trailing sits at the far edge; leading hugs the title.
    final title = tester.getTopLeft(find.text('Con tutto'));
    expect(title.dx, lessThan(tester.getTopLeft(find.text('4h 15m')).dx));
    expect(tester.getTopLeft(find.byIcon(Icons.circle)).dx, lessThan(title.dx));

    // Both variants keep the same vertical rhythm, only the gutter differs.
    expect(CatSectionHeader.listPadding.top, CatSectionHeader.inlinePadding.top);
    expect(CatSectionHeader.inlinePadding.left, 0);
  });
}
