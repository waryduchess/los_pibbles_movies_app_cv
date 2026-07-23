import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie.dart';

class ReportService {
  Future<void> generateFavoritesReport(List<Movie> favoriteMovies, String userName) async {
    if (favoriteMovies.isEmpty) {
      throw Exception('No hay películas favoritas para generar el reporte.');
    }

    // 1. Leer variables del .env
    final String apiUrl = dotenv.env['REPORT_API_URL'] ?? '';
    final String apiKey = dotenv.env['REPORT_API_KEY'] ?? '';
    final String templateId = dotenv.env['PDFMONKEY_TEMPLATE_ID'] ?? '';

    if (apiUrl.isEmpty || apiKey.isEmpty || templateId.isEmpty) {
      throw Exception('Faltan variables en el archivo .env');
    }

    // 2. Estructura del Payload
    final payload = {
      "document": {
        "document_template_id": templateId,
        "status": "pending",
        "payload": {
          "user_name": userName,
          "total_favorites": favoriteMovies.length,
          "movies": favoriteMovies.map((movie) => {
            "title": movie.title,
            "year": movie.year,
            "rating": movie.rating,
          }).toList(),
        }
      }
    };

    try {
      // 3. Petición POST para CREAR el documento
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // Obtenemos el ID del documento que se acaba de empezar a generar
        final documentId = responseData['document']['id']; 
        
        // 4. Llamamos a nuestra nueva función que espera a que el PDF esté listo
        await _waitForDocumentToBeReady(documentId, apiUrl, apiKey);
        
      } else {
        throw Exception('Error PDFMonkey: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al conectar con PDFMonkey: $e');
    }
  }

  // 🔥 NUEVA FUNCIÓN: Pregunta a la API cada 2 segundos si el PDF ya se generó
  Future<void> _waitForDocumentToBeReady(String documentId, String apiUrl, String apiKey) async {
    bool isReady = false;
    String? downloadUrl;
    int attempts = 0;
    const int maxAttempts = 10; // Máximo 20 segundos de espera

    while (!isReady && attempts < maxAttempts) {
      // Esperamos 2 segundos antes de preguntar
      await Future.delayed(const Duration(seconds: 2));
      attempts++;

      // Hacemos una petición GET para ver el estado del documento
      final response = await http.get(
        Uri.parse('$apiUrl/$documentId'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        }
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['document']['status'];

        if (status == 'success') {
          isReady = true;
          downloadUrl = data['document']['download_url'];
        } else if (status == 'failure') {
          throw Exception('PDFMonkey falló al generar el documento interno.');
        }
        // Si el status sigue siendo "pending" o "generating", el bucle continúa.
      }
    }

    if (downloadUrl != null) {
      // 5. ¡El PDF está listo! Lo abrimos.
      await _openReport(downloadUrl);
    } else {
      throw Exception('El documento tardó mucho en generarse. Intenta de nuevo.');
    }
  }

  Future<void> _openReport(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('No se pudo abrir el enlace del reporte.');
    }
  }
}