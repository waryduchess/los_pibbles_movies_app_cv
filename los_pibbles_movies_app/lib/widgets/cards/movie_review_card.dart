import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class MovieReviewCard extends StatelessWidget {
  final String user;
  final String review;
  final String date;
  final String rating;
  final String? avatarUrl;
  final int? likeCount;
  final bool? isLiked;
  final VoidCallback? onLikeTap;
  final bool showLike;

  const MovieReviewCard({
    super.key,
    required this.user,
    required this.review,
    required this.date,
    required this.rating,
    this.avatarUrl,
    this.likeCount,
    this.isLiked,
    this.onLikeTap,
    this.showLike = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.secondary900,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.secondary700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (avatarUrl != null) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(avatarUrl!),
                  onBackgroundImageError: (_, __) {},
                  child: const Icon(Icons.person, color: AppColors.white, size: 16),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  user,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (showLike && likeCount != null && onLikeTap != null)
                GestureDetector(
                  onTap: onLikeTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        (isLiked ?? false)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: (isLiked ?? false)
                            ? AppColors.accent500
                            : AppColors.textSecondary,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '$likeCount',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 6),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < int.tryParse(rating)! ? Icons.star : Icons.star_border,
                    color: AppColors.warning,
                    size: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            review,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}