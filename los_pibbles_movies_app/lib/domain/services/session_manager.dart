class SessionManager {
  static int? userId;
  static String? userName;
  static String? fotoPerfil;
  static DateTime? loginTime;
  static String? userEmail; 
  static bool isGoogleAccount = false;

  static String? memberSince;
  static int? favoritesCount;

  static bool get isLoggedIn =>
      userId != null && loginTime != null && !isExpired;

  static bool get isExpired {
    if (loginTime == null) return true;
    return DateTime.now().difference(loginTime!).inMinutes >= 5;
  }

  // 👇 Actualizamos el método para recibir y guardar los nuevos datos
  static void setSession(
    int id, 
    String name, {
    String? foto, 
    String? email,
    String? memberSinceDate, // 👈 Nuevo
    int? favCount,           // 👈 Nuevo
  }) {
    userId = id;
    userName = name;
    fotoPerfil = foto;
    userEmail = email;
    memberSince = memberSinceDate; // 👈 Guardamos el dato
    favoritesCount = favCount;     // 👈 Guardamos el dato
    loginTime = DateTime.now();
  }

  static void clear() {
    userId = null;
    userName = null;
    fotoPerfil = null;
    userEmail = null;
    isGoogleAccount = false;
    loginTime = null;
    memberSince = null;
    favoritesCount = null;
  }
}