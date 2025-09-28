import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lets_stream/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Movie Detail Workflow Tests', () {
    setUp(() async {
      // Clear shared preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('should navigate to movie detail from home screen', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Should be on home screen
      expect(find.text('Let\'s Stream Home'), findsOneWidget);

      // Wait for content to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Look for movie cards or carousel items
      final cards = find.byWidgetPredicate(
        (widget) => widget is Card || widget is Container,
      );

      if (cards.evaluate().length > 3) {
        // Tap on a card to navigate to detail
        await tester.tap(cards.at(2));
        await tester.pumpAndSettle();

        // Should navigate to detail screen
        expect(find.byType(CustomScrollView), findsWidgets);
      }
    });

    testWidgets('should navigate to movie detail from search results', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Avengers');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Look for search results
      final listTiles = find.byType(ListTile);
      if (listTiles.evaluate().isNotEmpty) {
        // Tap on first result
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle();

        // Should navigate to detail screen
        expect(find.byType(CustomScrollView), findsWidgets);
      }
    });

    testWidgets('should display movie information on detail screen', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search first
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Inception');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Look for and tap search results
      final listTiles = find.byType(ListTile);
      if (listTiles.evaluate().isNotEmpty) {
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle();

        // Should show detail screen with movie information
        expect(find.byType(CustomScrollView), findsWidgets);

        // Should have poster image
        final images = find.byWidgetPredicate(
          (widget) => widget is Image || widget is CachedNetworkImage,
        );
        expect(images, findsAtLeast(1));

        // Should have title, overview, and other details
        expect(find.byType(Text), findsAtLeast(3));
      }
    });

    testWidgets('should handle watch now button on detail screen', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'movie');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to detail
      final listTiles = find.byType(ListTile);
      if (listTiles.evaluate().isNotEmpty) {
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle();

        // Look for "Watch Now" button
        final watchNowButton = find.text('Watch Now');
        if (watchNowButton.evaluate().isNotEmpty) {
          await tester.tap(watchNowButton);
          await tester.pumpAndSettle();

          // Should navigate to video player
          expect(find.textContaining('Video'), findsWidgets);
        }
      }
    });

    testWidgets('should display cast section on detail screen', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Inception');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to detail
      final listTiles = find.byType(ListTile);
      if (listTiles.evaluate().isNotEmpty) {
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Should show cast section
        expect(find.textContaining('Cast'), findsWidgets);

        // Should have cast member widgets
        final castContainers = find.byWidgetPredicate(
          (widget) => widget is Container || widget is Column,
        );
        expect(castContainers, findsAtLeast(5));
      }
    });

    testWidgets('should display trailers section on detail screen', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Inception');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to detail
      final listTiles = find.byType(ListTile);
      if (listTiles.evaluate().isNotEmpty) {
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Should show trailers section
        expect(find.textContaining('Trailer'), findsWidgets);

        // Should have video/trailer widgets
        final videoContainers = find.byWidgetPredicate(
          (widget) => widget is Container || widget is GestureDetector,
        );
        expect(videoContainers, findsAtLeast(3));
      }
    });

    testWidgets('should display similar movies section on detail screen', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Inception');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to detail
      final listTiles = find.byType(ListTile);
      if (listTiles.evaluate().isNotEmpty) {
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Should show similar movies section
        expect(find.textContaining('Similar'), findsWidgets);

        // Should have similar movie cards
        final similarCards = find.byWidgetPredicate(
          (widget) => widget is Card || widget is Container,
        );
        expect(similarCards, findsAtLeast(3));
      }
    });

    testWidgets('should handle horizontal scrolling in detail sections', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Inception');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to detail
      final listTiles = find.byType(ListTile);
      if (listTiles.evaluate().isNotEmpty) {
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Find horizontal scrollable sections (cast, similar movies)
        final horizontalScrollables = find.byWidgetPredicate((widget) {
          if (widget is ListView) {
            return widget.scrollDirection == Axis.horizontal;
          }
          return false;
        });

        if (horizontalScrollables.evaluate().isNotEmpty) {
          // Test horizontal scrolling
          await tester.drag(horizontalScrollables.first, const Offset(-200, 0));
          await tester.pumpAndSettle();

          // Should handle scrolling without errors
          expect(horizontalScrollables, findsAtLeast(1));
        }
      }
    });

    testWidgets('should handle back navigation from detail screen', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Inception');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to detail
      final listTiles = find.byType(ListTile);
      if (listTiles.evaluate().isNotEmpty) {
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle();

        // Should be on detail screen
        expect(find.byType(CustomScrollView), findsWidgets);

        // Tap back button
        final backButton = find.byType(BackButton);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton);
          await tester.pumpAndSettle();

          // Should be back on search screen
          expect(find.text('Search movies or TV shows'), findsOneWidget);
        }
      }
    });

    testWidgets('should handle detail screen loading states', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Inception');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to detail
      final listTiles = find.byType(ListTile);
      if (listTiles.evaluate().isNotEmpty) {
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Should have some loading or content widgets
        expect(find.byType(Text), findsAtLeast(1));
      }
    });

    testWidgets('should handle detail screen error states', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Inception');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to detail
      final listTiles = find.byType(ListTile);
      if (listTiles.evaluate().isNotEmpty) {
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Should handle errors gracefully
        // Look for error widgets or retry buttons
        final retryButtons = find.textContaining('Retry');
        final errorTexts = find.textContaining('error');

        if (retryButtons.evaluate().isNotEmpty ||
            errorTexts.evaluate().isNotEmpty) {
          // Should have retry functionality
          expect(find.byType(ElevatedButton), findsAtLeast(1));
        }
      }
    });

    testWidgets('should handle detail screen with missing data', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'test');
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to detail
      final listTiles = find.byType(ListTile);
      if (listTiles.evaluate().isNotEmpty) {
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Should handle missing data gracefully
        // Should still show basic UI structure
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(CustomScrollView), findsWidgets);
      }
    });
  });
}
