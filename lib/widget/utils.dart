import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class Utils {
  static Logger getLogger() {
    return Logger(
      printer: PrettyPrinter(),
    );
  }

  static String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  static String formatDateTime(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
  }

  static String formatDateString(String source, String outputFormat) {
    DateTime dateTime = DateTime.parse(source);
    return DateFormat(outputFormat, 'id').format(dateTime);
  }

  static String formatTimeString(String source, String inputFormat, String outputFormat) {
    DateTime dateTime = DateFormat(inputFormat, 'id').parse(source);
    return DateFormat(outputFormat, 'id').format(dateTime);
  }
}