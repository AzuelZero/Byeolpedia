class DateUtils {
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }
  
  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
           '${dateTime.month.toString().padLeft(2, '0')}/'
           '${dateTime.year} '
           '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
           '${time.minute.toString().padLeft(2, '0')}';
  }
  
  static String formatDayMonth(DateTime date) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}';
  }
  
  static String formatFullDate(DateTime date) {
    const days = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
    ];
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${days[date.weekday - 1]}, ${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
  
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Ayer';
      } else if (difference.inDays < 7) {
        return 'Hace ${difference.inDays} días';
      } else if (difference.inDays < 30) {
        return 'Hace ${difference.inDays ~/ 7} semanas';
      } else if (difference.inDays < 365) {
        return 'Hace ${difference.inDays ~/ 30} meses';
      } else {
        return 'Hace ${difference.inDays ~/ 365} años';
      }
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minutos';
    } else {
      return 'Ahora mismo';
    }
  }
  
  static DateTime parseDate(String dateString) {
    try {
      final parts = dateString.split('/');
      if (parts.length != 3) return DateTime.now();
      
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      return DateTime(year, month, day);
    } catch (e) {
      return DateTime.now();
    }
  }
  
  static DateTime parseDateTime(String dateTimeString) {
    try {
      final dateParts = dateTimeString.split(' ')[0];
      final timeParts = dateTimeString.split(' ')[1];
      
      final date = parseDate(dateParts);
      final time = timeParts.split(':');
      
      final hour = int.parse(time[0]);
      final minute = int.parse(time[1]);
      
      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (e) {
      return DateTime.now();
    }
  }
  
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }
  
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
           date.month == yesterday.month &&
           date.day == yesterday.day;
  }
  
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }
  
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }
  
  static bool isThisYear(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year;
  }
  
  static List<DateTime> getDaysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    
    final days = <DateTime>[];
    for (int i = 0; i <= lastDay.day - 1; i++) {
      days.add(DateTime(date.year, date.month, i + 1));
    }
    
    return days;
  }
  
  static DateTime getFirstDayOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }
  
  static DateTime getLastDayOfWeek(DateTime date) {
    return date.add(Duration(days: 7 - date.weekday));
  }
  
  static String getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }
  
  static String getDayName(int day) {
    const days = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
    ];
    return days[day - 1];
  }
  
  static int getDaysBetween(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }
  
  static int getMonthsBetween(DateTime start, DateTime end) {
    final months = (end.year - start.year) * 12 + (end.month - start.month);
    return months.abs();
  }
  
  static int getYearsBetween(DateTime start, DateTime end) {
    return (end.year - start.year).abs();
  }
  
  static DateTime addWorkingDays(DateTime date, int days) {
    DateTime result = date;
    int remainingDays = days;
    
    while (remainingDays > 0) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday && result.weekday != DateTime.sunday) {
        remainingDays--;
      }
    }
    
    return result;
  }
  
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }
  
  static bool isHoliday(DateTime date) {
    // Implement holiday logic based on user's region
    // This is a placeholder for holiday checking
    return false;
  }
}