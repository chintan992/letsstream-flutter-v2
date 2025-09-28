# Let's Stream - Coding Rules & Guidelines

Follow modular agile coding architecture with clean code principles, maintainability, and scalability in mind.

## Core Principles

### Architecture Philosophy
- **Modular Design**: Break down features into independent, reusable modules
- **Separation of Concerns**: Clear separation between UI, business logic, and data layers
- **Dependency Injection**: Use providers for state management and dependency injection
- **Clean Architecture**: Follow clean architecture patterns with proper layering

### Code Quality Standards
- **SOLID Principles**: Apply Single Responsibility, Open-Closed, Liskov Substitution, Interface Segregation, and Dependency Inversion
- **DRY (Don't Repeat Yourself)**: Eliminate code duplication through abstraction and reuse
- **KISS (Keep It Simple, Stupid)**: Prefer simple solutions over complex ones
- **YAGNI (You Aren't Gonna Need It)**: Only implement what's currently needed

## File Organization Guidelines

### Maximum File Sizes
- **Keep each file under 400 lines** - Break larger files into smaller, focused modules
- **Widget files**: Max 300 lines for complex UI components
- **Service files**: Max 250 lines for business logic
- **Model files**: Max 200 lines for data structures

### Directory Structure
```
lib/
├── src/
│   ├── core/           # Core business logic, services, models
│   ├── features/       # Feature-based modules
│   └── shared/         # Shared components and utilities
```

## Flutter/Dart Specific Guidelines

### Widget Development
- **Stateless over Stateful**: Prefer StatelessWidget when possible
- **Composition over Inheritance**: Use widget composition instead of deep inheritance
- **Extract Custom Widgets**: Break complex widgets into smaller, reusable components
- **Proper Key Usage**: Use keys appropriately for widget identity and state preservation

### State Management
- **Riverpod for Complex State**: Use Riverpod for complex state management
- **Provider for Simple State**: Use Provider for simple state sharing
- **Local State**: Keep simple UI state local to widgets
- **Immutable State**: Treat state as immutable, create new instances for updates

### Performance Optimization
- **const Constructors**: Use const constructors where possible
- **Optimized Images**: Use appropriate image formats and sizes
- **ListView.builder**: Use builder patterns for long lists
- **Avoid Rebuilds**: Use Consumer/Selector to prevent unnecessary rebuilds

## Code Style Guidelines

### Naming Conventions
- **Classes**: PascalCase (e.g., `UserProfile`, `MovieService`)
- **Methods/Functions**: camelCase (e.g., `fetchUserData`, `calculateTotal`)
- **Variables**: camelCase (e.g., `userName`, `movieList`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `API_BASE_URL`, `MAX_RETRY_COUNT`)
- **Files**: snake_case (e.g., `user_profile.dart`, `movie_service.dart`)

### Code Formatting
- **Line Length**: Maximum 80-100 characters per line
- **Indentation**: 2 spaces (no tabs)
- **Trailing Commas**: Use trailing commas in collections and function calls
- **Import Organization**: Group imports by type (dart:, package:, relative)

### Documentation
- **Public APIs**: Document all public classes, methods, and properties
- **Complex Logic**: Add comments for complex business logic
- **TODO Comments**: Use TODO comments for future improvements
- **Method Documentation**: Use triple slash (///) for Dart documentation

## Testing Standards

### Testing Requirements
- **Unit Tests**: Write unit tests for business logic and services
- **Widget Tests**: Test widget rendering and interactions
- **Integration Tests**: Test complete user workflows
- **Test Coverage**: Aim for 80%+ code coverage for core features

### Testing Best Practices
- **Descriptive Test Names**: Use descriptive names like `shouldReturnUser_whenUserIdIsValid`
- **Arrange-Act-Assert**: Follow AAA pattern in tests
- **Mock Dependencies**: Mock external dependencies in unit tests
- **Test Data**: Use factories or builders for test data creation

## Error Handling

### Error Management
- **Custom Exceptions**: Create specific exception types for different error scenarios
- **Error Boundaries**: Implement proper error boundaries in UI
- **Graceful Degradation**: Handle errors gracefully with fallback UI
- **User-Friendly Messages**: Show meaningful error messages to users

### Logging Strategy
- **Structured Logging**: Use structured logging with consistent format
- **Log Levels**: Use appropriate log levels (debug, info, warning, error)
- **Sensitive Data**: Never log sensitive information like passwords or tokens
- **Performance Monitoring**: Log performance metrics for critical operations

## Security Guidelines

### Data Protection
- **API Keys**: Store API keys securely, never in source code
- **User Data**: Encrypt sensitive user data when storing locally
- **Network Security**: Use HTTPS for all network communications
- **Input Validation**: Validate all user inputs on both client and server

### Authentication & Authorization
- **Secure Storage**: Use secure storage for authentication tokens
- **Token Refresh**: Implement proper token refresh mechanisms
- **Session Management**: Handle session timeouts and invalidation
- **Biometric Auth**: Implement biometric authentication where appropriate

## Performance Guidelines

### Memory Management
- **Dispose Resources**: Properly dispose of controllers and streams
- **Image Caching**: Implement intelligent image caching strategies
- **Memory Leaks**: Avoid memory leaks through proper cleanup
- **Background Tasks**: Use isolates for heavy computations

### Network Optimization
- **Request Batching**: Batch multiple requests when possible
- **Caching Strategy**: Implement intelligent caching with TTL
- **Offline Support**: Provide offline functionality for core features
- **Background Sync**: Sync data in background when online

## Code Review Guidelines

### Review Checklist
- [ ] Code follows established patterns and conventions
- [ ] New features have appropriate tests
- [ ] Performance impact has been considered
- [ ] Security implications have been reviewed
- [ ] Documentation is updated
- [ ] Error handling is implemented
- [ ] Code is readable and maintainable

### Review Process
- **Self-Review**: Always self-review code before submitting
- **Peer Review**: Require peer review for all changes
- **Automated Checks**: Use linting and formatting tools
- **Continuous Integration**: Ensure all tests pass in CI/CD

## Git Workflow

### Branch Strategy
- **Feature Branches**: Create feature branches for new development
- **Naming Convention**: Use descriptive branch names (e.g., `feature/user-authentication`)
- **Pull Requests**: Use pull requests for code review
- **Branch Protection**: Protect main/master branch

### Commit Guidelines
- **Atomic Commits**: Each commit should represent a single logical change
- **Descriptive Messages**: Write clear, descriptive commit messages
- **Conventional Commits**: Follow conventional commit format when possible
- **Frequent Commits**: Commit early and often

## Continuous Improvement

### Code Metrics
- **Cyclomatic Complexity**: Keep complexity under 10 for most functions
- **Technical Debt**: Regularly address technical debt
- **Code Smells**: Use tools to identify and fix code smells
- **Refactoring**: Regularly refactor code for better maintainability

### Learning and Growth
- **Stay Updated**: Keep up with Flutter and Dart updates
- **Best Practices**: Continuously learn and apply best practices
- **Code Reviews**: Learn from code reviews and feedback
- **Team Knowledge**: Share knowledge and mentor team members

---

*These guidelines are living documents and should be updated as the project evolves and new best practices emerge.*
