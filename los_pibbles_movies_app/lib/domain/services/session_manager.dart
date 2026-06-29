class SessionManager {
  static String? userId;
  static String? userName;
  static String? fotoPerfil;
  static DateTime? loginTime;

  static bool get isLoggedIn =>
      userId != null && loginTime != null && !isExpired;

  static bool get isExpired {
    if (loginTime == null) return true;
    return DateTime.now().difference(loginTime!).inMinutes >= 5;
  }

  static void setSession(String id, String name, {String? foto}) {
    userId = id;
    userName = name;
    fotoPerfil = foto;
    loginTime = DateTime.now();
  }

  static void clear() {
    userId = null;
    userName = null;
    fotoPerfil = null;
    loginTime = null;
  }
}
