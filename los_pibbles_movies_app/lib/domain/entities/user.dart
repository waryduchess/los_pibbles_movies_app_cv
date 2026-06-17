class UserModel {
  final int idUsuario;
  final String nombres;
  final String apellidos;
  final String correo;
  final String? fotoPerfil;

  UserModel({
    required this.idUsuario,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    this.fotoPerfil,
  });

  // Mapper para transformar la fila de MySQL a nuestro objeto Dart
  factory UserModel.fromMySQL(Map<String, dynamic> map) {
    return UserModel(
      idUsuario: int.parse(map['id_usuario'].toString()),
      nombres: map['nombres'] ?? '',
      apellidos: map['apellidos'] ?? '',
      correo: map['correo'] ?? '',
      fotoPerfil: map['foto_perfil'],
    );
  }
}