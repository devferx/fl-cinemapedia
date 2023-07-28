import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number, [int decimals = 0]) {
    return NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: '',
      locale: 'en',
    ).format(number);
  }

  static String shortDate(DateTime date) {
    final format = DateFormat.yMMMEd('es');
    return format.format(date);
  }

  /// Returns the day of the week in Spanish and Capitalized and the day number
  static String getDay(DateTime date) {
    final format = DateFormat.EEEE('es');
    final dayUncapitalized = format.format(date);
    final day =
        dayUncapitalized[0].toUpperCase() + dayUncapitalized.substring(1);
    final dayNumber = date.day.toString();

    return '$day $dayNumber';
  }
}
