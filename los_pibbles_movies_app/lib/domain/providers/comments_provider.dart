import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/datasources/auth_backend_datasource.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';

class CommentData {
  final int id;
  final int movieId;
  final String userName;
  final String? avatarUrl;
  final String text;
  final int stars;
  final String date;
  final int likeCount;
  final bool isLiked;

  CommentData({
    required this.id,
    required this.movieId,
    required this.userName,
    this.avatarUrl,
    required this.text,
    required this.stars,
    required this.date,
    this.likeCount = 0,
    this.isLiked = false,
  });

  CommentData copyWith({
    int? likeCount,
    bool? isLiked,
  }) {
    return CommentData(
      id: id,
      movieId: movieId,
      userName: userName,
      avatarUrl: avatarUrl,
      text: text,
      stars: stars,
      date: date,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  /// Convierte a la clase Comment del comment_section.dart para compatibilidad
  Comment toStaticComment() {
    return Comment(
      avatarUrl: avatarUrl ?? 'https://via.placeholder.com/48',
      userName: userName,
      rating: stars,
      text: text,
    );
  }
}

class CommentsProvider extends ChangeNotifier {
  final AuthBackendDatasource _datasource = AuthBackendDatasource();

  final Map<int, List<CommentData>> _movieComments = {};
  List<CommentData> _topComments = [];
  final Set<int> _likedCommentIds = {};

  bool _isLoadingMovieComments = false;
  bool _isLoadingTopComments = false;

  bool get isLoadingMovieComments => _isLoadingMovieComments;
  bool get isLoadingTopComments => _isLoadingTopComments;

  List<CommentData> get topComments => _topComments;

  List<CommentData> commentsForMovie(int movieId) =>
      _movieComments[movieId] ?? [];

  bool isCommentLikedByMe(int commentId) =>
      _likedCommentIds.contains(commentId);

  // ─── TOP COMENTARIOS (HOME) ───────────────────────────────────────

  Future<void> loadTopComments(int userId) async {
    _isLoadingTopComments = true;
    notifyListeners();

    try {
      final rows = await _datasource.getTopComments(limit: 5);
      final liked = await _datasource.getUserLikedCommentIds(userId);
      _likedCommentIds
        ..clear()
        ..addAll(liked);

      _topComments = rows.map((r) {
        return CommentData(
          id: int.tryParse(r['id_comentario'].toString()) ?? 0,
          movieId: int.tryParse(r['id_pelicula'].toString()) ?? 0,
          userName: '${r['nombres'] ?? ''} ${r['apellidos'] ?? ''}'.trim(),
          avatarUrl: r['foto_perfil']?.toString(),
          text: r['comentario']?.toString() ?? '',
          stars: int.tryParse(r['estrellas'].toString()) ?? 0,
          date: r['fecha']?.toString() ?? '',
          likeCount: int.tryParse(r['total_likes'].toString()) ?? 0,
          isLiked: _likedCommentIds.contains(
            int.tryParse(r['id_comentario'].toString()) ?? 0,
          ),
        );
      }).toList();
    } catch (e) {
      debugPrint('Error cargando top comentarios: $e');
      _topComments = [];
    }

    _isLoadingTopComments = false;
    notifyListeners();
  }

  // ─── COMENTARIOS POR PELICULA ─────────────────────────────────────

  Future<void> loadMovieComments(int movieId, int userId) async {
    _isLoadingMovieComments = true;
    notifyListeners();

    try {
      final liked = await _datasource.getUserLikedCommentIds(userId);
      _likedCommentIds
        ..clear()
        ..addAll(liked);

      final rows = await _datasource.getLocalMovieReviews(movieId);

      final comments = <CommentData>[];
      for (final r in rows) {
        final cId = int.tryParse(r['id_comentario'].toString()) ?? 0;
        final likeCount = await _datasource.getCommentLikeCount(cId);
        comments.add(CommentData(
          id: cId,
          movieId: movieId,
          userName: '${r['nombres'] ?? ''} ${r['apellidos'] ?? ''}'.trim(),
          avatarUrl: r['foto_perfil']?.toString(),
          text: r['comentario']?.toString() ?? '',
          stars: int.tryParse(r['estrellas'].toString()) ?? 0,
          date: r['fecha']?.toString() ?? '',
          likeCount: likeCount,
          isLiked: _likedCommentIds.contains(cId),
        ));
      }

      _movieComments[movieId] = comments;
    } catch (e) {
      debugPrint('Error cargando comentarios de pelicula: $e');
      _movieComments[movieId] = [];
    }

    _isLoadingMovieComments = false;
    notifyListeners();
  }

  // ─── AGREGAR COMENTARIO ──────────────────────────────────────────

  Future<bool> addComment(int userId, int movieId, String text, int stars) async {
    try {
      await _datasource.addComment(userId, movieId, text, stars);
      await loadMovieComments(movieId, userId);
      await _refreshTopComments(userId);
      return true;
    } catch (e) {
      debugPrint('Error al agregar comentario: $e');
      return false;
    }
  }

  // ─── TOGGLE LIKE ──────────────────────────────────────────────────

  Future<void> toggleLike(int userId, int commentId, int movieId) async {
    final wasLiked = _likedCommentIds.contains(commentId);

    // Optimista
    if (wasLiked) {
      _likedCommentIds.remove(commentId);
    } else {
      _likedCommentIds.add(commentId);
    }
    _updateCommentLikeState(commentId, movieId, wasLiked ? -1 : 1, !wasLiked);
    notifyListeners();

    try {
      await _datasource.toggleLikeComment(userId, commentId);
      await _refreshTopComments(userId);
    } catch (e) {
      debugPrint('Error al alternar like: $e');
      // Rollback
      if (wasLiked) {
        _likedCommentIds.add(commentId);
      } else {
        _likedCommentIds.remove(commentId);
      }
      _updateCommentLikeState(commentId, movieId, wasLiked ? 1 : -1, wasLiked);
      notifyListeners();
    }
  }

  void _updateCommentLikeState(int commentId, int movieId, int delta, bool isLiked) {
    final list = _movieComments[movieId];
    if (list != null) {
      final idx = list.indexWhere((c) => c.id == commentId);
      if (idx != -1) {
        list[idx] = list[idx].copyWith(
          likeCount: list[idx].likeCount + delta,
          isLiked: isLiked,
        );
      }
    }

    final topIdx = _topComments.indexWhere((c) => c.id == commentId);
    if (topIdx != -1) {
      _topComments[topIdx] = _topComments[topIdx].copyWith(
        likeCount: _topComments[topIdx].likeCount + delta,
        isLiked: isLiked,
      );
    }
  }

  Future<void> _refreshTopComments(int userId) async {
    try {
      final rows = await _datasource.getTopComments(limit: 5);
      _topComments = rows.map((r) {
        final cId = int.tryParse(r['id_comentario'].toString()) ?? 0;
        return CommentData(
          id: cId,
          movieId: int.tryParse(r['id_pelicula'].toString()) ?? 0,
          userName: '${r['nombres'] ?? ''} ${r['apellidos'] ?? ''}'.trim(),
          avatarUrl: r['foto_perfil']?.toString(),
          text: r['comentario']?.toString() ?? '',
          stars: int.tryParse(r['estrellas'].toString()) ?? 0,
          date: r['fecha']?.toString() ?? '',
          likeCount: int.tryParse(r['total_likes'].toString()) ?? 0,
          isLiked: _likedCommentIds.contains(cId),
        );
      }).toList();
    } catch (_) {}
  }

  Future<void> loadUserLikes(int userId) async {
    try {
      final liked = await _datasource.getUserLikedCommentIds(userId);
      _likedCommentIds
        ..clear()
        ..addAll(liked);
    } catch (_) {}
  }

  void clearLocalState() {
    _movieComments.clear();
    _topComments.clear();
    _likedCommentIds.clear();
    notifyListeners();
  }
}
