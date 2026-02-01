import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/features/search/application/search_notifier.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/features/search/application/search_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_stream/src/shared/theme/netflix_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

const List<String> kTopSearches = [
  'Stranger Things',
  'The Witcher',
  'Wednesday',
  'Squid Game',
  'Money Heist',
  'Breaking Bad',
  'The Crown',
  'Black Mirror',
  'Ozark',
  'You',
];

const List<String> kCategories = [
  'Action',
  'Comedy',
  'Drama',
  'Horror',
  'Romance',
  'Sci-Fi',
  'Thriller',
  'Documentary',
];

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadRecentSearches();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchNotifierProvider.notifier).loadPersisted().then((q) {
        if (!mounted) return;
        _controller.text = q;
      });
    });
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _recentSearches = prefs.getStringList('search.recent') ?? [];
      });
    }
  }

  Future<void> _addRecentSearch(String query) async {
    if (query.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList('search.recent') ?? [];
    
    searches.remove(query);
    searches.insert(0, query);
    
    if (searches.length > 10) {
      searches.removeLast();
    }
    
    await prefs.setStringList('search.recent', searches);
    
    if (mounted) {
      setState(() {
        _recentSearches = searches;
      });
    }
  }

  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search.recent');
    if (mounted) {
      setState(() {
        _recentSearches = [];
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;
    if (offset >= max * 0.8) {
      ref.read(searchNotifierProvider.notifier).fetchNextPage();
    }
  }

  void _onSearch(String query) {
    ref.read(searchNotifierProvider.notifier).onQueryChanged(query);
    if (query.isNotEmpty) {
      _addRecentSearch(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);

    return Scaffold(
      backgroundColor: NetflixColors.backgroundBlack,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(searchState),
            Expanded(
              child: searchState.query.isEmpty
                  ? _buildBrowseView()
                  : _buildSearchResults(searchState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(SearchState searchState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: NetflixColors.backgroundBlack,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: NetflixColors.surfaceMedium,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(
              Icons.search,
              color: NetflixColors.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: const TextStyle(
                  color: NetflixColors.textPrimary,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: NetflixColors.textSecondary,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                textInputAction: TextInputAction.search,
                onChanged: (value) => ref
                    .read(searchNotifierProvider.notifier)
                    .onQueryChanged(value),
                onSubmitted: _onSearch,
              ),
            ),
            if (_controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: NetflixColors.textSecondary,
                  size: 20,
                ),
                onPressed: () {
                  _controller.clear();
                  ref
                      .read(searchNotifierProvider.notifier)
                      .onQueryChanged('');
                },
              ),
            IconButton(
              icon: Icon(
                Icons.mic,
                color: NetflixColors.textSecondary,
                size: 24,
              ),
              onPressed: () {
                // Voice search not implemented
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseView() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            _buildSectionHeader('Recent Searches', onClear: _clearRecentSearches),
            ..._recentSearches.map((query) => _buildRecentSearchTile(query)),
            const SizedBox(height: 24),
          ],
          
          // Top Searches
          _buildSectionHeader('Top Searches'),
          ...kTopSearches.map((query) => _buildTopSearchTile(query)),
          const SizedBox(height: 24),
          
          // Browse Categories
          _buildSectionHeader('Browse by Category'),
          const SizedBox(height: 12),
          _buildCategoryGrid(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onClear}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: NetflixColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (onClear != null)
            TextButton(
              onPressed: onClear,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Clear',
                style: TextStyle(
                  color: NetflixColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchTile(String query) {
    return ListTile(
      leading: const Icon(
        Icons.access_time,
        color: NetflixColors.textSecondary,
        size: 20,
      ),
      title: Text(
        query,
        style: const TextStyle(
          color: NetflixColors.textPrimary,
          fontSize: 14,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.north_west,
          color: NetflixColors.textSecondary,
          size: 18,
        ),
        onPressed: () {
          _controller.text = query;
          _onSearch(query);
        },
      ),
      onTap: () {
        _controller.text = query;
        _onSearch(query);
      },
    );
  }

  Widget _buildTopSearchTile(String query) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 56,
        decoration: BoxDecoration(
          color: NetflixColors.surfaceMedium,
          borderRadius: BorderRadius.circular(2),
        ),
        child: const Icon(
          Icons.movie,
          color: NetflixColors.textSecondary,
          size: 24,
        ),
      ),
      title: Text(
        query,
        style: const TextStyle(
          color: NetflixColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.play_arrow,
        color: NetflixColors.textSecondary,
        size: 24,
      ),
      onTap: () {
        _controller.text = query;
        _onSearch(query);
      },
    );
  }

  Widget _buildCategoryGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2.5,
        ),
        itemCount: kCategories.length,
        itemBuilder: (context, index) {
          final category = kCategories[index];
          return _buildCategoryTile(category);
        },
      ),
    );
  }

  Widget _buildCategoryTile(String category) {
    return Container(
      decoration: BoxDecoration(
        color: NetflixColors.surfaceMedium,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _controller.text = category;
            _onSearch(category);
          },
          borderRadius: BorderRadius.circular(4),
          child: Center(
            child: Text(
              category,
              style: const TextStyle(
                color: NetflixColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(SearchState searchState) {
    if (searchState.isLoading && searchState.items.isEmpty) {
      return _buildShimmerGrid();
    }

    if (searchState.error != null && searchState.items.isEmpty) {
      return _buildErrorState(searchState.error!);
    }

    if (searchState.items.isEmpty) {
      return _buildNoResultsState(searchState.query);
    }

    final visibleItems = searchState.filteredItems();
    final itemCount = visibleItems.length +
        ((searchState.isLoadingMore || searchState.hasMore) ? 1 : 0);
    final imageBase = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';

    return Column(
      children: [
        // Filter tabs
        _buildFilterTabs(searchState),
        
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 16,
              childAspectRatio: 2 / 3,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index >= visibleItems.length) {
                if (searchState.isLoadingMore) {
                  return const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: NetflixColors.primaryRed,
                      ),
                    ),
                  );
                }
                if (searchState.hasMore) {
                  return Center(
                    child: TextButton(
                      onPressed: () => ref
                          .read(searchNotifierProvider.notifier)
                          .fetchNextPage(),
                      child: const Text(
                        'Load more',
                        style: TextStyle(color: NetflixColors.textSecondary),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }

              final item = visibleItems[index];
              String? posterPath;
              int itemId;
              String routeName;

              if (item is Movie) {
                posterPath = item.posterPath;
                itemId = item.id;
                routeName = 'movie-detail';
              } else if (item is TvShow) {
                posterPath = item.posterPath;
                itemId = item.id;
                routeName = 'tv-detail';
              } else {
                return const SizedBox.shrink();
              }

              final imageUrl = (posterPath != null && posterPath.isNotEmpty)
                  ? '$imageBase/w342$posterPath'
                  : null;

              return _buildPosterCard(imageUrl, itemId, routeName, item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs(SearchState searchState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildFilterChip('All', SearchFilter.all, searchState),
          const SizedBox(width: 8),
          _buildFilterChip('Movies', SearchFilter.movies, searchState),
          const SizedBox(width: 8),
          _buildFilterChip('TV Shows', SearchFilter.tv, searchState),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, SearchFilter filter, SearchState state) {
    final isSelected = state.filter == filter;
    
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? NetflixColors.backgroundBlack
              : NetflixColors.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          ref.read(searchNotifierProvider.notifier).setFilter(filter);
        }
      },
      backgroundColor: NetflixColors.surfaceMedium,
      selectedColor: NetflixColors.textPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide.none,
      ),
    );
  }

  Widget _buildPosterCard(
    String? imageUrl,
    int itemId,
    String routeName,
    dynamic item,
  ) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        routeName,
        pathParameters: {'id': itemId.toString()},
        extra: item,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: NetflixColors.surfaceMedium,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: NetflixColors.surfaceMedium,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: NetflixColors.surfaceMedium,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: NetflixColors.textSecondary,
                    ),
                  ),
                )
              : Container(
                  color: NetflixColors.surfaceMedium,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: NetflixColors.textSecondary,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
        childAspectRatio: 2 / 3,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: NetflixColors.surfaceMedium,
          highlightColor: NetflixColors.surfaceLight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: NetflixColors.surfaceMedium,
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: NetflixColors.textSecondary,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: const TextStyle(
                color: NetflixColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(
                color: NetflixColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () =>
                  ref.read(searchNotifierProvider.notifier).retry(),
              icon: const Icon(Icons.refresh, color: NetflixColors.textPrimary),
              label: const Text(
                'Try Again',
                style: TextStyle(color: NetflixColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              color: NetflixColors.textSecondary,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found for "$query"',
              style: const TextStyle(
                color: NetflixColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Try different keywords or check your spelling',
              style: TextStyle(
                color: NetflixColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () {
                _controller.clear();
                ref
                    .read(searchNotifierProvider.notifier)
                    .onQueryChanged('');
              },
              icon: const Icon(Icons.clear, color: NetflixColors.textPrimary),
              label: const Text(
                'Clear Search',
                style: TextStyle(color: NetflixColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
