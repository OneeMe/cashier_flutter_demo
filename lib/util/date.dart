import 'package:intl/intl.dart';

String formatTime(DateTime dateTime) {
  // Format the time as per your requirements
  return DateFormat('HH:mm').format(dateTime);
}
