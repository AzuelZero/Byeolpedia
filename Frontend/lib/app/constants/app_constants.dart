class AppConstants {
  // App Information
  static const String appName = 'Byeolpedia';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Kpop Tracker MVP';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Padding and Margins
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  // Border Radius
  static const double smallBorderRadius = 4.0;
  static const double mediumBorderRadius = 8.0;
  static const double largeBorderRadius = 12.0;
  static const double extraLargeBorderRadius = 16.0;
  
  // Elevation
  static const double smallElevation = 2.0;
  static const double mediumElevation = 4.0;
  static const double largeElevation = 8.0;
  
  // Grid Settings
  static const int mobileGridColumns = 2;
  static const int tabletGridColumns = 3;
  static const int desktopGridColumns = 4;
  
  static const double photocardAspectRatio = 0.7;
  static const double albumAspectRatio = 0.75;
  
  // Image Settings
  static const double imageQuality = 0.8;
  static const int maxWidthImage = 1024;
  static const int maxHeightImage = 1024;
  
  // Cache Settings
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  
  // Search Settings
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const int minSearchLength = 2;
  static const int maxSearchLength = 50;
  
  // Collection Status
  static const String statusOwned = 'owned';
  static const String statusWishlist = 'wishlist';
  static const String statusMissing = 'missing';
  static const String statusDuplicate = 'duplicate';
  
  // Photocard Conditions
  static const String conditionMint = 'mint';
  static const String conditionNearMint = 'near_mint';
  static const String conditionGood = 'good';
  static const String conditionFair = 'fair';
  static const String conditionPoor = 'poor';
  
  // K-pop Groups (for quick access)
  static const List<String> popularGroups = [
    'BTS',
    'BLACKPINK',
    'TWICE',
    'RED VELVET',
    'NCT',
    'STRAY KIDS',
    'NewJeans',
    'LE SSERAFIM',
    'IVE',
    'aespa',
    'TREASURE',
    'SEVENTEEN',
    'GOT7',
    'EXO',
    'BIGBANG',
    '2NE1',
    'Girls Generation',
    'Super Junior',
    'SHINee',
  ];
  
  // Album Types
  static const List<String> albumTypes = [
    'Studio Album',
    'Mini Album',
    'Single Album',
    'Compilation',
    'Live Album',
    'Remix Album',
    'Soundtrack',
  ];
  
  // Photocard Types
  static const List<String> photocardTypes = [
    'Member Card',
    'Group Card',
    'Concept Card',
    'Unit Card',
    'Special Card',
    'Promo Card',
    'Signed Card',
  ];
  
  // Lightstick Types
  static const List<String> lightstickTypes = [
    'Official Lightstick',
    'Lightstick Ver 1.0',
    'Lightstick Ver 2.0',
    'Lightstick Ver 3.0',
    'Mini Lightstick',
    'Keyring Lightstick',
  ];
  
  // Social Features
  static const int maxPostLength = 500;
  static const int maxCommentLength = 200;
  static const int maxUsernameLength = 30;
  
  // File Sizes (in bytes)
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxAvatarSize = 2 * 1024 * 1024; // 2MB
  
  // API Related
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
  
  // Local Storage Keys
  static const String themeKey = 'theme_mode';
  static const String userKey = 'user_data';
  static const String collectionKey = 'collection_data';
  static const String searchHistoryKey = 'search_history';
  static const String favoritesKey = 'favorites_data';
  
  // Navigation Routes
  static const String homeRoute = '/home';
  static const String collectionRoute = '/collection';
  static const String searchRoute = '/search';
  static const String communityRoute = '/community';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String lightstickRecognitionRoute = '/lightstick-recognition';
  
  // Error Messages
  static const String networkError = 'Error de conexión. Por favor, verifica tu internet.';
  static const String serverError = 'Error del servidor. Por favor, intenta más tarde.';
  static const String genericError = 'Ocurrió un error inesperado.';
  static const String noDataError = 'No se encontraron datos.';
  static const String unauthorizedError = 'No autorizado. Por favor, inicia sesión.';
  
  // Success Messages
  static const String saveSuccess = 'Guardado exitosamente';
  static const String deleteSuccess = 'Eliminado exitosamente';
  static const String updateSuccess = 'Actualizado exitosamente';
  static const String loginSuccess = 'Inicio de sesión exitoso';
  static const String logoutSuccess = 'Sesión cerrada exitosamente';
}