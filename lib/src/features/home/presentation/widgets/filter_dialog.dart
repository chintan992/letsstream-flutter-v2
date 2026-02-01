import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/genre.dart';
import '../../../../core/services/tmdb_repository_provider.dart';
import '../../application/home_filter_provider.dart';

/// A modern, redesigned filter dialog for the home screen.
///
/// Features:
/// - Clean glassmorphism design with blur effect
/// - 4 tabs: Language, Genre, Year, Rating
/// - Blue accent colors matching new UI
/// - Responsive layout without overflow issues
/// - Chip-based selection for better UX
class FilterDialog extends ConsumerStatefulWidget {
  const FilterDialog({super.key});

  @override
  ConsumerState<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends ConsumerState<FilterDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(homeFilterProvider);
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    // Calculate active filters per tab
    final hasLanguageFilter = filterState.selectedLanguage != null;
    final hasGenreFilter = filterState.selectedGenre != null;
    final hasYearFilter = filterState.selectedYear != null;
    final hasRatingFilter = filterState.minRating != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenSize.width > 600 ? 40 : 16,
        vertical: 24,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 480,
              maxHeight: screenSize.height * 0.75,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                _buildHeader(context, filterState),

                // Tab Bar - simplified icons only
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    labelPadding: EdgeInsets.zero,
                    tabs: [
                      _buildTab(Icons.language, 'Language', hasLanguageFilter),
                      _buildTab(Icons.movie_outlined, 'Genre', hasGenreFilter),
                      _buildTab(Icons.calendar_month, 'Year', hasYearFilter),
                      _buildTab(Icons.star_outline, 'Rating', hasRatingFilter),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      _LanguageTab(),
                      _GenreTab(),
                      _YearTab(),
                      _RatingTab(),
                    ],
                  ),
                ),

                // Footer
                _buildFooter(context, filterState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, bool hasFilter) {
    return Tab(
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          if (hasFilter)
            Positioned(
              top: 4,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeFilterState filterState) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.tune,
              color: Colors.blueAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Filters',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (filterState.hasActiveFilter)
            TextButton(
              onPressed: () {
                ref.read(homeFilterProvider.notifier).clearAll();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: const Text('Clear'),
            ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, size: 22),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, HomeFilterState filterState) {
    final activeCount = _getActiveFilterCount(filterState);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          if (activeCount > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$activeCount filter${activeCount > 1 ? 's' : ''} active',
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const Spacer(),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Apply',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  int _getActiveFilterCount(HomeFilterState state) {
    int count = 0;
    if (state.selectedLanguage != null) count++;
    if (state.selectedGenre != null) count++;
    if (state.selectedYear != null) count++;
    if (state.minRating != null) count++;
    return count;
  }
}

// ============================================================================
// Language Tab - Chip-based selection
// ============================================================================
class _LanguageTab extends ConsumerWidget {
  const _LanguageTab();

  static const List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'es', 'name': 'Spanish', 'flag': '🇪🇸'},
    {'code': 'fr', 'name': 'French', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'German', 'flag': '🇩🇪'},
    {'code': 'it', 'name': 'Italian', 'flag': '🇮🇹'},
    {'code': 'pt', 'name': 'Portuguese', 'flag': '🇵🇹'},
    {'code': 'ru', 'name': 'Russian', 'flag': '🇷🇺'},
    {'code': 'ja', 'name': 'Japanese', 'flag': '🇯🇵'},
    {'code': 'ko', 'name': 'Korean', 'flag': '🇰🇷'},
    {'code': 'zh', 'name': 'Chinese', 'flag': '🇨🇳'},
    {'code': 'hi', 'name': 'Hindi', 'flag': '🇮🇳'},
    {'code': 'ar', 'name': 'Arabic', 'flag': '🇸🇦'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(homeFilterProvider);
    final selectedLanguage = filterState.selectedLanguage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: languages.map((lang) {
          final isSelected = selectedLanguage == lang['code'];
          return _LanguageChip(
            flag: lang['flag']!,
            name: lang['name']!,
            isSelected: isSelected,
            onTap: () {
              if (isSelected) {
                ref.read(homeFilterProvider.notifier).setLanguage(null);
              } else {
                ref.read(homeFilterProvider.notifier).setLanguage(lang['code']);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String flag;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageChip({
    required this.flag,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blueAccent.withValues(alpha: 0.2)
                : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Colors.blueAccent
                  : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(flag, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? Colors.blueAccent
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 6),
                const Icon(Icons.check, size: 16, color: Colors.blueAccent),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Genre Tab - Grid of genre chips
// ============================================================================
class _GenreTab extends ConsumerWidget {
  const _GenreTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genresAsync = ref.watch(movieGenresProvider);
    final filterState = ref.watch(homeFilterProvider);
    final selectedGenre = filterState.selectedGenre;

    return genresAsync.when(
      data: (genres) {
        if (genres.isEmpty) {
          return const Center(
            child: Text('No genres available'),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: genres.map((genre) {
              final isSelected = selectedGenre?.id == genre.id;
              return _GenreChip(
                name: genre.name,
                isSelected: isSelected,
                onTap: () {
                  if (isSelected) {
                    ref.read(homeFilterProvider.notifier).setGenre(null);
                  } else {
                    ref.read(homeFilterProvider.notifier).setGenre(genre);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      ),
      error: (_, __) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            const Text('Failed to load genres'),
          ],
        ),
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenreChip({
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blueAccent
                : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Colors.blueAccent
                  : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            name,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Year Tab - Scrollable year grid
// ============================================================================
class _YearTab extends ConsumerWidget {
  const _YearTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(homeFilterProvider);
    final selectedYear = filterState.selectedYear;
    final currentYear = DateTime.now().year;
    final years = List.generate(50, (index) => currentYear - index);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: years.length,
      itemBuilder: (context, index) {
        final year = years[index];
        final isSelected = selectedYear == year;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (isSelected) {
                ref.read(homeFilterProvider.notifier).setYear(null);
              } else {
                ref.read(homeFilterProvider.notifier).setYear(year);
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blueAccent
                    : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? Colors.blueAccent
                      : Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  year.toString(),
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// Rating Tab - Star-based selection
// ============================================================================
class _RatingTab extends ConsumerWidget {
  const _RatingTab();

  static const List<Map<String, dynamic>> ratings = [
    {'value': 9.0, 'label': '9+ Exceptional', 'stars': 5},
    {'value': 8.0, 'label': '8+ Excellent', 'stars': 4},
    {'value': 7.0, 'label': '7+ Good', 'stars': 3},
    {'value': 6.0, 'label': '6+ Fair', 'stars': 2},
    {'value': 5.0, 'label': '5+ Average', 'stars': 1},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(homeFilterProvider);
    final selectedRating = filterState.minRating;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: ratings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final rating = ratings[index];
        final value = rating['value'] as double;
        final isSelected = selectedRating == value;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (isSelected) {
                ref.read(homeFilterProvider.notifier).setRating(null);
              } else {
                ref.read(homeFilterProvider.notifier).setRating(value);
              }
            },
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blueAccent.withValues(alpha: 0.15)
                    : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? Colors.blueAccent
                      : Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  // Stars
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      rating['stars'] as int,
                      (starIndex) => Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Label
                  Expanded(
                    child: Text(
                      rating['label'] as String,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 15,
                        color: isSelected
                            ? Colors.blueAccent
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  // Check mark
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// Provider for movie genres
// ============================================================================
final movieGenresProvider = FutureProvider<List<Genre>>((ref) async {
  final repository = ref.watch(tmdbRepositoryProvider);
  final genreMap = await repository.getMovieGenres();
  return genreMap.entries
      .map((entry) => Genre(id: entry.key, name: entry.value))
      .toList();
});
