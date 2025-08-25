# Debounced, paginated search

- Implemented a new Riverpod StateNotifier for search at `lib/src/features/search/application/`:
  - `search_state.dart` defines the SearchState (query, page, items, loading flags, hasMore, error) and a helper to merge/sort Movie/Tv results by popularity.
  - `search_notifier.dart` manages debounced query updates (400ms), parallel fetching of movies and tv shows, pagination with guards, and stale-response protection via a requestId.

- Updated `SearchScreen` to use the provider:
  - TextField now drives `onQueryChanged` with debounce.
  - Infinite scrolling using a ScrollController; prefetch when 80% down.
  - Displays loading, error with retry, empty, and loading-more footer states.
  - Taps navigate to movie-detail or tv-detail as before.

- Combined results:
  - Results are merged (movies + tv) and sorted by popularity to create a single combined list by default, as agreed. This can be toggled later to tabs if desired.

Enhancements:
- Filter toggle: All/Movies/TV selection; default is All.
- Thumbnails: small poster previews in results.
- Clear button: reset query quickly.
- Persistence: last query and filter stored in SharedPreferences and restored on screen open.

Usage notes:
- Typing in the search bar triggers a debounced fetch. Clearing the text resets the state.
- Pagination: scrolling near the bottom loads the next page, provided `hasMore` is true and no in-flight request.
- Error handling: shows an error message with a Retry button. Stale responses are ignored safely.

