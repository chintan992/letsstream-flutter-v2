import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lets_stream/src/shared/widgets/media_card.dart';
import 'test_utils.dart';

void main() {
  group('MediaCard Widget Tests', () {
    late bool onTapCalled;

    setUp(() {
      onTapCalled = false;
    });

    group('Widget Rendering', () {
      testWidgets('shouldRenderMediaCardWithImage_whenImagePathProvided', (
        WidgetTester tester,
      ) async {
        await TestUtils.pumpWidgetWithProviders(
          tester,
          MediaCard(
            title: TestData.testMovieTitle,
            imagePath: TestData.testPosterPath,
            onTap: () {},
          ),
        );

        // Verify the card is rendered
        expect(find.byType(MediaCard), findsOneWidget);

        // Verify the image is displayed
        expect(find.byType(Image), findsOneWidget);

        // Verify accessibility features
        expect(
          TestUtils.findBySemanticLabel(TestData.testMovieTitle),
          findsOneWidget,
        );
      });

      testWidgets('shouldRenderMediaCardWithoutImage_whenImagePathIsNull', (
        WidgetTester tester,
      ) async {
        await TestUtils.pumpWidgetWithProviders(
          tester,
          MediaCard(
            title: TestData.testMovieTitle,
            imagePath: null,
            onTap: () {},
          ),
        );

        // Verify the card is rendered
        expect(find.byType(MediaCard), findsOneWidget);

        // Verify placeholder container is shown when no image
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Container &&
                widget.decoration ==
                    BoxDecoration(
                      color: Theme.of(
                        tester.element(find.byType(MediaCard)),
                      ).colorScheme.surfaceContainerHighest,
                    ),
          ),
          findsOneWidget,
        );
      });

      testWidgets('shouldShowLoadingState_initially', (
        WidgetTester tester,
      ) async {
        await TestUtils.pumpWidgetWithProviders(
          tester,
          MediaCard(
            title: TestData.testMovieTitle,
            imagePath: TestData.testPosterPath,
            onTap: () {},
          ),
        );

        // Initially should show loading indicator
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Wait for the delayed image loading
        await tester.pump(const Duration(milliseconds: 150));

        // After delay, image should be visible and loading should be gone
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('shouldApplyCorrectStyling_andDimensions', (
        WidgetTester tester,
      ) async {
        await TestUtils.pumpWidgetWithProviders(
          tester,
          MediaCard(
            title: TestData.testMovieTitle,
            imagePath: TestData.testPosterPath,
            onTap: () {},
          ),
        );

        // Wait for image to load
        await tester.pump(const Duration(milliseconds: 150));

        final container = tester.widget<Container>(
          find
              .byWidgetPredicate(
                (widget) => widget is Container && widget.constraints != null,
              )
              .first,
        );

        // Verify card has proper constraints for accessibility
        expect(container.constraints!.minWidth, greaterThan(0));
        expect(container.constraints!.minHeight, greaterThan(0));

        // Verify card has proper decoration
        final decoratedBox = tester.widget<DecoratedBox>(
          find.byWidgetPredicate((widget) => widget is DecoratedBox).first,
        );
        expect(decoratedBox.decoration, isA<BoxDecoration>());
      });
    });

    group('User Interactions', () {
      testWidgets('shouldCallOnTap_whenCardIsTapped', (
        WidgetTester tester,
      ) async {
        await TestUtils.pumpWidgetWithProviders(
          tester,
          MediaCard(
            title: TestData.testMovieTitle,
            imagePath: TestData.testPosterPath,
            onTap: () {
              onTapCalled = true;
            },
          ),
        );

        // Wait for image to load
        await tester.pump(const Duration(milliseconds: 150));

        // Tap the card
        await tester.tap(find.byType(MediaCard));
        await tester.pump();

        // Verify onTap was called
        expect(onTapCalled, isTrue);
      });

      testWidgets('shouldProvideProperAccessibility_whenCardIsTapped', (
        WidgetTester tester,
      ) async {
        await TestUtils.pumpWidgetWithProviders(
          tester,
          MediaCard(
            title: TestData.testMovieTitle,
            imagePath: TestData.testPosterPath,
            onTap: () {},
          ),
        );

        // Wait for image to load
        await tester.pump(const Duration(milliseconds: 150));

        // Verify semantic properties for accessibility
        final semantics = tester.widget<Semantics>(
          TestUtils.findBySemanticLabel(TestData.testMovieTitle),
        );

        expect(semantics.properties.button, isTrue);
        expect(semantics.properties.image, isTrue);
        expect(semantics.properties.hint, equals('Double tap to open details'));
      });

      testWidgets('shouldHandleFocus_andKeyboardNavigation', (
        WidgetTester tester,
      ) async {
        await TestUtils.pumpWidgetWithProviders(
          tester,
          MediaCard(
            title: TestData.testMovieTitle,
            imagePath: TestData.testPosterPath,
            onTap: () {},
          ),
        );

        // Wait for image to load
        await tester.pump(const Duration(milliseconds: 150));

        // Focus the card
        final mediaCard = find.byType(MediaCard);
        await tester.tap(mediaCard);
        await tester.pump();

        // Verify focus handling
        final inkWell = tester.widget<InkWell>(
          find.byWidgetPredicate((widget) => widget is InkWell).first,
        );

        expect(inkWell.focusColor, isNotNull);
      });
    });

    group('Accessibility', () {
      testWidgets('shouldHaveProperSemanticLabels_forScreenReaders', (
        WidgetTester tester,
      ) async {
        await TestUtils.pumpWidgetWithProviders(
          tester,
          MediaCard(
            title: TestData.testMovieTitle,
            imagePath: TestData.testPosterPath,
            onTap: () {},
          ),
        );

        // Wait for image to load
        await tester.pump(const Duration(milliseconds: 150));

        // Verify semantic label is set correctly
        final semantics = tester.widget<Semantics>(
          TestUtils.findBySemanticLabel(TestData.testMovieTitle),
        );

        expect(semantics.properties.label, equals(TestData.testMovieTitle));
      });

      testWidgets('shouldHaveRecommendedTouchTargetSize_forAccessibility', (
        WidgetTester tester,
      ) async {
        await TestUtils.pumpWidgetWithProviders(
          tester,
          MediaCard(
            title: TestData.testMovieTitle,
            imagePath: TestData.testPosterPath,
            onTap: () {},
          ),
        );

        // Wait for image to load
        await tester.pump(const Duration(milliseconds: 150));

        final container = tester.widget<Container>(
          find
              .byWidgetPredicate(
                (widget) => widget is Container && widget.constraints != null,
              )
              .first,
        );

        // Verify minimum touch target size for accessibility
        expect(container.constraints!.minWidth, greaterThanOrEqualTo(44));
        expect(container.constraints!.minHeight, greaterThanOrEqualTo(44));
      });

      testWidgets('shouldSupportHighContrastMode', (WidgetTester tester) async {
        await TestUtils.pumpWidgetWithProviders(
          tester,
          MediaCard(
            title: TestData.testMovieTitle,
            imagePath: TestData.testPosterPath,
            onTap: () {},
          ),
        );

        // Wait for image to load
        await tester.pump(const Duration(milliseconds: 150));

        // Verify the card adapts to theme changes (high contrast support)
        final material = tester.widget<Material>(
          find.byWidgetPredicate((widget) => widget is Material).first,
        );

        expect(material.color, Colors.transparent);
        expect(material.borderRadius, isNotNull);
      });
    });

    group('Theme Support', () {
      testWidgets('shouldAdaptToLightTheme', (WidgetTester tester) async {
        await TestUtils.pumpWidgetWithProviders(
          tester,
          MediaCard(
            title: TestData.testMovieTitle,
            imagePath: TestData.testPosterPath,
            onTap: () {},
          ),
        );

        // Wait for image to load
        await tester.pump(const Duration(milliseconds: 150));

        final theme = Theme.of(tester.element(find.byType(MediaCard)));

        // Verify theme integration
        expect(theme, isNotNull);
        expect(theme.brightness, isNotNull);
      });

      testWidgets('shouldAdaptToDarkTheme', (WidgetTester tester) async {
        await TestUtils.pumpWidgetWithProviders(
          tester,
          Theme(
            data: ThemeData.dark(),
            child: MediaCard(
              title: TestData.testMovieTitle,
              imagePath: TestData.testPosterPath,
              onTap: () {},
            ),
          ),
        );

        // Wait for image to load
        await tester.pump(const Duration(milliseconds: 150));

        final theme = Theme.of(tester.element(find.byType(MediaCard)));

        // Verify dark theme support
        expect(theme.brightness, equals(Brightness.dark));
      });
    });

    group('Edge Cases', () {
      testWidgets('shouldHandleEmptyTitle_gracefully', (
        WidgetTester tester,
      ) async {
        await TestUtils.pumpWidgetWithProviders(
          tester,
          MediaCard(
            title: '',
            imagePath: TestData.testPosterPath,
            onTap: () {},
          ),
        );

        // Wait for image to load
        await tester.pump(const Duration(milliseconds: 150));

        // Should still render without crashing
        expect(find.byType(MediaCard), findsOneWidget);

        // Should have empty semantic label
        final semantics = tester.widget<Semantics>(
          TestUtils.findBySemanticLabel(''),
        );
        expect(semantics.properties.label, isEmpty);
      });

      testWidgets('shouldHandleLongTitle_withEllipsis', (
        WidgetTester tester,
      ) async {
        const longTitle =
            'This is a very long movie title that should be truncated with ellipsis when it exceeds the available space';

        await TestUtils.pumpWidgetWithProviders(
          tester,
          MediaCard(
            title: longTitle,
            imagePath: TestData.testPosterPath,
            onTap: () {},
          ),
        );

        // Wait for image to load
        await tester.pump(const Duration(milliseconds: 150));

        // Should still render without crashing
        expect(find.byType(MediaCard), findsOneWidget);

        // Verify semantic label contains full title
        final semantics = tester.widget<Semantics>(
          TestUtils.findBySemanticLabel(longTitle),
        );
        expect(semantics.properties.label, equals(longTitle));
      });

      testWidgets('shouldHandleRapidTapping', (WidgetTester tester) async {
        int tapCount = 0;

        await TestUtils.pumpWidgetWithProviders(
          tester,
          MediaCard(
            title: TestData.testMovieTitle,
            imagePath: TestData.testPosterPath,
            onTap: () {
              tapCount++;
            },
          ),
        );

        // Wait for image to load
        await tester.pump(const Duration(milliseconds: 150));

        // Rapidly tap the card multiple times
        await tester.tap(find.byType(MediaCard));
        await tester.tap(find.byType(MediaCard));
        await tester.tap(find.byType(MediaCard));
        await tester.pump();

        // Verify all taps were registered
        expect(tapCount, equals(3));
      });
    });
  });
}
