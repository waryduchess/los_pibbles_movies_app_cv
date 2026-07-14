import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:los_pibbles_movies_app/presentation/providers/comments_provider.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/comment_section.dart';
import 'package:provider/provider.dart';

class HomeCommentsSection extends StatefulWidget {
  const HomeCommentsSection({super.key});

  @override
  State<HomeCommentsSection> createState() => _HomeCommentsSectionState();
}

class _HomeCommentsSectionState extends State<HomeCommentsSection> {
  int _reloadCounter = 0;
  int _lastReloadAt = -1;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommentsProvider>();

    _reloadCounter++;

    if (_lastReloadAt < _reloadCounter - 1 && SessionManager.userId != null) {
      _lastReloadAt = _reloadCounter;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<CommentsProvider>().loadTopComments(SessionManager.userId!);
        }
      });
    }

    final realComments = provider.topComments;

    final List<Comment> mergedComments = [];

    for (final real in realComments) {
      mergedComments.add(Comment(
        avatarUrl: real.avatarUrl ?? 'https://via.placeholder.com/48',
        userName: real.userName,
        rating: real.stars,
        text: real.text,
        likeCount: real.likeCount,
        isLiked: real.isLiked,
        commentId: real.id,
        isReal: true,
      ));
    }

    if (mergedComments.length < 5) {
      final needed = 5 - mergedComments.length;
      for (int i = 0; i < needed && i < sampleComments.length; i++) {
        mergedComments.add(sampleComments[i]);
      }
    }

    return CommentSection(comments: mergedComments);
  }
}
