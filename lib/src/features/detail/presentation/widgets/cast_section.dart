import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_stream/src/core/models/cast_member.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_stream/src/shared/theme/netflix_colors.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';

/// Netflix-style cast section with horizontal scrolling
class CastSection extends StatelessWidget {
  final List<CastMember> cast;
  final bool isLoading;
  final Object? error;

  const CastSection({
    super.key,
    required this.cast,
    required this.isLoading,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cast',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: NetflixColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: isLoading ? _buildLoading() : _buildCastList(context),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            ShimmerBox(
              width: 80,
              height: 80,
              borderRadius: BorderRadius.circular(40),
            ),
            const SizedBox(height: 8),
            const ShimmerBox(width: 80, height: 12),
            const SizedBox(height: 4),
            const ShimmerBox(width: 60, height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildCastList(BuildContext context) {
    if (error != null) {
      return Center(
        child: Text(
          'Failed to load cast',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: NetflixColors.textSecondary,
          ),
        ),
      );
    }

    if (cast.isEmpty) {
      return Center(
        child: Text(
          'No cast information available',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: NetflixColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: cast.length,
      itemBuilder: (context, index) {
        final member = cast[index];
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _buildCastCard(context, member)
              .animate(delay: Duration(milliseconds: 50 * index))
              .fadeIn(duration: const Duration(milliseconds: 300))
              .slideX(begin: 0.1, duration: const Duration(milliseconds: 300)),
        );
      },
    );
  }

  Widget _buildCastCard(BuildContext context, CastMember member) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
    final imageUrl =
        (member.profilePath != null && member.profilePath!.isNotEmpty)
            ? '$imageBaseUrl/w185${member.profilePath}'
            : null;

    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: NetflixColors.surfaceMedium,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: NetflixColors.surfaceDark,
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
              child: imageUrl == null
                  ? const Icon(
                      Icons.person_outline,
                      size: 32,
                      color: NetflixColors.textSecondary,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            member.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: NetflixColors.textPrimary,
            ),
          ),
          if (member.character != null && member.character!.isNotEmpty)
            Text(
              member.character!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: NetflixColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
