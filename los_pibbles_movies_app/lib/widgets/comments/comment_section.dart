import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class Comment {
  final String avatarUrl;
  final String userName;
  final int rating;
  final String text;
  final int? likeCount;
  final bool? isLiked;
  final int? commentId;
  final bool isReal;

  const Comment({
    required this.avatarUrl,
    required this.userName,
    required this.rating,
    required this.text,
    this.likeCount,
    this.isLiked,
    this.commentId,
    this.isReal = false,
  });
}

const List<Comment> sampleComments = [
  Comment(
    avatarUrl: 'https://via.placeholder.com/48',
    userName: 'Maria G.',
    rating: 5,
    text: 'Excelente seleccion, me encanto la app.',
  ),
  Comment(
    avatarUrl: 'https://via.placeholder.com/48',
    userName: 'Carlos R.',
    rating: 4,
    text: 'Muy buena, encontre pelis que no conocia.',
  ),
  Comment(
    avatarUrl: 'https://via.placeholder.com/48',
    userName: 'Ana L.',
    rating: 5,
    text: 'Diseno moderno y facil de navegar.',
  ),
  Comment(
    avatarUrl: 'https://via.placeholder.com/48',
    userName: 'Pedro S.',
    rating: 4,
    text: 'La recomiendo, buen catalogo de estrenos.',
  ),
  Comment(
    avatarUrl: 'https://via.placeholder.com/48',
    userName: 'Lucia M.',
    rating: 5,
    text: 'Perfecta para decidir que ver el fin de semana.',
  ),
  
];

class CommentSection extends StatelessWidget {
  final List<Comment> comments;

  const CommentSection({super.key, this.comments = sampleComments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comentarios',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        ...comments.map(
          (comment) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CommentCard(comment: comment),
          ),
        ),
      ],
    );
  }
}

class _CommentCard extends StatelessWidget {
  final Comment comment;

  const _CommentCard({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(comment.avatarUrl),
            onBackgroundImageError: (_, __) {},
            child: const Icon(Icons.person, color: AppColors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment.userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (comment.isReal && comment.likeCount != null)
                      _LikeBadge(
                        count: comment.likeCount!,
                        isLiked: comment.isLiked ?? false,
                      ),
                    //const SizedBox(width: 6),
                    ...List.generate(
                      5,
                      (i) => Icon(
                        i < comment.rating
                            ? Icons.star
                            : Icons.star_border,
                        color: AppColors.warning,
                        size: 14,
                      ),
                    ),
                  ],
                ),
                //const SizedBox(height: 6),
                Text(
                  comment.text,
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.75),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LikeBadge extends StatelessWidget {
  final int count;
  final bool isLiked;

  const _LikeBadge({required this.count, required this.isLiked});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? AppColors.accent500 : AppColors.textSecondary,
          size: 14,
        ),
        //const SizedBox(width: 3),
        Text(
          '$count',
          style: TextStyle(
            color: AppColors.white.withOpacity(0.5),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
