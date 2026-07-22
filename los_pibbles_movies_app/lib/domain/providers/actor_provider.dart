import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/entities/actor_detail.dart';
import 'package:los_pibbles_movies_app/domain/repositories/movies_repositories.dart';

class ActorProvider extends ChangeNotifier {
  final MoviesRepository _repository = MoviesRepository();

  ActorDetail? selectedActor;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadActorDetail(int personId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      selectedActor = await _repository.getActorDetail(personId);
    } catch (e) {
      errorMessage = 'Error al cargar información del actor: $e';
    }

    isLoading = false;
    notifyListeners();
  }
}
