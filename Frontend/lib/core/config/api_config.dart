class ApiConfig {
  // Base URL for the API
  static const String baseUrl = 'http://localhost:8000/api';
  
  // API endpoints
  static const String auth = '$baseUrl/auth';
  static const String catalog = '$baseUrl/catalog';
  static const String collection = '$baseUrl/collection';
  
  // Auth endpoints
  static const String login = '$auth/login/';
  static const String register = '$auth/register/';
  static const String logout = '$auth/logout/';
  static const String profile = '$auth/profile/';
  static const String stats = '$auth/stats/';
  static const String tokenRefresh = '$auth/token/refresh/';
  
  // Catalog endpoints
  static const String groups = '$catalog/groups/';
  static const String members = '$catalog/members/';
  static const String albums = '$catalog/albums/';
  static const String photocards = '$catalog/photocards/';
  static const String lightsticks = '$catalog/lightsticks/';
  
  // Collection endpoints
  static const String collectibles = '$collection/collectibles/';
  static const String wishlist = '$collection/wishlist/';
  static const String favorites = '$collection/favorites/';
  static const String collectionStats = '$collection/stats/';
  static const String lightstickRecognition = '$collection/lightstick-recognition/';
  
  // Connection timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}