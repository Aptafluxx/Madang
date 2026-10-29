import 'package:flutter_test/flutter_test.dart';

import 'package:madang/main.dart';

void main() {
  testWidgets('restaurant home screen renders expected content', (tester) async {
    await tester.pumpWidget(const MadangApp());

    expect(find.text('Hi, Michael'), findsOneWidget);
    expect(find.text('Get your favorite food here!'), findsOneWidget);
    expect(find.text('Recommendation'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });
}
