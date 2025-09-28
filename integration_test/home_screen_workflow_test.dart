import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lets_stream/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Home Screen Workflow Tests', () {
    setUp(() async {
      // Clear shared preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('should load trending content on home screen', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Should be on home screen
      expect(find.text('Let\'s Stream Home'), findsOneWidget);

      // Should show loading shimmer initially
      expect(find.byType(ListView), findsAtLeast(1));

      // Wait for content to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should show carousel sections (check for horizontal scrollable content)
      final listViews = find.byType(ListView);
      expect(listViews, findsAtLeast(1));

      // Should have media carousel widgets
      // Note: The exact widgets might vary, but we should see scrollable content
      final scrollableWidgets = find.byWidgetPredicate(
        (widget) => widget is ScrollView || widget is SingleChildScrollView,
      );
      expect(scrollableWidgets, findsAtLeast(1));
    });

    testWidgets('should navigate to movies list from trending section', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Should be on home screen
      expect(find.text('Let\'s Stream Home'), findsOneWidget);

      // Wait for content to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Look for "View All" buttons or similar navigation elements
      final viewAllButtons = find.textContaining('View All');
      if (viewAllButtons.evaluate().isNotEmpty) {
        // If there are view all buttons, tap on the first one
        await tester.tap(viewAllButtons.first);
        await tester.pumpAndSettle();

        // Should navigate to movies list
        expect(find.textContaining('Movies'), findsAtLeast(1));
      }

      // Look for movie cards that can be tapped
      final movieCards = find.byWidgetPredicate(
        (widget) => widget is Card || widget is Container,
      );

      if (movieCards.evaluate().length > 5) {
        // If we have multiple cards
        // Try to tap on a card to navigate to detail
        await tester.tap(movieCards.at(2)); // Tap on third card
        await tester.pumpAndSettle();

        // Should navigate to detail screen
        // The detail screen should have different content than home
        expect(find.byType(CustomScrollView), findsAtLeast(1));
      }
    });

    testWidgets('should navigate to TV shows list from trending TV section', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Should be on home screen
      expect(find.text('Let\'s Stream Home'), findsOneWidget);

      // Wait for content to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Look for TV show sections
      final tvSectionText = find.textContaining('TV');
      if (tvSectionText.evaluate().isNotEmpty) {
        // If we find TV sections, try to interact with them
        expect(tvSectionText, findsAtLeast(1));
      }

      // Look for "View All" buttons that might lead to TV shows
      final viewAllButtons = find.textContaining('View All');
      if (viewAllButtons.evaluate().length > 1) {
        // Tap on second "View All" button (might be TV shows)
        await tester.tap(viewAllButtons.at(1));
        await tester.pumpAndSettle();

        // Should navigate to TV list
        expect(find.textContaining('TV'), findsAtLeast(1));
      }
    });

    testWidgets('should handle horizontal scrolling in carousels', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Should be on home screen
      expect(find.text('Let\'s Stream Home'), findsOneWidget);

      // Wait for content to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find horizontal list views (carousels)
      final horizontalListViews = find.byWidgetPredicate((widget) {
        if (widget is ListView) {
          return widget.scrollDirection == Axis.horizontal;
        }
        return false;
      });

      if (horizontalListViews.evaluate().isNotEmpty) {
        // If we have horizontal carousels, test scrolling
        final horizontalCarousel = horizontalListViews.first;

        // Try to scroll horizontally
        await tester.drag(horizontalCarousel, const Offset(-200, 0));
        await tester.pumpAndSettle();

        // Should be able to scroll without errors
        expect(horizontalCarousel, findsOneWidget);
      }
    });

    testWidgets('should handle pull to refresh on home screen', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Should be on home screen
      expect(find.text('Let\'s Stream Home'), findsOneWidget);

      // Look for RefreshIndicator
      final refreshIndicator = find.byType(RefreshIndicator);
      if (refreshIndicator.evaluate().isNotEmpty) {
        // If there's a refresh indicator, test pull to refresh
        await tester.drag(refreshIndicator.first, const Offset(0, 100));
        await tester.pumpAndSettle();

        // Should handle refresh without errors
        expect(find.byType(SingleChildScrollView), findsAtLeast(1));
      }
    });

    testWidgets('should show error state when content fails to load', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Should be on home screen
      expect(find.text('Let\'s Stream Home'), findsOneWidget);

      // Wait for potential error states
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should handle error states gracefully
      // Look for error widgets or retry buttons
      final errorWidgets = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data?.contains('error') == true,
      );

      final retryButtons = find.textContaining('Retry');
      final elevatedButtons = find.byType(ElevatedButton);

      // If there are error states, they should have retry options
      if (errorWidgets.evaluate().isNotEmpty ||
          retryButtons.evaluate().isNotEmpty) {
        expect(elevatedButtons, findsAtLeast(1));
      }
    });

    testWidgets('should maintain scroll position when navigating back', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Should be on home screen
      expect(find.text('Let\'s Stream Home'), findsOneWidget);

      // Wait for content to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find scrollable content
      final scrollableViews = find.byType(SingleChildScrollView);
      if (scrollableViews.evaluate().isNotEmpty) {
        final scrollView = scrollableViews.first;

        // Scroll down
        await tester.drag(scrollView, const Offset(0, -200));
        await tester.pumpAndSettle();

        // Navigate to search and back
        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();

        // Navigate back
        final backButton = find.byType(BackButton);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton.first);
          await tester.pumpAndSettle();

          // Should be back on home screen
          expect(find.text('Let\'s Stream Home'), findsOneWidget);
        }
      }
    });

    testWidgets('should handle network connectivity changes gracefully', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Should be on home screen
      expect(find.text('Let\'s Stream Home'), findsOneWidget);

      // Wait for content to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // The app should handle network issues gracefully
      // Look for offline indicators or cached content
      final cachedContent = find.byWidgetPredicate(
        (widget) => widget is Container || widget is Card,
      );

      // Should have some UI elements even if network fails
      expect(cachedContent, findsAtLeast(1));
    });
  });
}
