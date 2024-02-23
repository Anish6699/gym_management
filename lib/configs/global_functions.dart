bool isStartDateAfterEndDate(String startDateStr, String endDateStr) {
  // Parse date strings into DateTime objects
  DateTime startDate = parseDate(startDateStr);
  DateTime endDate = parseDate(endDateStr);

  // Compare the DateTime objects
  return startDate.isAfter(endDate);
}

DateTime parseDate(String dateStr) {
  List<String> parts = dateStr.split('-');
  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);
  return DateTime(year, month, day);
}
