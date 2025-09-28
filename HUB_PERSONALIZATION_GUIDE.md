# Hub Personalization Guide

## For Users

### How to Personalize Your Hub Experience

1. **Access Personalization Settings**
   - Open the Hub tab in the app
   - Look for the personalization icon (👤) in the top-right corner
   - Tap the icon to open personalization settings

2. **Enable Personalization**
   - Toggle the "Enable Personalization" switch
   - When enabled, you'll see personalized content sections at the top of movies and TV shows

3. **Select Your Preferred Genres**
   - Choose from popular movie genres like Action, Comedy, Drama, Sci-Fi, etc.
   - Select multiple genres that match your interests
   - Your selections will influence the "Recommended for You" section

4. **Choose Your Streaming Platforms**
   - Select the platforms you have access to (Netflix, Prime Video, Disney+, etc.)
   - The app will prioritize content from your selected platforms
   - This creates a "From Your Preferred Platforms" section

5. **Save Your Preferences**
   - Tap "Save" to apply your settings
   - The hub will automatically refresh with personalized content
   - You'll see a success message confirming your preferences were saved

### What You'll See After Personalization

- **"Recommended for You"** - Movies/shows based on your favorite genres
- **"Based on Your Preferences"** - Content specifically matching your genre selections
- **"From Your Preferred Platforms"** - Shows from your chosen streaming services
- **Enhanced Discovery** - More relevant content suggestions throughout the hub

### Managing Your Preferences

- **Change Anytime**: Tap the personalization icon to update your preferences
- **Disable Personalization**: Turn off the toggle to return to standard categories
- **Mix & Match**: Select any combination of genres and platforms

## For Developers

### Architecture Overview

The personalization system consists of several key components:

### Core Services

**UserPreferencesService** (`user_preferences_service.dart`)
- Manages user preference storage using SharedPreferences
- Handles genre preferences, platform preferences, and personalization settings
- Provides methods for reading/writing user data

**ContentConstants** (`content_constants.dart`)
- Defines available genres and streaming platforms with TMDB IDs
- Provides default preferences for new users
- Contains genre combinations and personalized section titles

### State Management

**Enhanced HubState** (`hub_notifier.dart`)
- Extended with personalization fields
- Includes user preferences in state
- Manages personalized content alongside standard content

**HubNotifier Methods**
```dart
// Load user preferences
_loadUserPreferences()

// Fetch personalized content
_fetchPersonalizedContent()

// Update preferences
updatePreferences({
  List<int>? preferredGenres,
  List<int>? preferredPlatforms,
  bool? personalizationEnabled,
})
```

### UI Components

**PersonalizationButton** (`hub_screens.dart`)
- Icon button that changes appearance based on personalization status
- Opens personalization dialog when tapped

**PersonalizationDialog**
- Modal dialog for preference selection
- Uses FilterChips for genre/platform selection
- Provides immediate feedback on preference updates

### Data Flow

1. **Initialization**
   ```
   HubNotifier constructor → _initializeHub() → _loadUserPreferences() → _fetchAll()
   ```

2. **Content Loading Strategy**
   ```
   Basic Content (trending, popular, etc.) → Expanded Genres → Expanded Platforms → Personalized Content
   ```

3. **Preference Updates**
   ```
   User saves preferences → updatePreferences() → refresh personalized content → update UI
   ```

### Adding New Features

#### Adding More Genres
1. Add genre ID and name to `ContentConstants.popularMovieGenres` or `popularTvGenres`
2. Add corresponding state fields to `HubState`
3. Add API calls in `_fetchExpandedGenres()`
4. Add UI sections in `_MoviesHubBody` or `_TvHubBody`

#### Adding More Platforms
1. Add platform ID and name to `ContentConstants.streamingPlatforms`
2. Add corresponding state fields to `HubState`
3. Add API calls in `_fetchExpandedPlatforms()`
4. Add UI sections in hub bodies

#### Adding Personalization Features
1. Extend `UserPreferencesService` with new preference methods
2. Add preference fields to `HubState`
3. Update `_fetchPersonalizedContent()` logic
4. Add UI controls in `_PersonalizationDialog`

### Performance Considerations

**Caching Strategy**
- Standard content: 2-hour cache
- User preferences: Persistent storage
- Personalized content: Refreshed when preferences change

**Loading Optimization**
- Parallel API calls for different content types
- Graceful degradation if personalized content fails
- Loading states for better UX

**Memory Management**
- Conditional rendering based on content availability
- Efficient state updates with Freezed

### Testing Guidelines

**Unit Tests**
- Test `UserPreferencesService` methods
- Test `HubNotifier` state management
- Test preference persistence

**Widget Tests**
- Test personalization dialog interactions
- Test preference selection UI
- Test content rendering based on preferences

**Integration Tests**
- Test full personalization flow
- Test preference updates affecting content
- Test offline behavior

### Debugging Tips

**Preference Issues**
- Check SharedPreferences storage
- Verify ContentConstants genre/platform IDs
- Monitor API calls for personalized content

**UI Issues**
- Check conditional rendering logic
- Verify state updates in HubNotifier
- Test dialog interactions

**Performance Issues**
- Monitor API call parallelization
- Check cache hit rates
- Profile widget rebuilds

### Extension Points

The system is designed to be easily extensible:

- **New Content Types**: Add anime, documentaries, etc.
- **Advanced Personalization**: Machine learning recommendations
- **Social Features**: Friend recommendations
- **Analytics**: User behavior tracking
- **A/B Testing**: Different personalization strategies

This architecture provides a solid foundation for future enhancements while maintaining code quality and performance.