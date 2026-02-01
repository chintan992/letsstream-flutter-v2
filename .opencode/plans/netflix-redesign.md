# Netflix UI Redesign Plan

## Goal
Transform the current "Let's Stream" Flutter app UI to match Netflix's design language, including dark theme, red accents, content-focused layout, and Netflix-style components.

## Overview
This app currently has 21 screens with 21 different color themes. We'll consolidate to a Netflix-focused design system while maintaining the existing architecture and functionality.

## Design System Reference

### Netflix Brand Colors
- **Primary Red**: #E50914 (Netflix red)
- **Background Black**: #141414 (main background)
- **Dark Gray**: #1F1F1F (card backgrounds, inputs)
- **Medium Gray**: #2F2F2F (hover states, borders)
- **Light Gray**: #808080 (secondary text, disabled states)
- **White**: #FFFFFF (primary text, icons)

### Netflix Typography
- **Display Font**: Netflix Sans (or Bebas Neue alternative) - bold, condensed
- **Body Font**: Netflix Sans / Inter - clean, readable
- **Type Scale**: Large bold headers, smaller body text

### Netflix UI Patterns
- Full-bleed hero banners with gradient overlays
- Horizontal content rows (carousels)
- Minimal chrome - content is king
- Poster aspect ratio 2:3 with rounded corners (4px)
- Large circular play buttons
- Bottom navigation bar with 5 items
- Category tabs at top
- Dark mode only (no light theme)

---

## Phase 1: Create Netflix Design System

**Files to Modify/Created:**
- `lib/src/shared/theme/netflix_colors.dart` (NEW)
- `lib/src/shared/theme/netflix_theme.dart` (NEW)
- `lib/src/shared/theme/netflix_typography.dart` (NEW)
- `lib/src/shared/theme/app_theme.dart` (MODIFY - add Netflix theme)

### Tasks:
1. **Create Netflix Colors File**
   - Define all Netflix brand colors
   - Create color constants class
   - Add semantic color names (background, surface, primary, etc.)

2. **Create Netflix Typography**
   - Define Netflix-style text theme
   - Bold headers, smaller body text
   - Use Google Fonts (Bebas Neue + Inter)
   - Large display sizes for hero text

3. **Create Netflix Theme Data**
   - ThemeData with Netflix colors
   - Component themes (AppBar, Card, Button, Input)
   - Netflix-specific theme extensions

4. **Update Theme Switcher**
   - Make Netflix theme the default
   - Remove or hide other themes (optional)
   - Add Netflix theme to theme list

**Verification:**
- Run `flutter analyze` - no errors
- App builds successfully
- Netflix colors visible in UI

---

## Phase 2: Redesign Navigation

**Files to Modify:**
- `lib/src/core/router/app_router.dart`
- `lib/src/features/home/presentation/main_navigation_screen.dart` (or wherever MainNavigationScreen is)

### Tasks:
1. **Update Bottom Navigation Items**
   - Change to Netflix-style 5 tabs:
     - Home (Home icon)
     - Search (Search icon) - currently separate screen
     - New & Hot (Coming Soon/Flame icon) - combine Movies/TV
     - My List (Downloads/Bookmark icon) - rename Watchlist
     - Profile (Profile icon)

