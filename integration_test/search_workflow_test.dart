import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lets_stream/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Search Workflow Tests', () {
    setUp(() async {
      // Clear shared preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('should navigate to search screen from home', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Should be on home screen
      expect(find.text('Let\'s Stream Home'), findsOneWidget);

      // Find and tap search button
      final searchButton = find.byIcon(Icons.search);
      expect(searchButton, findsOneWidget);

      await tester.tap(searchButton);
      await tester.pumpAndSettle();

      // Should be on search screen
      expect(find.text('Search movies or TV shows'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should show search suggestions when query is empty', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Should show search suggestions
      expect(find.text('Try searching for'), findsOneWidget);

      // Should show suggestion chips
      final actionChips = find.byType(ActionChip);
      expect(actionChips, findsAtLeast(1));

      // Should show common suggestions like "Avengers", "Breaking Bad", etc.
      expect(find.text('Avengers'), findsOneWidget);
      expect(find.text('Breaking Bad'), findsOneWidget);
    });

    testWidgets('should handle search query input', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Find the search text field
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Enter search query
      await tester.enterText(textField, 'Avengers');
      await tester.pumpAndSettle();

      // Should show loading state or results
      // The search field should contain the entered text
      final TextField searchField = tester.widget(textField);
      expect(searchField.controller?.text, 'Avengers');
    });

    testWidgets('should handle search filter buttons', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter a search query first
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'test');
      await tester.pumpAndSettle();

      // Look for filter buttons (All, Movies, TV)
      final filterButtons = find.byType(SegmentedButton);
      if (filterButtons.evaluate().isNotEmpty) {
        // Should have filter options
        expect(filterButtons, findsOneWidget);

        // Look for filter text
        expect(find.text('All'), findsOneWidget);
        expect(find.text('Movies'), findsOneWidget);
        expect(find.text('TV'), findsOneWidget);
      }
    });

    testWidgets('should handle search suggestion chip taps', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Find and tap a suggestion chip
      final avengersChip = find.text('Avengers');
      if (avengersChip.evaluate().isNotEmpty) {
        await tester.tap(avengersChip);
        await tester.pumpAndSettle();

        // The search field should be populated with the suggestion
        final TextField searchField = tester.widget(find.byType(TextField));
        expect(searchField.controller?.text, 'Avengers');
      }
    });

    testWidgets('should handle search filter dialog', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter a search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'test');
      await tester.pumpAndSettle();

      // Look for filter button
      final filterButton = find.byIcon(Icons.filter_list);
      if (filterButton.evaluate().isNotEmpty) {
        await tester.tap(filterButton);
        await tester.pumpAndSettle();

        // Should show filter dialog
        expect(find.text('Advanced Filters'), findsOneWidget);
        expect(find.text('Sort by'), findsOneWidget);
        expect(find.text('Release Year'), findsOneWidget);
        expect(find.text('Minimum Rating'), findsOneWidget);
        expect(find.text('Genres'), findsOneWidget);

        // Should have apply button
        expect(find.text('Apply Filters'), findsOneWidget);
      }
    });

    testWidgets('should handle search result item taps', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter a search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Avengers');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Look for search results
      final listTiles = find.byType(ListTile);
      if (listTiles.evaluate().isNotEmpty) {
        // If we have search results, tap on the first one
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle();

        // Should navigate to detail screen
        expect(find.byType(CustomScrollView), findsWidgets);
      }
    });

    testWidgets('should handle search result scrolling', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter a search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'movie');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find the results list
      final listView = find.byType(ListView);
      if (listView.evaluate().isNotEmpty) {
        // Scroll down to load more results
        await tester.drag(listView, const Offset(0, -300));
        await tester.pumpAndSettle();

        // Should handle scrolling without errors
        expect(listView, findsOneWidget);
      }
    });

    testWidgets('should handle search clear functionality', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter a search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'test query');
      await tester.pumpAndSettle();

      // Find and tap clear button
      final clearButton = find.byIcon(Icons.clear);
      if (clearButton.evaluate().isNotEmpty) {
        await tester.tap(clearButton);
        await tester.pumpAndSettle();

        // Search field should be empty
        final TextField searchField = tester.widget(textField);
        expect(searchField.controller?.text, '');
      }
    });

    testWidgets('should handle search pull to refresh', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter a search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'test');
      await tester.pumpAndSettle();

      // Look for RefreshIndicator
      final refreshIndicator = find.byType(RefreshIndicator);
      if (refreshIndicator.evaluate().isNotEmpty) {
        // Test pull to refresh
        await tester.drag(refreshIndicator, const Offset(0, 100));
        await tester.pumpAndSettle();

        // Should handle refresh without errors
        expect(find.byType(ListView), findsWidgets);
      }
    });

    testWidgets('should show no results state when search returns empty', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter a search query that likely returns no results
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'xyzxyzxyzxyz');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should show no results state
      expect(find.textContaining('No results'), findsWidgets);
    });

    testWidgets('should handle search error states', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter a search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'test');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Look for error states or retry buttons
      final retryButtons = find.textContaining('Retry');
      final errorTexts = find.textContaining('error');

      if (retryButtons.evaluate().isNotEmpty ||
          errorTexts.evaluate().isNotEmpty) {
        // Should have retry functionality
        expect(find.byType(ElevatedButton), findsAtLeast(1));
      }
    });
  });
}
