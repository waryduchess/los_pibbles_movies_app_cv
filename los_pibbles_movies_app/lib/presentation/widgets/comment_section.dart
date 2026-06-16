import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class Comment {
  final String avatarUrl;
  final String userName;
  final int rating;
  final String text;

  const Comment({
    required this.avatarUrl,
    required this.userName,
    required this.rating,
    required this.text,
  });
}

const List<Comment> sampleComments = [
  Comment(
    avatarUrl: 'https://via.placeholder.com/48',
    userName: 'María G.',
    rating: 5,
    text: 'Excelente selección, me encantó la app.',
  ),
  Comment(
    avatarUrl: 'https://via.placeholder.com/48',
    userName: 'Carlos R.',
    rating: 4,
    text: 'Muy buena, encontré pelis que no conocía.',
  ),
  Comment(
    avatarUrl: 'https://via.placeholder.com/48',
    userName: 'Ana L.',
    rating: 5,
    text: 'Diseño moderno y fácil de navegar.',
  ),
  Comment(
    avatarUrl: 'https://via.placeholder.com/48',
    userName: 'Pedro S.',
    rating: 4,
    text: 'La recomiendo, buen catálogo de estrenos.',
  ),
  Comment(
    avatarUrl: 'https://via.placeholder.com/48',
    userName: 'Lucía M.',
    rating: 5,
    text: 'Perfecta para decidir qué ver el fin de semana.',
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
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        ...comments.map(
          (comment) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
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
      padding: const EdgeInsets.all(14),
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
                    Text(
                      comment.userName,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
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
                const SizedBox(height: 6),
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
