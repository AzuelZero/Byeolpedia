class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un correo electrónico válido';
    }
    
    return null;
  }
  
  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'La contraseña debe contener mayúsculas, minúsculas y números';
    }
    
    return null;
  }
  
  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    
    if (value != password) {
      return 'Las contraseñas no coinciden';
    }
    
    return null;
  }
  
  // Username validation
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre de usuario es requerido';
    }
    
    if (value.length < 3) {
      return 'El nombre de usuario debe tener al menos 3 caracteres';
    }
    
    if (value.length > 20) {
      return 'El nombre de usuario no puede exceder 20 caracteres';
    }
    
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Solo se permiten letras, números y guiones bajos';
    }
    
    return null;
  }
  
  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es requerido';
    }
    
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    
    if (value.length > 50) {
      return 'El nombre no puede exceder 50 caracteres';
    }
    
    return null;
  }
  
  // Phone validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El número de teléfono es requerido';
    }
    
    if (!RegExp(r'^\+?[\d\s\-\(\)]{10,15}$').hasMatch(value)) {
      return 'Ingresa un número de teléfono válido';
    }
    
    return null;
  }
  
  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }
    
    return null;
  }
  
  // Length validation
  static String? validateLength(String? value, int minLength, int maxLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }
    
    if (value.length < minLength) {
      return '$fieldName debe tener al menos $minLength caracteres';
    }
    
    if (value.length > maxLength) {
      return '$fieldName no puede exceder $maxLength caracteres';
    }
    
    return null;
  }
  
  // Number validation
  static String? validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }
    
    if (double.tryParse(value) == null) {
      return '$fieldName debe ser un número válido';
    }
    
    return null;
  }
  
  // Positive number validation
  static String? validatePositiveNumber(String? value, String fieldName) {
    final numberError = validateNumber(value, fieldName);
    if (numberError != null) return numberError;
    
    final number = double.parse(value!);
    if (number <= 0) {
      return '$fieldName debe ser mayor que cero';
    }
    
    return null;
  }
  
  // Range validation
  static String? validateRange(String? value, double min, double max, String fieldName) {
    final numberError = validateNumber(value, fieldName);
    if (numberError != null) return numberError;
    
    final number = double.parse(value!);
    if (number < min || number > max) {
      return '$fieldName debe estar entre $min y $max';
    }
    
    return null;
  }
  
  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'La URL es requerida';
    }
    
    if (!RegExp(r'^https?://([\w-]+\.)+[\w-]{2,4}').hasMatch(value)) {
      return 'Ingresa una URL válida';
    }
    
    return null;
  }
  
  // Album title validation
  static String? validateAlbumTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'El título del álbum es requerido';
    }
    
    if (value.length < 2) {
      return 'El título debe tener al menos 2 caracteres';
    }
    
    if (value.length > 100) {
      return 'El título no puede exceder 100 caracteres';
    }
    
    return null;
  }
  
  // Group name validation
  static String? validateGroupName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre del grupo es requerido';
    }
    
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    
    if (value.length > 50) {
      return 'El nombre no puede exceder 50 caracteres';
    }
    
    return null;
  }
  
  // Member name validation
  static String? validateMemberName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre del miembro es requerido';
    }
    
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    
    if (value.length > 30) {
      return 'El nombre no puede exceder 30 caracteres';
    }
    
    return null;
  }
  
  // Photocard condition validation
  static String? validateCondition(String? value) {
    if (value == null || value.isEmpty) {
      return 'La condición es requerida';
    }
    
    const validConditions = [
      'mint', 'near_mint', 'good', 'fair', 'poor'
    ];
    
    if (!validConditions.contains(value.toLowerCase())) {
      return 'Condición no válida';
    }
    
    return null;
  }
  
  // Search query validation
  static String? validateSearchQuery(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa un término de búsqueda';
    }
    
    if (value.length < 2) {
      return 'La búsqueda debe tener al menos 2 caracteres';
    }
    
    if (value.length > 50) {
      return 'La búsqueda no puede exceder 50 caracteres';
    }
    
    return null;
  }
  
  // Post content validation
  static String? validatePostContent(String? value) {
    if (value == null || value.isEmpty) {
      return 'El contenido es requerido';
    }
    
    if (value.length < 10) {
      return 'El contenido debe tener al menos 10 caracteres';
    }
    
    if (value.length > 500) {
      return 'El contenido no puede exceder 500 caracteres';
    }
    
    return null;
  }
  
  // Comment validation
  static String? validateComment(String? value) {
    if (value == null || value.isEmpty) {
      return 'El comentario es requerido';
    }
    
    if (value.length < 3) {
      return 'El comentario debe tener al menos 3 caracteres';
    }
    
    if (value.length > 200) {
      return 'El comentario no puede exceder 200 caracteres';
    }
    
    return null;
  }
  
  // Price validation
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'El precio es requerido';
    }
    
    final price = double.tryParse(value);
    if (price == null) {
      return 'Ingresa un precio válido';
    }
    
    if (price < 0) {
      return 'El precio no puede ser negativo';
    }
    
    if (price > 999999.99) {
      return 'El precio no puede exceder 999,999.99';
    }
    
    return null;
  }
  
  // Year validation
  static String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'El año es requerido';
    }
    
    final year = int.tryParse(value);
    if (year == null) {
      return 'Ingresa un año válido';
    }
    
    final currentYear = DateTime.now().year;
    if (year < 1900 || year > currentYear + 1) {
      return 'El año debe estar entre 1900 y ${currentYear + 1}';
    }
    
    return null;
  }
}