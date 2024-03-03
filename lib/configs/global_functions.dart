import 'dart:math';
import 'dart:ui';

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

List<Color> generateGlobalRandomColors(int length) {
  Random random = Random();
  List<Color> colors = [];

  for (int i = 0; i < length; i++) {
    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);

    Color color = Color.fromARGB(255, red, green, blue);
    colors.add(color);
  }

  return colors;
}

var globalSelectedBranch;
