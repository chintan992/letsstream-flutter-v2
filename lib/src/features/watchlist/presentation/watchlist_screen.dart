import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/watchlist_item.dart';
import '../../../core/models/movie.dart';
import '../../../core/models/tv_show.dart';
import '../../../core/providers/watchlist_providers.dart';
import '../../../shared/theme/netflix_colors.dart';
import '../../../shared/widgets/media_card.dart';

/// Netflix-style "My List" screen for saved content.
/// Features a 3-column grid layout with edit mode support.
class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key});

  @override
  ConsumerState<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  bool _isEditMode = false;
  final Set<String> _selectedItems = {};

  @override
  Widget build(BuildContext context) {
    final watchlistState = ref.watch(watchlistNotifierProvider);
    final filteredItems = ref.watch(filteredWatchlistItemsProvider);
    final isLoading = ref.watch(watchlistLoadingProvider);
    final error = ref.watch(watchlistErrorProvider);

    return Scaffold(
      backgroundColor: NetflixColors.backgroundBlack,
      appBar: _buildAppBar(watchlistState),
      body: SafeArea(
        child: isLoading && watchlistState.items.isEmpty
            ? _buildShimmerGrid()
            : error != null && watchlistState.items.isEmpty
                ? _buildErrorState(error)
                : filteredItems.isEmpty
                    ? _buildEmptyState(watchlistState.searchQuery.isNotEmpty)
                    : _buildWatchlistGrid(filteredItems),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(dynamic watchlistState) {
    return AppBar(
      backgroundColor: NetflixColors.backgroundBlack,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'My List',
        style: TextStyle(
          color: NetflixColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        if (watchlistState.items.isNotEmpty)
          TextButton(
            onPressed: _toggleEditMode,
            style: TextButton.styleFrom(
              foregroundColor: NetflixColors.textPrimary,
            ),
            child: Text(
              _isEditMode ? 'Done' : 'Edit',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        _selectedItems.clear();
      }
    });
  }

  Widget _buildWatchlistGrid(List<WatchlistItem> items) {
    return Column(
      children: [
        if (_isEditMode && _selectedItems.isNotEmpty)
          _buildEditToolbar(),
        Expanded(
          child: RefreshIndicator(
            backgroundColor: NetflixColors.surfaceMedium,
            color: NetflixColors.primaryRed,
            onRefresh: () =>
                ref.read(watchlistNotifierProvider.notifier).refresh(),
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 16,
                childAspectRatio: 2 / 3,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = _selectedItems.contains(item.id);

                return _buildWatchlistItem(
                  item: item,
                  isSelected: isSelected,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: NetflixColors.surfaceMedium,
        border: Border(
          bottom: BorderSide(
            color: NetflixColors.surfaceLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_selectedItems.length} selected',
            style: const TextStyle(
              color: NetflixColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: _selectAll,
                icon: const Icon(
                  Icons.select_all,
                  size: 18,
                  color: NetflixColors.textPrimary,
                ),
                label: const Text(
                  'All',
                  style: TextStyle(color: NetflixColors.textPrimary),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: _deleteSelected,
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: NetflixColors.primaryRed,
                ),
                label: const Text(
                  'Delete',
                  style: TextStyle(color: NetflixColors.primaryRed),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectAll() {
    final items = ref.read(filteredWatchlistItemsProvider);
    setState(() {
      if (_selectedItems.length == items.length) {
        _selectedItems.clear();
      } else {
        _selectedItems.clear();
        _selectedItems.addAll(items.map((item) => item.id));
      }
    });
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NetflixColors.surfaceDark,
        title: const Text(
          'Remove from My List?',
          style: TextStyle(color: NetflixColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to remove ${_selectedItems.length} item(s)?',
          style: const TextStyle(color: NetflixColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: NetflixColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              for (final id in _selectedItems) {
                ref.read(watchlistNotifierProvider.notifier).removeItem(id);
              }
              setState(() {
                _selectedItems.clear();
                _isEditMode = false;
              });
              Navigator.pop(context);
              _showSnackBar('Removed ${_selectedItems.length} item(s)');
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: NetflixColors.primaryRed),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlistItem({
    required WatchlistItem item,
    required bool isSelected,
  }) {
    final mediaItem = _convertToMediaItem(item);

    return Stack(
      children: [
        MediaCard(
          title: item.title,
          imagePath: item.posterPath,
          onTap: () {
            if (_isEditMode) {
              setState(() {
                if (isSelected) {
                  _selectedItems.remove(item.id);
                } else {
                  _selectedItems.add(item.id);
                }
              });
            } else {
              _navigateToDetail(item);
            }
          },
          movie: item.contentType == 'movie' ? mediaItem as Movie? : null,
          tvShow: item.contentType == 'tv' ? mediaItem as TvShow? : null,
          showWatchlistButton: !_isEditMode,
        ),
        if (_isEditMode)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedItems.remove(item.id);
                  } else {
                    _selectedItems.add(item.id);
                  }
                });
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected
                      ? NetflixColors.primaryRed
                      : NetflixColors.backgroundBlack.withOpacity(0.7),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? NetflixColors.primaryRed
                        : NetflixColors.textPrimary,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: NetflixColors.textPrimary,
                        size: 16,
                      )
                    : null,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(bool isSearchResult) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bookmark_border,
              color: NetflixColors.textSecondary,
              size: 64,
            ),
            const SizedBox(height: 24),
            Text(
              isSearchResult ? 'No matches found' : 'Your list is empty',
              style: const TextStyle(
                color: NetflixColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isSearchResult
                  ? 'Try different search terms'
                  : 'Add movies and shows you want to watch later',
              style: const TextStyle(
                color: NetflixColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
              if (!isSearchResult)
              ElevatedButton(
                onPressed: () => context.goNamed('home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: NetflixColors.textPrimary,
                  foregroundColor: NetflixColors.backgroundBlack,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'Browse Content',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
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
                  ref.read(watchlistNotifierProvider.notifier).refresh(),
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

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
        childAspectRatio: 2 / 3,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: NetflixColors.surfaceMedium,
          ),
        );
      },
    );
  }

  void _navigateToDetail(WatchlistItem item) {
    if (item.contentType == 'movie') {
      context.pushNamed(
        'movie-detail',
        pathParameters: {'id': item.contentId.toString()},
        extra: _createMovieFromWatchlistItem(item),
      );
    } else {
      context.pushNamed(
        'tv-detail',
        pathParameters: {'id': item.contentId.toString()},
        extra: _createTvShowFromWatchlistItem(item),
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: NetflixColors.textPrimary),
        ),
        backgroundColor: NetflixColors.surfaceDark,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  dynamic _convertToMediaItem(WatchlistItem item) {
    if (item.contentType == 'movie') {
      return Movie(
        id: item.contentId,
        title: item.title,
        posterPath: item.posterPath,
        overview: item.overview ?? '',
        releaseDate: item.releaseDate,
        voteAverage: item.voteAverage ?? 0.0,
        popularity: 0.0,
        backdropPath: null,
        voteCount: 0,
      );
    } else {
      return TvShow(
        id: item.contentId,
        name: item.title,
        posterPath: item.posterPath,
        overview: item.overview ?? '',
        firstAirDate: item.releaseDate,
        voteAverage: item.voteAverage ?? 0.0,
        popularity: 0.0,
        backdropPath: null,
        voteCount: 0,
      );
    }
  }

  dynamic _createMovieFromWatchlistItem(WatchlistItem item) {
    return Movie(
      id: item.contentId,
      title: item.title,
      posterPath: item.posterPath,
      overview: item.overview ?? '',
      releaseDate: item.releaseDate,
      voteAverage: item.voteAverage ?? 0.0,
      popularity: 0.0,
      backdropPath: null,
      voteCount: 0,
    );
  }

  dynamic _createTvShowFromWatchlistItem(WatchlistItem item) {
    return TvShow(
      id: item.contentId,
      name: item.title,
      posterPath: item.posterPath,
      overview: item.overview ?? '',
      firstAirDate: item.releaseDate,
      voteAverage: item.voteAverage ?? 0.0,
      popularity: 0.0,
      backdropPath: null,
      voteCount: 0,
    );
  }
}
