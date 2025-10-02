import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/watchlist_item.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/shimmer_box.dart';

/// Interactive card widget for displaying watchlist items.
///
/// This widget provides a rich, interactive card interface for watchlist items
/// with features like poster display, quick actions, and contextual information.
/// The card supports both movies and TV shows with appropriate visual indicators.
///
/// Features:
/// - High-quality poster display with loading states
/// - Quick action buttons (edit, delete, toggle watched)
/// - Visual indicators for watched status and priority
/// - Smooth animations and hover effects
/// - Accessibility support with proper semantics
/// - Responsive design that works in grid layouts
///
/// Example usage:
/// ```dart
/// WatchlistItemCard(
///   item: watchlistItem,
///   onTap: () => navigateToDetail(item),
///   onEdit: () => showEditDialog(item),
///   onDelete: () => showDeleteDialog(item),
///   onToggleWatched: () => toggleWatchedStatus(item),
/// )
/// ```
class WatchlistItemCard extends StatefulWidget {
  /// The watchlist item to display in the card.
  final WatchlistItem item;

  /// Callback function called when the card is tapped.
  final VoidCallback onTap;

  /// Callback function called when the edit action is selected.
  final VoidCallback onEdit;

  /// Callback function called when the delete action is selected.
  final VoidCallback onDelete;

  /// Callback function called when the toggle watched action is selected.
  final VoidCallback onToggleWatched;

  /// Creates a watchlist item card widget.
  ///
  /// The [item] contains the watchlist data to display.
  /// The [onTap] callback is triggered when the card is tapped.
  /// The [onEdit] callback is triggered when the edit action is selected.
  /// The [onDelete] callback is triggered when the delete action is selected.
  /// The [onToggleWatched] callback is triggered when the toggle watched action is selected.
  const WatchlistItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleWatched,
  });

  @override
  State<WatchlistItemCard> createState() => _WatchlistItemCardState();
}

class _WatchlistItemCardState extends State<WatchlistItemCard> {
  @override
  Widget build(BuildContext context) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    final String? fullImageUrl =
        (widget.item.posterPath != null && widget.item.posterPath!.isNotEmpty)
            ? '$imageBaseUrl/w500${widget.item.posterPath}'
            : null;

    return Semantics(
      label:
          '${widget.item.title} ${widget.item.contentType == 'movie' ? 'movie' : 'TV show'}',
      hint: 'Double tap for options',
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _getPriorityColor(),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // Poster image
                _buildPosterImage(fullImageUrl),

                // Watched overlay
                if (widget.item.isWatched) _buildWatchedOverlay(),

                // Content type badge
                _buildContentTypeBadge(),

                // Priority indicator
                if (widget.item.priority >= 4) _buildPriorityIndicator(),

                // User rating badge
                if (widget.item.userRating != null) _buildUserRatingBadge(),

                // Quick actions menu
                _buildQuickActionsMenu(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPosterImage(String? imageUrl) {
    Widget imageWidget;
    if (imageUrl != null) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => const ShimmerBox(
          width: double.infinity,
          height: double.infinity,
        ),
        errorWidget: (context, url, error) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.broken_image_outlined,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
        ),
      );
    } else {
      imageWidget = Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 24,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: imageWidget,
    );
  }

  Widget _buildWatchedOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(Tokens.radiusS),
        ),
        child: const Icon(
          Icons.check_circle,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildContentTypeBadge() {
    return Positioned(
      top: 4,
      left: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: widget.item.contentType == 'movie'
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          widget.item.contentType == 'movie' ? 'MOVIE' : 'TV',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 8,
              ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    return Positioned(
      top: 4,
      right: 4,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: _getPriorityColor(),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildUserRatingBadge() {
    return Positioned(
      bottom: 4,
      right: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 12,
            ),
            const SizedBox(width: 2),
            Text(
              widget.item.userRating!.toStringAsFixed(1),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsMenu() {
    return Positioned(
      bottom: 4,
      left: 4,
      child: PopupMenuButton<String>(
        onSelected: _handleMenuSelection,
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          PopupMenuItem(
            value: 'toggle_watched',
            child: ListTile(
              leading: Icon(widget.item.isWatched
                  ? Icons.visibility_off
                  : Icons.visibility),
              title: Text(
                widget.item.isWatched ? 'Mark unwatched' : 'Mark watched',
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: ListTile(
              leading: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Remove',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.more_vert,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'edit':
        widget.onEdit();
        break;
      case 'toggle_watched':
        widget.onToggleWatched();
        break;
      case 'delete':
        widget.onDelete();
        break;
    }
  }

  Color _getPriorityColor() {
    switch (widget.item.priority) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