2. **Redesign Bottom Navigation Bar**
   - Black background (#141414)
   - White icons, red when selected
   - Netflix-style labels below icons
   - Remove elevation/shadow
   - Smaller height (56dp)

3. **Update Router Configuration**
   - Reorganize routes to match new nav structure
   - Add New & Hot route (combines trending content)
   - Rename watchlist route to "my-list"

**Verification:**
- Navigation works between all tabs
- Icons match Netflix style
- Active tab shows red color

---

## Phase 3: Redesign Home Screen

**Files to Modify:**
- `lib/src/features/home/presentation/home_screen.dart`
- `lib/src/features/home/presentation/widgets/hero_carousel.dart`
- `lib/src/features/home/presentation/widgets/media_horizontal_list.dart`

### Tasks:
1. **Redesign AppBar**
   - Transparent background
   - Netflix logo on left
   - Category chips on right (TV Shows, Movies, Categories)
   - Profile icon far right

2. **Redesign Hero Carousel**
   - Full-screen height (85% of screen)
   - Dark gradient overlay from bottom (for text readability)
   - Large title text (bold, white)
   - Play button (red, large, circular)
   - Add to List button (gray, outline)
   - Info button
   - Category tags below buttons
   - Mute/Unmute button top right
   - Netflix-style pagination dots

3. **Redesign Content Rows**
   - Section titles: "Popular on Netflix", "Trending Now", "Top 10", etc.
   - Smaller titles (16-18sp), white, bold
   - Full-bleed horizontal scroll
   - Remove padding between cards (edge-to-edge)
   - "Preview All" arrow on right

4. **Add Category Chips**
   - Horizontal scroll at top
   - Chips: "TV Shows", "Movies", "Categories"
   - White text on transparent background
   - Underline indicator for selected

5. **Background Color**
   - Full black background (#141414)
   - No card backgrounds - direct on black

**Verification:**
- Home screen resembles Netflix home
- Hero banner full width
- Content rows scroll horizontally
- Category chips visible

---

## Phase 4: Redesign Media Cards

**Files to Modify:**
- `lib/src/shared/widgets/media_card.dart`
- `lib/src/shared/widgets/enhanced_media_card.dart`
- `lib/src/shared/widgets/animated_media_card.dart`

### Tasks:
1. **Netflix Poster Card Design**
   - Aspect ratio: 2:3 (movie poster)
   - Border radius: 4px (small)
   - No border
   - Shadow: subtle on hover
   - Remove title overlay (Netflix shows titles below)

2. **Hover/Focus Effects**
   - Scale up on hover (1.1x)
   - Slight shadow elevation
   - No rotation or complex transforms
   - Smooth 200ms animation

3. **Row Layout**
   - Cards edge-to-edge (no gap)
   - Peek of next card visible (20-30px)
   - Consistent height within row
   - Variable widths for different row types

4. **Top 10 Card Variant**
   - Number badge (1-10) on left
   - Gradient red background for number
   - Poster on right side
   - Special layout for top 10 row

5. **Continue Watching Card**
   - Progress bar at bottom
   - Red progress indicator
   - "Play Again" overlay on hover
   - Smaller card size

6. **Remove Excess Info**
   - No rating badges on cards
   - No year overlays
   - Minimal chrome - poster only
   - Title appears on detail view only

**Verification:**
- Cards match Netflix poster style
- Hover effects work smoothly
- Different card types render correctly

---

## Phase 5: Redesign Detail Screen

**Files to Modify:**
- `lib/src/features/detail/presentation/enhanced_detail_screen.dart`
- `lib/src/features/detail/presentation/netflix_detail_screen.dart`
- `lib/src/features/detail/presentation/widgets/`

### Tasks:
1. **Layout Structure**
   - Full-bleed hero image at top (60% height)
   - Dark gradient overlay
   - Content below image (overlapping)

2. **Hero Section**
   - Large backdrop image
   - Gradient fade to black at bottom
   - Back button (white, top left)
   - Share button (top right)

3. **Content Section**
   - Title: Large, bold, white (32-40sp)
   - Metadata row: Year, Rating, Duration, Quality badges
   - Play button: Full width, red, large
   - Download button: Full width, gray
   - Add to My List button
   - Rate (thumbs up/down)

4. **Info Section**
   - Synopsis text (white, 16sp)
   - Cast, Director, Genres
   - Collapsible sections

5. **Episodes Section (TV)**
   - Season selector dropdown
   - Episode cards horizontal
   - Episode thumbnail, number, title, duration

6. **More Like This Section**
   - Grid of 3 columns
   - Same poster cards
   - Scrollable

7. **Trailers Section**
   - Horizontal scroll
   - Large thumbnail with play icon
   - Trailer title below

**Verification:**
- Detail screen matches Netflix
- Hero image full width
- Buttons Netflix-style
- Episodes section for TV shows

---

## Phase 6: Redesign Search Screen

**Files to Modify:**
- `lib/src/features/search/presentation/search_screen.dart`

### Tasks:
1. **Search Header**
   - Search bar at top
   - Black background (#141414)
   - Gray search field with white text
   - Mic icon for voice search

2. **Search Results**
   - Grid layout (3 columns)
   - Poster cards
   - No text labels (image only)

3. **Browse Categories**
   - Category grid when no search
   - Large category tiles
   - Genre images with text overlay
   - Action & Adventure, Anime, Children & Family, etc.

4. **Recent Searches**
   - List of recent queries
   - Clear history option

5. **Top Searches**
   - Trending searches list
   - Ranking numbers (1, 2, 3...)

**Verification:**
- Search bar Netflix style
- Category browse visible
- Results in grid format

---

## Phase 7: Redesign Watchlist (My List)

**Files to Modify:**
- `lib/src/features/watchlist/presentation/watchlist_screen.dart`
- `lib/src/features/watchlist/widgets/watchlist_item_card.dart`

### Tasks:
1. **Screen Layout**
   - "My List" title at top
   - Grid layout (3 columns)
   - Black background
   - Edit button top right

2. **Grid Cards**
   - Poster cards in grid
   - No additional info visible
   - Long press for options

3. **Empty State**
   - "Your list is empty"
   - Icon or illustration
   - "Browse content to add"

4. **Sorting/Filtering**
   - Sort button (added date, title, etc.)
   - Filter by type (Movies, TV)

5. **Edit Mode**
   - Checkboxes to select multiple
   - Delete selected button
   - Cancel button

**Verification:**
- Grid layout matches Netflix
- Edit mode works
- Empty state styled correctly

---

## Phase 8: Redesign Profile Screen

**Files to Modify:**
- `lib/src/features/profile/presentation/profile_screen.dart`
- `lib/src/features/profile/presentation/widgets/`

### Tasks:
1. **Profile Selection (if multi-profile)**
   - "Who's Watching?" screen
   - Profile avatars in grid
   - Add Profile button
   - Manage Profiles option

2. **Profile Menu (More tab)**
   - Profile avatar at top
   - User name
   - Account email
   - List of menu items:
     - Notifications
     - My List
     - App Settings
     - Account
     - Help
     - Sign Out

3. **Settings Section**
   - Playback settings
   - Download quality
   - Wi-Fi only toggle
   - Smart downloads

4. **Theme Settings**
   - Keep Netflix theme as default
   - Optional: hide theme switcher
   - Or show as "App Appearance"

5. **Menu Styling**
   - White text on black
   - Chevron icons on right
   - Divider lines between items
   - Icons for each setting

**Verification:**
- Profile menu Netflix style
- Settings accessible
- Sign out works

---

## Phase 9: Redesign Other Screens

**Files to Modify:**
- `lib/src/features/movies/presentation/movies_list_screen.dart`
- `lib/src/features/tv_shows/presentation/tv_list_screen.dart`
- `lib/src/features/anime/presentation/anime_screen.dart`
- `lib/src/features/hub/presentation/netflix_hub_screen.dart`

### Tasks:
1. **Movies List Screen**
   - Merge into "New & Hot" or Categories
   - Or keep as genre-based grid
   - Netflix-style filtering

2. **TV Shows Screen**
   - Same treatment as Movies
   - Consistent with Netflix layout

3. **Anime Screen**
   - Apply Netflix styling
   - Anime-specific row: "Anime"
   - Same patterns as other content

4. **Hub Screen**
   - Redesign as "Browse" or "Categories"
   - Grid of content categories
   - Large category tiles

5. **Genre List Screens**
   - Grid layout
   - Filter chips at top
   - Sort options

**Verification:**
- All screens use Netflix theme
- Consistent navigation
- Content displays correctly

---

## Phase 10: Redesign Shared Widgets

**Files to Modify:**
- `lib/src/shared/widgets/shimmer_box.dart`
- `lib/src/shared/widgets/empty_state.dart`
- `lib/src/shared/widgets/error_state.dart`
- `lib/src/shared/widgets/optimized_image.dart`
- `lib/src/shared/widgets/media_carousel.dart`

### Tasks:
1. **Loading States (Shimmer)**
   - Dark gray shimmer (#2F2F2F)
   - Netflix-style pulse animation
   - Poster card skeletons
   - Hero banner skeleton

2. **Empty States**
   - Dark background
   - White text
   - Simple icons
   - Netflix-style illustrations (optional)

3. **Error States**
   - Red accent for errors
   - Retry button Netflix style
   - Clear error messaging

4. **Buttons**
   - Primary: Red background (#E50914), white text
   - Secondary: Gray background, white text
   - Outline: Gray border, white text
   - Large touch targets (48dp min)
   - Rounded corners (4px)

5. **Icons**
   - White icons on dark backgrounds
   - Red when active/selected
   - Consistent icon set (Material or custom)

6. **Image Loading**
   - Dark placeholder while loading
   - Fade-in animation
   - Error state with retry

**Verification:**
- Shimmer dark themed
- Buttons Netflix style
- Icons white/red

---

## Phase 11: Video Player Styling

**Files to Modify:**
- `lib/src/features/video_player/presentation/video_player_screen.dart`
- `lib/src/features/anime/presentation/widgets/custom_anime_controls.dart`

### Tasks:
1. **Player Controls**
   - Dark control bar
   - Red progress bar
   - White icons
   - Large play/pause button

2. **Progress Bar**
   - Red color (#E50914)
   - White buffered indicator
   - Gray background
   - Large touch target

3. **Control Layout**
   - Play/Pause: Left
   - Progress: Center (expanded)
   - Time: Right
   - Fullscreen, Settings, Subtitles: Far right

4. **Gestures**
   - Tap to show/hide controls
   - Double-tap to seek
   - Swipe for volume/brightness

5. **Next Episode Button**
   - Netflix-style countdown
   - "Next Episode" button
   - Auto-advance

**Verification:**
- Player controls Netflix style
- Progress bar red
- Gestures work

---

## Dependencies to Add

Add to `pubspec.yaml`:

```yaml
dependencies:
  # Fonts
  google_fonts: ^6.2.1
  
  # Icons (if needed)
  # Already using Material Icons
  
dev_dependencies:
  # Keep existing
```

---

## Verification Checklist

Before completing:

- [ ] All 21 screens use Netflix theme
- [ ] Bottom navigation matches Netflix (5 tabs)
- [ ] Home screen has hero banner + content rows
- [ ] Media cards are 2:3 poster style
- [ ] Detail screen has Netflix layout
- [ ] Search screen has category browse
- [ ] Watchlist renamed to "My List"
- [ ] Profile screen has Netflix menu
- [ ] All buttons are Netflix styled
- [ ] Loading states are dark themed
- [ ] Video player has red progress bar
- [ ] `flutter analyze` passes
- [ ] App builds without errors
- [ ] Navigation works between all screens

---

## Post-Implementation Steps

1. Run `flutter analyze` to check for errors
2. Run `flutter test` to ensure tests pass
3. Build APK: `flutter build apk`
4. Test on device for:
   - Performance
   - Touch targets
   - Scroll performance
   - Image loading
   - Video playback

## Notes

- Keep existing functionality - only change UI
- Maintain Riverpod state management
- Preserve API integration
- Keep existing models and services
- Focus on visual redesign only
- Test on multiple screen sizes
- Consider tablet layout variations