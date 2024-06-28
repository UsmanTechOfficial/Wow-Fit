part of 'widget.dart';

/// Week day names line.
class WeekDays extends StatelessWidget {
  const WeekDays({
    required this.selectedDate,
    Key? key,
    this.weekNames = const <String>['S', 'M', 'T', 'W', 'T', 'F', 'S'],
    this.style,
  })  : assert(weekNames.length == 7, '`weekNames` must have length 7'),
        super(key: key);

  /// Week day names.
  final List<String> weekNames;
  final DateTime selectedDate;

  /// Text style.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: style!,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(weekNames.length, (index) {
          return Padding(
            padding: EdgeInsets.only(top: 0),
            child: DateBox(
              child: Text(
                weekNames[index],
              ),
            ),
          );
        }),
      ),
    );
  }
}
