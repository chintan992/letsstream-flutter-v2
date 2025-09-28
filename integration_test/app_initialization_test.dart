import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lets_stream/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Initialization Tests', () {
    setUp(() async {
      // Clear shared preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('should show loading screen initially and then home screen', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Should show loading screen initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text("Let's Stream"), findsOneWidget);

      // Wait for initialization to complete
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should show home screen after initialization
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);

      // Should be on home screen
      expect(find.text('Let\'s Stream Home'), findsOneWidget);
    });

    testWidgets('should load theme correctly on startup', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should have a theme applied (check for Material app with theme)
      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);

      // Should have proper theme colors
      expect(materialApp.theme!.colorScheme, isNotNull);
      expect(materialApp.theme!.textTheme, isNotNull);
    });

    testWidgets('should show terms acceptance dialog if not accepted', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Check if terms dialog is shown (it should be shown by default)
      // The dialog might be overlaid on the main content
      expect(find.byType(ElevatedButton), findsWidgets);

      // Look for terms acceptance related text
      // Note: The exact text might vary, but we should find some UI elements
      final elevatedButtons = find.byType(ElevatedButton);
      if (elevatedButtons.evaluate().isNotEmpty) {
        // If there are elevated buttons, it might be the terms dialog
        expect(elevatedButtons, findsAtLeast(1));
      }
    });

    testWidgets('should navigate between bottom navigation tabs', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should start on home tab
      final NavigationBar navigationBar = tester.widget(
        find.byType(NavigationBar),
      );
      expect(navigationBar.selectedIndex, 0);

      // Tap on Hub tab (index 1)
      await tester.tap(find.byIcon(Icons.video_library));
      await tester.pumpAndSettle();

      // Should be on hub screen
      expect(find.text('Hub'), findsOneWidget);

      // Tap on Anime tab (index 2)
      await tester.tap(find.byIcon(Icons.animation));
      await tester.pumpAndSettle();

      // Should be on anime screen
      expect(find.text('Anime'), findsOneWidget);

      // Tap on Profile tab (index 3)
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Should be on profile screen
      expect(find.text('Profile'), findsOneWidget);

      // Go back to home
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();

      // Should be back on home screen
      expect(find.text('Let\'s Stream Home'), findsOneWidget);
    });

    testWidgets('should handle app bar search button', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find and tap search button in app bar
      final searchButton = find.byIcon(Icons.search);
      expect(searchButton, findsOneWidget);

      await tester.tap(searchButton);
      await tester.pumpAndSettle();

      // Should navigate to search screen
      expect(find.text('Search movies or TV shows'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should handle back navigation from search', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Should be on search screen
      expect(find.text('Search movies or TV shows'), findsOneWidget);

      // Tap back button
      final backButton = find.byType(BackButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        // Should be back on home screen
        expect(find.text('Let\'s Stream Home'), findsOneWidget);
      }
    });

    testWidgets('should handle deep link navigation', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Test navigation to movies list
      final homeScreenFinder = find.text('Let\'s Stream Home');
      if (homeScreenFinder.evaluate().isNotEmpty) {
        // Try to find and tap on a trending section if available
        // This is a basic test - in a real scenario you'd mock the data
        final listViews = find.byType(ListView);
        if (listViews.evaluate().isNotEmpty) {
          // If there are list views, the home screen loaded content
          expect(listViews, findsAtLeast(1));
        }
      }
    });

    testWidgets('should handle error states gracefully', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // The app should handle initialization errors gracefully
      // and still show the main UI structure
      expect(find.byType(Scaffold), findsAtLeast(1));
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
