part of 'widget.dart';

class WeekView extends StatelessWidget {
  WeekView({
    Key? key,
    required this.dates,
    required this.selectedDate,
    required this.lineHeight,
    required this.dateHeight,
    this.highlightMonth,
    required this.topPadding,
    this.onChanged,
    this.events,
    required this.innerDot,
  }) : super(key: key);

  final DateTime todayDate = DateTime.now().toZeroTime();
  final List<DateTime> dates;
  final double lineHeight;
  double dateHeight = 70;
  double topPadding;
  final int? highlightMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime>? onChanged;
  final List<DateModel>? events;
  final bool innerDot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: lineHeight,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List<Widget>.generate(
          7,
          (dayIndex) {
            final date = dates[dayIndex];
            final isToday = date.isAtSameMomentAs(todayDate);
            final isSelected = date.isAtSameMomentAs(selectedDate);
            final isHighlight = highlightMonth == date.month;

            final containsToday = events!
                .indexWhere((element) => element.dateTime.isSameDate(date));

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DateBox(
                  color: const Color(0xFF1B5DEC),
                  width: innerDot ? 35 : 40,
                  height: innerDot ? dateHeight : dateHeight,
                  showDot: innerDot,
                  onPressed: onChanged != null ? () => onChanged!(date) : null,
                  isSelected: isSelected,
                  isToday: isToday,
                  hasEvent: containsToday != -1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16, //topPadding,
                      ),
                      Expanded(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected || isToday
                                ? theme.colorScheme.onPrimary
                                : isHighlight || highlightMonth == null
                                    ? null
                                    : theme.disabledColor,
                          ),
                        ),
                      ),
                      /*const Expanded(
                        child: SizedBox(
                          height: 2,
                        ),
                      ),*/
                      if (!innerDot)
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: List<Widget>.generate(
                            events != null ? events!.length : 0,
                            (index) => events![index].dateTime.isSameDate(date)
                                ? Container(
                                    height: 6,
                                    width: 6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: isSelected
                                          ? Colors.white
                                          : events![index].color,
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      const SizedBox(
                        height: 5,
                      )
                      /*Container(
                          height: 3,
                          width: 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                          ),
                        )*/
                    ],
                  ),
                ),
              ],
            );
          },
          growable: false,
        ),
      ),
    );
  }
}
