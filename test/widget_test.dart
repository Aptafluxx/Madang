import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:madang/main.dart';
import 'package:madang/presentation/screens/food/food_screen.dart';

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
}

void _unusedBack() {}
