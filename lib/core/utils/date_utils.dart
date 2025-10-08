import 'package:intl/intl.dart';

String formatDateShort(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

String formatDateOnlyDay(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String formatMonthYear(DateTime date) {
  return DateFormat.yMMMM().format(date);
}
