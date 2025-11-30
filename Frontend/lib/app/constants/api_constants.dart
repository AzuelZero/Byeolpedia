class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://localhost:8000/api';
  
  // API Version
  static const String apiVersion = 'v1';
  
  // Endpoints
  static const String auth = '/auth';
  static const String catalog = '/catalog';
  static const String collection = '/collection';
  static const String community = '/community';
  static const String search = '/search';
  static const String recognition = '/recognition';
  
  // Auth Endpoints
  static const String login = '$auth/login/';
  static const String register = '$auth/register/';
  static const String logout = '$auth/logout/';
  static const String refresh = '$auth/refresh/';
  static const String profile = '$auth/profile/';
  static const String changePassword = '$auth/change-password/';
  static const String resetPassword = '$auth/reset-password/';
  
  // Catalog Endpoints
  static const String groups = '$catalog/groups/';
  static const String members = '$catalog/members/';
  static const String albums = '$catalog/albums/';
  static const String photocards = '$catalog/photocards/';
  static const String lightsticks = '$catalog/lightsticks/';
  static const String groupDetail = '$catalog/groups/{id}/';
  static const String memberDetail = '$catalog/members/{id}/';
  static const String albumDetail = '$catalog/albums/{id}/';
  static const String photocardDetail = '$catalog/photocards/{id}/';
  static const String lightstickDetail = '$catalog/lightsticks/{id}/';
  
  // Collection Endpoints
  static const String userCollection = '$collection/user/';
  static const String addAlbum = '$collection/add-album/';
  static const String removeAlbum = '$collection/remove-album/{id}/';
  static const String addPhotocard = '$collection/add-photocard/';
  static const String removePhotocard = '$collection/remove-photocard/{id}/';
  static const String updatePhotocard = '$collection/update-photocard/{id}/';
  static const String wishlist = '$collection/wishlist/';
  static const String favorites = '$collection/favorites/';
  static const String stats = '$collection/stats/';
  static const String exportCollection = '$collection/export/';
  static const String importCollection = '$collection/import/';
  
  // Community Endpoints
  static const String posts = '$community/posts/';
  static const String createPost = '$community/create-post/';
  static const String likePost = '$community/like-post/{id}/';
  static const String commentPost = '$community/comment-post/{id}/';
  static const String followUser = '$community/follow/{id}/';
  static const String unfollowUser = '$community/unfollow/{id}/';
  static const String userProfile = '$community/profile/{id}/';
  static const String userPosts = '$community/posts/{userId}/';
  
  // Search Endpoints
  static const String searchAll = '$search/all/';
  static const String searchAlbums = '$search/albums/';
  static const String searchPhotocards = '$search/photocards/';
  static const String searchGroups = '$search/groups/';
  static const String searchMembers = '$search/members/';
  static const String searchLightsticks = '$search/lightsticks/';
  static const String searchSuggestions = '$search/suggestions/';
  static const String searchHistory = '$search/history/';
  
  // Recognition Endpoints
  static const String recognizeLightstick = '$recognition/lightstick/';
  static const String recognizePhotocard = '$recognition/photocard/';
  static const String recognitionHistory = '$recognition/history/';
  static const String recognitionModels = '$recognition/models/';
  
  // Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptHeader = 'Accept';
  static const String authorizationHeader = 'Authorization';
  static const String userAgentHeader = 'User-Agent';
  
  // Header Values
  static const String jsonContentType = 'application/json';
  static const String formContentType = 'multipart/form-data';
  static const String bearerPrefix = 'Bearer ';
  
  // Query Parameters
  static const String pageParam = 'page';
  static const String limitParam = 'limit';
  static const String searchParam = 'q';
  static const String sortParam = 'sort';
  static const String orderParam = 'order';
  static const String filterParam = 'filter';
  static const String categoryParam = 'category';
  
  // Sort Options
  static const String sortByDate = 'date';
  static const String sortByName = 'name';
  static const String sortByPopularity = 'popularity';
  static const String sortByPrice = 'price';
  static const String sortByRelease = 'release';
  
  // Order Options
  static const String orderAsc = 'asc';
  static const String orderDesc = 'desc';
  
  // Filter Options
  static const String filterOwned = 'owned';
  static const String filterWishlist = 'wishlist';
  static const String filterMissing = 'missing';
  static const String filterDuplicates = 'duplicates';
  static const String filterFavorites = 'favorites';
  
  // Categories
  static const String categoryAlbum = 'album';
  static const String categoryPhotocard = 'photocard';
  static const String categoryLightstick = 'lightstick';
  static const String categoryGroup = 'group';
  static const String categoryMember = 'member';
  
  // HTTP Status Codes
  static const int okCode = 200;
  static const int createdCode = 201;
  static const int noContentCode = 204;
  static const int badRequestCode = 400;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int conflictCode = 409;
  static const int unprocessableEntityCode = 422;
  static const int internalServerErrorCode = 500;
  static const int serviceUnavailableCode = 503;
  
  // Request Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Retry Configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
  static const Duration backoffMultiplier = Duration(seconds: 2);
  
  // Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 1);
  static const int maxCacheSize = 100; // MB
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/webp',
  ];
  static const List<String> allowedVideoTypes = [
    'video/mp4',
    'video/mov',
    'video/avi',
  ];
}