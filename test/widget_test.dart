import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:madang/main.dart';
import 'package:madang/presentation/screens/food/food_screen.dart';
import 'package:madang/presentation/screens/table/table_screen.dart';

void main() {
  testWidgets('restaurant home screen renders expected content', (
    tester,
  ) async {
    await tester.pumpWidget(const MadangApp());

    expect(find.text('Hi, Michael'), findsOneWidget);
    expect(find.text('Get your favorite food here!'), findsOneWidget);
    expect(find.text('Recommendation'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('food results update between empty and populated states', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: FoodScreen(onBack: _unusedBack)));

    expect(
      find.text('Well, there is no food you are\nlooking for :('),
      findsOneWidget,
    );

    await tester.enterText(find.byType(EditableText), 'Meat');
    await tester.pumpAndSettle();

    expect(find.text('Meatball Sweatie'), findsOneWidget);
    expect(
      find.text('Well, there is no food you are\nlooking for :('),
      findsNothing,
    );

    await tester.enterText(find.byType(EditableText), 'Pizza');
    await tester.pumpAndSettle();

    expect(
      find.text('Well, there is no food you are\nlooking for :('),
      findsOneWidget,
    );
  });

  testWidgets('table screen filters cards and navigates back', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: TableScreen(onBack: _unusedBack)),
    );

    expect(find.text('Table'), findsOneWidget);
    expect(find.text('Search table'), findsOneWidget);
    expect(find.text('Work Table'), findsOneWidget);
    expect(find.text('Family Table'), findsWidgets);

    await tester.enterText(find.byType(EditableText), 'Work');
    await tester.pump();

    expect(find.text('Work Table'), findsOneWidget);
    expect(find.text('Family Table'), findsNothing);

    await tester.enterText(find.byType(EditableText), '');
    await tester.pump();
    expect(find.text('Work Table'), findsOneWidget);
    expect(find.text('Family Table'), findsWidgets);
  });

  testWidgets('table screen shows and resets empty result state', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(411, 823));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: TableScreen(onBack: _unusedBack, initialQuery: 'Noodle'),
      ),
    );

    expect(find.text('Noodle'), findsOneWidget);
    expect(
      find.text('Well, there is no table you are looking for :('),
      findsOneWidget,
    );
    expect(find.text('Find Other Table'), findsOneWidget);

    await tester.ensureVisible(find.text('Find Other Table'));
    await tester.tap(find.text('Find Other Table'));
    await tester.pump();

    expect(find.text('Noodle'), findsNothing);
    expect(find.text('Work Table'), findsOneWidget);
    expect(find.text('Family Table'), findsWidgets);
  });
}

void _unusedBack() {}
