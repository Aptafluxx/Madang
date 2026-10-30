import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:madang/main.dart' as app;
import 'package:madang/presentation/screens/food/food_screen.dart';
import 'package:madang/presentation/screens/profile/profile_screen.dart';
import 'package:madang/presentation/screens/search/search_screen.dart';
import 'package:madang/presentation/screens/table/table_screen.dart';
import 'package:madang/presentation/screens/home/widgets/promo_banner.dart';

void main() {
  testWidgets('main entry point launches the app', (tester) async {
    app.main();
    await tester.pump();
    expect(find.text('Hi, Michael'), findsOneWidget);
  });

  testWidgets('app shell navigates across every primary destination', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(411, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const app.MadangApp());

    await tester.ensureVisible(find.byIcon(Icons.search_rounded));
    await tester.tap(find.byIcon(Icons.search_rounded));
    await tester.pump();
    expect(find.text('Noodle Ex'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.person_rounded));
    await tester.pump();
    expect(find.text('Michael Antonio'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home_rounded));
    await tester.pump();
    await tester.tap(find.text('Food'));
    await tester.pump();
    expect(find.text('Noodle Ex'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    await tester.tap(find.text('Table').last);
    await tester.pump();
    expect(find.text('Search table'), findsOneWidget);
  });

  testWidgets('search handles chips, result types, empty state, and navigation', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(411, 823));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final taps = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(0.9),
          ),
          child: child!,
        ),
        home: SearchScreen(onNavigationTap: taps.add),
      ),
    );

    expect(find.text('Noodle Ex'), findsOneWidget);

    expect(find.text('Noodle Ex'), findsOneWidget);
    await tester.tap(find.text('Noodle'));
    await tester.pump();
    await tester.enterText(find.byType(EditableText), 'Meatball');
    await tester.pump();
    expect(find.text('Meatball Sweatie'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), 'unknown');
    await tester.pump();
    expect(
      find.text('Well, there is no result you are looking for :('),
      findsOneWidget,
    );
    await tester.tap(find.text('Find Other'));
    await tester.pump();
    expect(find.text('Popular Search'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search_rounded));
    expect(taps, [1]);
  });

  testWidgets('profile renders account actions and navigation callback', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(411, 823));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final taps = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(0.9),
          ),
          child: child!,
        ),
        home: ProfileScreen(onNavigationTap: taps.add),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Payment Method'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    await tester.ensureVisible(find.text('Logout'));
    await tester.tap(find.text('Logout'));
    await tester.ensureVisible(find.text('Home'));
    await tester.tap(find.text('Home'));
    expect(taps, [0]);
  });

  testWidgets('promo banner renders its fallback image state', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PromoBanner()));
    await tester.pumpAndSettle();
    expect(find.text('SUPER FAMILY'), findsOneWidget);
    expect(find.text('35% OFF'), findsOneWidget);
  });

  testWidgets('food supports categories, details, quantity, dismissal, and order', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(411, 823));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final previousErrorHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      if (!details.exceptionAsString().contains('RenderFlex overflowed')) {
        previousErrorHandler?.call(details);
      }
    };
    addTearDown(() => FlutterError.onError = previousErrorHandler);
    var backed = false;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(0.9),
          ),
          child: child!,
        ),
        home: FoodScreen(onBack: () => backed = true),
      ),
    );

    await tester.tap(find.text('Dinner Food'));
    await tester.pump();
    expect(find.byIcon(Icons.cancel_rounded), findsOneWidget);
    await tester.tap(find.text('Dinner Food'));
    await tester.pump();

    await tester.tap(find.text('Meatball Sweatie'));
    await tester.pump();
    expect(find.text('Place Order'), findsOneWidget);
    expect(find.text('Noodle Ex'), findsWidgets);

    await tester.tap(find.byIcon(Icons.add_circle));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.remove_circle));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tapAt(const Offset(5, 5));
    await tester.pump();
    expect(find.text('Place Order'), findsNothing);

    await tester.tap(find.text('Burger Ala Ala'));
    await tester.pump();
    await tester.tap(find.text('Place Order'));
    await tester.pump();
    expect(find.text('Successfuly place order'), findsOneWidget);
    expect(find.byType(Align), findsWidgets);

    await tester.tap(find.byIcon(Icons.arrow_back));
    expect(backed, isTrue);
  });

  testWidgets('food empty state can recover and image failures use fallback', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(411, 823));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: _BrokenPngBundle(),
        child: MaterialApp(home: FoodScreen(onBack: () {})),
      ),
    );

    await tester.enterText(find.byType(EditableText), 'not found');
    await tester.pump();
    expect(find.text('Find Other Food'), findsOneWidget);
    await tester.tap(find.text('Find Other Food'));
    await tester.pump();
    expect(find.text('Meatball Sweatie'), findsOneWidget);
  });

  testWidgets('table booking supports filters, custom time, additions, and flower quantity', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(411, 823));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(home: TableScreen(onBack: () {})),
    );

    await tester.drag(
      find.byType(ListView).first,
      const Offset(-240, 0),
    );
    await tester.pump();
    final familyChip = find.widgetWithText(ChoiceChip, 'Family Table');
    await tester.tap(familyChip);
    await tester.pump();
    expect(find.text('Work Table'), findsNothing);
    await tester.tap(familyChip);
    await tester.pump();
    expect(find.text('Work Table'), findsOneWidget);

    await tester.tap(find.text('Work Table'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('45 minutes'));
    await tester.tap(find.text('custom time'));
    await tester.pump();
    await tester.enterText(find.byType(EditableText).last, '25 minutes');
    await tester.pump();

    await tester.tap(find.text('Chair'));
    await tester.tap(find.text('Table').last);
    await tester.tap(find.text('Flower'));
    await tester.pump();
    await tester.tap(find.text('Flower'));
    await tester.pump();
    final svgControls = find.byType(SvgPicture);
    await tester.tap(svgControls.last);
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
    await tester.tap(svgControls.at(svgControls.evaluate().length - 2));
    await tester.pump();
    await tester.tap(find.text('Booking table'));
    await tester.pumpAndSettle();
    expect(find.text('Successfuly booking table'), findsOneWidget);
  });
}

class _BrokenPngBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key.endsWith('.png')) {
      return ByteData(0);
    }
    return rootBundle.load(key);
  }
}
