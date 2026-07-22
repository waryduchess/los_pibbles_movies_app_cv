import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static String get _cloudName => dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  static String get _uploadPreset => dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

  static Future<String> uploadImage(File imageFile) async {
    print('--- CLOUDINARY DEBUG ---');
    print('Cloud Name en la app: $_cloudName');
    print('Preset en la app: $_uploadPreset');

    // 👇 1. Detectamos dinámicamente si el archivo es un video por su extensión
    final isVideo = imageFile.path.toLowerCase().endsWith('.mp4') || 
                    imageFile.path.toLowerCase().endsWith('.mov');
    
    // Si es video usamos 'video', de lo contrario usamos 'image'
    final resourceType = isVideo ? 'video' : 'image';

    // 👇 2. Cambiamos la palabra fija "image" por la variable dinámina "$resourceType"
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/$resourceType/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = response.body;
      final secureUrl = _extractSecureUrl(data);
      return secureUrl;
    } else {
      // 🔥 Tip Pro: Devolvemos response.body para saber el motivo real si algo falla (ej. tamaño del archivo)
      throw Exception('Error al subir a Cloudinary (${response.statusCode}): ${response.body}');
    }
  }

  static String _extractSecureUrl(String jsonString) {
    final key = '"secure_url":';
    final start = jsonString.indexOf(key);
    if (start == -1) throw Exception('No se recibio secure_url de Cloudinary');
    final valueStart = start + key.length;
    final afterKey = jsonString.substring(valueStart).trimLeft();
    if (afterKey.startsWith('"')) {
      final end = afterKey.indexOf('"', 1);
      if (end != -1) return afterKey.substring(1, end);
    }
    throw Exception('No se pudo extraer secure_url');
  }
}