import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/presentation/providers/comments_provider.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/add_comment_sheet.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/cards/movie_review_card.dart';
import 'package:provider/provider.dart';

class MovieCommentsSection extends StatefulWidget {
  final int movieId;
  final int userId;

  const MovieCommentsSection({
    super.key,
    required this.movieId,
    required this.userId,
  });

  @override
  State<MovieCommentsSection> createState() => _MovieCommentsSectionState();
}

class _MovieCommentsSectionState extends State<MovieCommentsSection> {
  bool _loaded = false;

  static const List<Map<String, String>> _staticReviews = [
    {
      'user': '@CineFilm_MX',
      'review': 'Una obra maestra del suspenso latinoamericano. Los giros son impredecibles.',
      'date': '13 nov 2023',
      'rating': '5',
    },
    {
      'user': '@Paulina_R',
      'review': 'Actuaciones sobresalientes. La fotografia es increible y mantiene la tension.',
      'date': '29 oct 2023',
      'rating': '5',
    },
    {
      'user': '@MovieFan',
      'review': 'Muy buena historia, buen ritmo y personajes interesantes de principio a fin.',
      'date': '05 sep 2023',
      'rating': '5',
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      context.read<CommentsProvider>().loadMovieComments(
        widget.movieId,
        widget.userId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommentsProvider>();
    final comments = provider.commentsForMovie(widget.movieId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Reseñas',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAddCommentSheet(context),
              icon: const Icon(Icons.add_comment_outlined, size: 18),
              label: const Text('Agregar'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (provider.isLoadingMovieComments)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(),
            ),
          )
        else if (comments.isNotEmpty)
          ...comments.map((c) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MovieReviewCard(
              user: c.userName,
              review: c.text,
              date: c.date,
              rating: c.stars.toString(),
              avatarUrl: c.avatarUrl,
              likeCount: c.likeCount,
              isLiked: c.isLiked,
              onLikeTap: () {
                provider.toggleLike(widget.userId, c.id, widget.movieId);
              },
              showLike: true,
            ),
          ))
        else
          ..._staticReviews.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MovieReviewCard(
              user: r['user']!,
              review: r['review']!,
              date: r['date']!,
              rating: r['rating']!,
              showLike: false,
            ),
          )),
      ],
    );
  }

  void _showAddCommentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddCommentSheet(movieId: widget.movieId),
    ).then((result) {
      if (result != null && result is Map<String, dynamic>) {
        final provider = context.read<CommentsProvider>();
        provider.addComment(
          widget.userId,
          widget.movieId,
          result['text'] as String,
          result['stars'] as int,
        );
      }
    });
  }
}
