# Let's Stream - Agent Guidelines

## Build/Lint/Test Commands
- **Build**: `flutter build apk` or `flutter build ios`
- **Lint**: `flutter analyze`
- **Test All**: `flutter test`
- **Single Test**: `flutter test test/cache_service_test.dart` (replace with specific test file)
- **Integration Tests**: `flutter test integration_test/`
- **Code Generation**: `dart run build_runner build --delete-conflicting-outputs`

## Code Style Guidelines
- **Naming**: PascalCase classes, camelCase methods/variables, snake_case files, SCREAMING_SNAKE_CASE constants
- **Formatting**: Single quotes, trailing commas, 80-100 char lines, 2-space indentation
- **Imports**: Group by type (dart:, package:, relative), no unused imports
- **Documentation**: Triple-slash (///) for public APIs, comprehensive doc comments
- **Architecture**: Clean architecture with core/features/shared layers, Riverpod state management
- **Performance**: const constructors, ListView.builder, avoid rebuilds, proper disposal
- **Error Handling**: Custom exceptions, graceful degradation, user-friendly messages
- **Testing**: 80%+ coverage, AAA pattern, mock dependencies, descriptive test names

## Additional Rules
- Include Cursor rules from `.kilocode/rules/flutter-rules.md` and `.kilocode/rules/rule.md`
- Follow SOLID principles, DRY, KISS, YAGNI
- Maximum file sizes: 400 lines total, 300 for widgets, 250 for services, 200 for models
- Prefer composition over inheritance, stateless over stateful widgets