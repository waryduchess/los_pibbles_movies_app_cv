enum AppErrorType { noInternet, notFound, serverError, unknown }

class AppException implements Exception {
  final AppErrorType type;
  final String message;

  const AppException({required this.type, this.message = ''});

  @override
  String toString() => 'AppException($type): $message';

  factory AppException.noInternet([String? msg]) => AppException(
        type: AppErrorType.noInternet,
        message: msg ?? 'Sin conexión a internet',
      );

  factory AppException.notFound([String? msg]) => AppException(
        type: AppErrorType.notFound,
        message: msg ?? 'Contenido no encontrado',
      );

  factory AppException.serverError([String? msg]) => AppException(
        type: AppErrorType.serverError,
        message: msg ?? 'Error en el servidor',
      );

  factory AppException.unknown([String? msg]) => AppException(
        type: AppErrorType.unknown,
        message: msg ?? 'Algo salió mal',
      );
}
