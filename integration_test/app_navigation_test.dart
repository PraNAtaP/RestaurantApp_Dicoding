import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Navigation Integration Test', () {
    testWidgets('tap on first restaurant card, verify detail page opens', (
      tester,
    ) async {
      app.main();

      // Wait for app to start and load API data
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find the first CardRestaurant widget which has the restaurant name
      // This assumes the API returns data properly (which it should in integration test)
      // Since it's dynamic, we just check for the CardRestaurant widget itself
      // used in CardRestaurant. Wait, CardRestaurant doesn't use Card widget. It uses Container.
      // Let's find InkWell inside the CardRestaurant list
      final listFinder = find.byType(ListView).first;
      expect(listFinder, findsOneWidget);

      final inkWellFinder = find
          .descendant(of: listFinder, matching: find.byType(InkWell))
          .first;

      expect(inkWellFinder, findsOneWidget);

      // Tap on the first restaurant card
      await tester.tap(inkWellFinder);

      // Wait for navigation animation and API load on detail page
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify we are on the DetailPage by checking for specific text like "Description"
      expect(find.text('Description'), findsOneWidget);

      // Navigate back
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify we are back on the Home page by looking for the Search icon in AppBar
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}
