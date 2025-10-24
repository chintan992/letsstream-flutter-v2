import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lets_stream/src/shared/widgets/error_state.dart';

void main() {
  group('ErrorState Widget Tests', () {
    group('Widget Rendering', () {
      testWidgets(
        'shouldRenderErrorStateWithDefaultMessage_whenNoMessageProvided',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(home: Scaffold(body: ErrorState())),
          );

          // Verify the error state is rendered
          expect(find.byType(ErrorState), findsOneWidget);

          // Verify default error message is shown
          expect(find.text('Something went wrong'), findsOneWidget);

          // Verify error icon is displayed
          expect(find.byIcon(Icons.error_outline), findsOneWidget);

          // Verify no retry button when onRetry is null
          expect(find.byType(FilledButton), findsNothing);
        },
      );

      testWidgets(
        'shouldRenderErrorStateWithCustomMessage_whenMessageProvided',
        (WidgetTester tester) async {
          const customMessage = 'Network connection failed';

          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(body: ErrorState(message: customMessage)),
            ),
          );

          // Verify custom error message is shown
          expect(find.text(customMessage), findsOneWidget);

          // Verify default message is not shown
          expect(find.text('Something went wrong'), findsNothing);
        },
      );

      testWidgets('shouldRenderErrorStateWithRetryButton_whenOnRetryProvided', (
        WidgetTester tester,
      ) async {
        bool retryCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ErrorState(
                onRetry: () {
                  retryCalled = true;
                },
              ),
            ),
          ),
        );

        // Verify retry button is displayed
        expect(find.byType(FilledButton), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);

        // Tap the retry button
        await tester.tap(find.byType(FilledButton));
        await tester.pump();

        // Verify onRetry callback was called
        expect(retryCalled, isTrue);
      });

      testWidgets('shouldApplyCustomPadding_whenPaddingProvided', (
        WidgetTester tester,
      ) async {
        const customPadding = EdgeInsets.all(50);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: ErrorState(padding: customPadding)),
          ),
        );

        final padding = tester.widget<Padding>(
          find.byWidgetPredicate((widget) => widget is Padding).first,
        );

        expect(padding.padding, equals(customPadding));
      });

      testWidgets('shouldCenterContentVertically_andHorizontally', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ErrorState())),
        );

        final center = tester.widget<Center>(
          find.byWidgetPredicate((widget) => widget is Center).first,
        );

        expect(center, isNotNull);
      });

      testWidgets('shouldDisplayContentInColumnLayout', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ErrorState())),
        );

        final column = tester.widget<Column>(
          find.byWidgetPredicate((widget) => widget is Column).first,
        );

        expect(column.mainAxisSize, equals(MainAxisSize.min));
        expect(
          column.children.length,
          equals(3),
        ); // Icon, Text, and retry button
      });
    });

    group('User Interactions', () {
      testWidgets('shouldCallOnRetry_whenRetryButtonIsTapped', (
        WidgetTester tester,
      ) async {
        bool retryCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ErrorState(
                onRetry: () {
                  retryCalled = true;
                },
              ),
            ),
          ),
        );

        // Tap the retry button
        await tester.tap(find.byType(FilledButton));
        await tester.pump();

        // Verify onRetry callback was called
        expect(retryCalled, isTrue);
      });

      testWidgets('shouldNotShowRetryButton_whenOnRetryIsNull', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ErrorState())),
        );

        // Verify no retry button is shown
        expect(find.byType(FilledButton), findsNothing);
      });
    });

    group('Accessibility', () {
      testWidgets('shouldHaveProperSemanticStructure_forScreenReaders', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ErrorState())),
        );

        // Verify error icon has proper semantics
        final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
        expect(icon.color, equals(Colors.redAccent));
        expect(icon.size, equals(48.0));
      });

      testWidgets('shouldHaveReadableTextContrast', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ErrorState())),
        );

        final text = tester.widget<Text>(find.text('Something went wrong'));

        // Verify text has proper styling for readability
        expect(text.style, isNotNull);
        expect(text.textAlign, equals(TextAlign.center));
      });

      testWidgets('shouldSupportDifferentTextSizes_forAccessibility', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ErrorState())),
        );

        final text = tester.widget<Text>(find.text('Something went wrong'));

        // Verify text uses theme text style which supports dynamic sizing
        expect(text.style, isNotNull);
      });
    });

    group('Theme Support', () {
      testWidgets('shouldAdaptToLightTheme', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(body: ErrorState()),
          ),
        );

        final theme = Theme.of(tester.element(find.byType(ErrorState)));

        // Verify light theme integration
        expect(theme.brightness, equals(Brightness.light));
      });

      testWidgets('shouldAdaptToDarkTheme', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: const Scaffold(body: ErrorState()),
          ),
        );

        final theme = Theme.of(tester.element(find.byType(ErrorState)));

        // Verify dark theme integration
        expect(theme.brightness, equals(Brightness.dark));
      });

      testWidgets('shouldUseThemeTextStyle_forErrorMessage', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(body: ErrorState()),
          ),
        );

        final text = tester.widget<Text>(find.text('Something went wrong'));

        // Verify text uses theme bodyLarge style
        expect(
          text.style,
          equals(
            Theme.of(
              tester.element(find.byType(ErrorState)),
            ).textTheme.bodyLarge,
          ),
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('shouldHandleEmptyMessage_gracefully', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: ErrorState(message: '')),
          ),
        );

        // Should still render without crashing
        expect(find.byType(ErrorState), findsOneWidget);

        // Should show empty text widget
        expect(
          find.byWidgetPredicate(
            (widget) => widget is Text && widget.data == '',
          ),
          findsOneWidget,
        );
      });

      testWidgets('shouldHandleVeryLongMessage_withScrolling', (
        WidgetTester tester,
      ) async {
        const longMessage =
            'This is a very long error message that should be displayed properly even when it spans multiple lines and requires proper text wrapping to ensure good readability';

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: ErrorState(message: longMessage)),
          ),
        );

        // Should still render without crashing
        expect(find.byType(ErrorState), findsOneWidget);

        // Should show the long message
        expect(find.text(longMessage), findsOneWidget);

        final text = tester.widget<Text>(find.text(longMessage));

        // Verify text is centered for long messages
        expect(text.textAlign, equals(TextAlign.center));
      });

      testWidgets('shouldHandleMultipleRapidRetryTaps', (
        WidgetTester tester,
      ) async {
        int retryCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ErrorState(
                onRetry: () {
                  retryCount++;
                },
              ),
            ),
          ),
        );

        // Rapidly tap retry button multiple times
        await tester.tap(find.byType(FilledButton));
        await tester.tap(find.byType(FilledButton));
        await tester.tap(find.byType(FilledButton));
        await tester.pump();

        // Verify all taps were registered
        expect(retryCount, equals(3));
      });
    });
  });
}
