# Changelog — Sesión 2026-06-16

## Conexión a TMDB API

### Nuevos archivos

| Archivo | Descripción |
|---|---|
| `lib/domain/entities/movie.dart` | Entidad `Movie` con `fromDto()` y getter `description` |
| `lib/domain/repositories/movies_repositories.dart` | `MoviesRepository`: `getTrendingMovies()`, `getPopularMovies()`, `getGenres()` |
| `lib/presentation/providers/movies_provider.dart` | `MoviesProvider` (ChangeNotifier): `trending`, `popular`, `filteredPopular`, `categories`, `selectedCategory`, `selectCategory()` |
| `lib/presentation/widgets/comment_section.dart` | Widget `CommentSection` con modelo `Comment` y 5 comentarios dummy |

### Modificados

| Archivo | Cambio |
|---|---|
| `lib/main.dart` | Agregado `MultiProvider` con `MoviesProvider` |
| `lib/presentation/screens/movies/home_screen.dart` | Refactorizado: consume `MoviesProvider` en vez de `FutureBuilder` manual. Límite de 10 películas, filtro por género funcional |
| `lib/presentation/widgets/featured_movie_card.dart` | Reordenado: ⭐ rating + año + botón "Ver resumen" (con ícono ▶) en misma fila. Sin `duration`. `foregroundColor: white` |
| `lib/presentation/widgets/featured_movie_carousel.dart` | Altura: `240` → `320`. Usa `trending` |
| `lib/presentation/widgets/movie_card_item.dart` | ⭐ arriba de los géneros. `Wrap` con hasta 3 géneros |
| `lib/presentation/widgets/category_selector.dart` | Agregado `onSelected` callback + `GestureDetector` para filtrar |
| `lib/presentation/widgets/search_bar_widget.dart` | Eliminado botón de micrófono |
| `lib/presentation/models/movie_model.dart` | Limpiado import no usado |
| `pubspec.yaml` | Registrado `logo_app.png` (revertido a `logo.png`) |

### UI — Home Screen

- **Header:** logo (`logo.png`) + "Pibble Movies" (sin subtítulo)
- **Carrusel:** 6 películas de `GET /trending/movie/week` (tendencias)
- **Géneros:** chips clickeables con `CategorySelector` → filtran lista "Recomendadas"
- **Recomendadas:** 10 películas de `GET /movie/popular`, filtrables por género
- **Comentarios:** sección al final con 5 comentarios dummy (avatar, nombre, estrellas, texto)

### Endpoints TMDB usados

| # | Endpoint | Uso |
|---|---|---|
| 1 | `GET /genre/movie/list` | Mapeo ID → nombre de género |
| 2 | `GET /trending/movie/week` | Películas en tendencia (carrusel) |
| 3 | `GET /movie/popular` | Películas populares (lista) |

### Flujo de datos

```
TMDB API → TmdbApiClient (http) → MovieDto.fromJson() → Movie.fromDto(dto, genreMap) → MoviesProvider → UI (context.watch)
```

### Estado del análisis

`flutter analyze`: 0 errores, 19 info-level warnings preexistentes
