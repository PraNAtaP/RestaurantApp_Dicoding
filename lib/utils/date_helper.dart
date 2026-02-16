class DateHelper {
  static DateTime parseIndonesianDate(String dateStr) {
    try {
      final parts = dateStr.split(' ');
      if (parts.length != 3) return DateTime.now();

      final day = int.parse(parts[0]);
      final monthStr = parts[1];
      final year = int.parse(parts[2]);

      final month = _getMonthIndex(monthStr);

      return DateTime(year, month, day);
    } catch (e) {
      return DateTime.now();
    }
  }

  static int _getMonthIndex(String month) {
    switch (month.toLowerCase()) {
      case 'januari':
      case 'january':
      case 'jan':
        return 1;
      case 'februari':
      case 'february':
      case 'feb':
        return 2;
      case 'maret':
      case 'march':
      case 'mar':
        return 3;
      case 'april':
      case 'apr':
        return 4;
      case 'mei':
      case 'may':
        return 5;
      case 'juni':
      case 'june':
      case 'jun':
        return 6;
      case 'juli':
      case 'july':
      case 'jul':
        return 7;
      case 'agustus':
      case 'august':
      case 'aug':
        return 8;
      case 'september':
      case 'sep':
        return 9;
      case 'oktober':
      case 'october':
      case 'oct':
        return 10;
      case 'november':
      case 'nov':
        return 11;
      case 'desember':
      case 'december':
      case 'dec':
        return 12;
      default:
        return 1;
    }
  }
}
