import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lets_stream/src/core/models/anime/anime_search_result.dart';

/// A dialog for selecting the correct anime when multiple matches are found.
///
/// This dialog displays a list of anime search results and allows users to
/// manually select the correct anime for TMDB to Anime API mapping.
class AnimeMappingDialog extends StatefulWidget {
  /// The TMDB anime title for context.
  final String tmdbTitle;

  /// The list of anime search results to choose from.
  final List<AnimeSearchResult> searchResults;

  /// Callback when an anime is selected.
  final void Function(AnimeSearchResult) onAnimeSelected;

  /// Callback when the dialog is cancelled.
  final VoidCallback? onCancel;

  /// Creates a new AnimeMappingDialog instance.
  const AnimeMappingDialog({
    super.key,
    required this.tmdbTitle,
    required this.searchResults,
    required this.onAnimeSelected,
    this.onCancel,
  });

  @override
  State<AnimeMappingDialog> createState() => _AnimeMappingDialogState();

  /// Shows the anime mapping dialog.
  static Future<AnimeSearchResult?> show(
    BuildContext context, {
    required String tmdbTitle,
    required List<AnimeSearchResult> searchResults,
  }) {
    return showDialog<AnimeSearchResult>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AnimeMappingDialog(
        tmdbTitle: tmdbTitle,
        searchResults: searchResults,
        onAnimeSelected: (anime) => Navigator.of(context).pop(anime),
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _AnimeMappingDialogState extends State<AnimeMappingDialog> {
  AnimeSearchResult? _selectedAnime;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(),
            
            // Search results list
            Flexible(
              child: _buildSearchResults(),
            ),
            
            // Action buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// Builds the dialog header.
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.blue[700],
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Select Anime',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onCancel,
                icon: const Icon(Icons.close),
                color: Colors.grey[600],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Multiple anime found for "${widget.tmdbTitle}". Please select the correct one:',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the search results list.
  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: widget.searchResults.length,
      itemBuilder: (context, index) {
        final anime = widget.searchResults[index];
        final isSelected = _selectedAnime?.id == anime.id;
        
        return _buildAnimeItem(anime, isSelected);
      },
    );
  }

  /// Builds an anime list item.
  Widget _buildAnimeItem(AnimeSearchResult anime, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? Colors.blue[50] : Colors.white,
      ),
      child: ListTile(
        onTap: () => setState(() => _selectedAnime = anime),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: anime.poster,
            width: 60,
            height: 80,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 60,
              height: 80,
              color: Colors.grey[200],
              child: const Icon(Icons.image),
            ),
            errorWidget: (context, url, error) => Container(
              width: 60,
              height: 80,
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image),
            ),
          ),
        ),
        title: Text(
          anime.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.blue[800] : Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (anime.japaneseTitle.isNotEmpty && 
                anime.japaneseTitle != anime.title)
              Text(
                anime.japaneseTitle,
                style: TextStyle(
                  color: isSelected ? Colors.blue[600] : Colors.grey[600],
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildInfoChip(
                  anime.tvInfo.showType,
                  Colors.green,
                ),
                const SizedBox(width: 4),
                if (anime.tvInfo.eps != null)
                  _buildInfoChip(
                    '${anime.tvInfo.eps} eps',
                    Colors.orange,
                  ),
                const SizedBox(width: 4),
                if (anime.tvInfo.hasSub)
                  _buildInfoChip(
                    'Sub',
                    Colors.blue,
                  ),
                if (anime.tvInfo.hasDub)
                  _buildInfoChip(
                    'Dub',
                    Colors.purple,
                  ),
              ],
            ),
          ],
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 24,
              )
            : Icon(
                Icons.radio_button_unchecked,
                color: Colors.grey[400],
                size: 24,
              ),
      ),
    );
  }

  /// Builds an info chip for displaying anime metadata.
  Widget _buildInfoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Builds the action buttons.
  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onCancel,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _selectedAnime != null ? _onConfirm : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Confirm'),
            ),
          ),
        ],
      ),
    );
  }

  /// Handles the confirm button press.
  void _onConfirm() {
    if (_selectedAnime != null) {
      widget.onAnimeSelected(_selectedAnime!);
    }
  }
}
