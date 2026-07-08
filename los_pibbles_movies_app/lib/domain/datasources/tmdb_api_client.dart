import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:los_pibbles_movies_app/domain/entities/app_exception.dart';

class TmdbApiClient {
  static const String _baseUrl = 'api.themoviedb.org';
  static const String _scheme = 'https';
  final String _apiKey;
  final String _language;

  TmdbApiClient({String? apiKey, String? language})
    : _apiKey = apiKey ?? dotenv.env['THE_MOVIEDB_KEY'] ?? '',
      _language = language ?? 'es-MX';

  // Método genérico para hacer GET
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri(
      scheme: _scheme,
      host: _baseUrl,
      path: '/3/$endpoint',
      queryParameters: {
        'api_key': _apiKey,
        'language': _language,
        ...?queryParams,
      },
    );

    final http.Response response;

    try {
      response = await http.get(uri);
    } on SocketException {
      throw AppException.noInternet();
    } on HttpException {
      throw AppException.noInternet();
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw AppException.notFound();
    } else if (response.statusCode >= 500) {
      throw AppException.serverError();
    } else {
      throw AppException.unknown(
        'Error al obtener datos: ${response.statusCode}',
      );
    }
  }
}
