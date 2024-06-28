import 'package:wowfit/BottomSheet/editBottomSheet.dart';
import 'package:wowfit/CustomCalendar/calendar.dart';

class CustomCalendar {
// number of days in month
  //[JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC]
  final List<int> _monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

// check for leap year
  bool _isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) return true;
        return false;
      }
      return true;
    }
    return false;
  }

  List<Calendar>? getMonthCalendar(int month, int year,
      {StartWeekDay startWeekDay = StartWeekDay.sunday}) {
    // validate
    if (year == null || month == null || month < 1 || month > 12) {
      throw ArgumentError('Invalid year or month');
    }
    List<Calendar> calendar = <Calendar>[];
    int totalDays = _monthDays[month - 1];
    if (_isLeapYear(year) && month == DateTime.february) totalDays++;
    for (int i = 0; i < totalDays; i++) {
      calendar.add(
        Calendar(
          date: DateTime(year, month, i + 1),
          thisMonth: true,
        ),
      );
    }
    int otherYear;
    int otherMonth;
    int leftDays;

    if ((startWeekDay == StartWeekDay.sunday &&
            calendar.first.date!.weekday != DateTime.sunday) ||
        (startWeekDay == StartWeekDay.monday &&
            calendar.first.date!.weekday != DateTime.monday)) {
      if (month == DateTime.january) {
        otherMonth = DateTime.december;
        otherYear = year - 1;
      } else {
        otherMonth = month - 1;
        otherYear = year;
      }
      totalDays = _monthDays[otherMonth - 1];
      if (_isLeapYear(otherYear) && otherMonth == DateTime.february) {
        totalDays++;
      }
      leftDays = totalDays -
          calendar.first.date!.weekday +
          ((startWeekDay == StartWeekDay.sunday) ? 0 : 1);

      for (int i = totalDays; i > leftDays; i--) {
        calendar.insert(
          0,
          Calendar(
            date: DateTime(otherYear, otherMonth, i),
            prevMonth: true,
          ),
        );
      }
    }
    if ((startWeekDay == StartWeekDay.sunday &&
            calendar.last.date!.weekday != DateTime.saturday) ||
        (startWeekDay == StartWeekDay.monday &&
            calendar.last.date!.weekday != DateTime.sunday)) {
      if (month == DateTime.december) {
        otherMonth = DateTime.january;
        otherYear = year + 1;
      } else {
        otherMonth = month + 1;
        otherYear = year;
      }
      totalDays = _monthDays[otherMonth - 1];
      if (_isLeapYear(otherYear) && otherMonth == DateTime.february)
        totalDays++;
      leftDays = 7 -
          calendar.last.date!.weekday -
          ((startWeekDay == StartWeekDay.sunday) ? 1 : 0);
      if (leftDays == -1) leftDays = 6;
      for (int i = 0; i < leftDays; i++) {
        calendar.add(
          Calendar(
            date: DateTime(otherYear, otherMonth, i + 1),
            nextMonth: true,
          ),
        );
      }
    }
    return calendar;
  }
}
