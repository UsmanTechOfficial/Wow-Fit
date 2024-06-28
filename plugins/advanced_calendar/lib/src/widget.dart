import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/src/dateModel.dart';
import 'package:intl/intl.dart';

import 'controller.dart';
import 'datetime_util.dart';

part 'date_box.dart';
part 'handlebar.dart';
part 'header.dart';
part 'month_view.dart';
part 'month_view_bean.dart';
part 'week_days.dart';
part 'week_view.dart';

/// Advanced Calendar widget.
class AdvancedCalendar extends StatefulWidget {
  const AdvancedCalendar({
    Key? key,
    this.controller,
    this.startWeekDay,
    this.events,
    this.weekLineHeight = 32.0,
    this.preloadMonthViewAmount = 13,
    this.preloadWeekViewAmount = 56,
    this.weeksInMonthViewAmount = 6,
    this.todayStyle,
    this.dateStyle,
    this.onHorizontalDrag,
    this.innerDot = false,
    required this.callback,
  }) : super(key: key);

  /// Calendar selection date controller.
  final AdvancedCalendarController? controller;

  /// Executes on horizontal calendar swipe. Allows to load additional dates.
  final Function(DateTime)? onHorizontalDrag;

  /// Height of week line.
  final double weekLineHeight;

  /// Amount of months in month view to preload.
  final int preloadMonthViewAmount;

  /// Amount of weeks in week view to preload.
  final int preloadWeekViewAmount;

  /// Weeks lines amount in month view.
  final int weeksInMonthViewAmount;

  /// List of points for the week and mounth
  final List<DateModel>? events;

  /// The first day of the week starts[0-6]
  final int? startWeekDay;

  /// Style of date
  final TextStyle? dateStyle;

  /// Style of Today button
  final TextStyle? todayStyle;

  /// Show DateBox event in container.
  final bool innerDot;

  final Function(DateTime?, bool) callback;

  @override
  _AdvancedCalendarState createState() => _AdvancedCalendarState();
}

class _AdvancedCalendarState extends State<AdvancedCalendar>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<int> _monthViewCurrentPage;
  late AnimationController _animationController;
  late AdvancedCalendarController _controller;
  late double _animationValue;
  late List<ViewRange> _monthRangeList;
  late List<List<DateTime>> _weekRangeList;

  PageController? _monthPageController;
  PageController? _weekPageController;
  Offset? _captureOffset;
  DateTime? _todayDate;
  List<String>? _weekNames;
  var _selectedDate;
  bool monthready = false;
  bool weekready = false;

  @override
  void initState() {
    super.initState();

    final monthPageIndex = widget.preloadMonthViewAmount ~/ 2;

    _monthViewCurrentPage = ValueNotifier(monthPageIndex);

    _monthPageController = PageController(
      initialPage: monthPageIndex,
    );

    final weekPageIndex = widget.preloadWeekViewAmount ~/ 2;

    _weekPageController = PageController(
      initialPage: weekPageIndex,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0,
    );

    _animationValue = _animationController.value;

    _controller = widget.controller ?? AdvancedCalendarController.today();
    _todayDate = _controller.value;

    _monthRangeList = List.generate(
      widget.preloadMonthViewAmount,
      (index) => ViewRange.generateDates(
        _todayDate!,
        _todayDate!.month + (index - _monthPageController!.initialPage),
        widget.weeksInMonthViewAmount,
        startWeekDay: widget.startWeekDay,
      ),
    );

    _weekRangeList = _controller.value.generateWeeks(
      widget.preloadWeekViewAmount,
      startWeekDay: widget.startWeekDay,
    );
    _controller.addListener(() {
      _weekRangeList = _controller.value.generateWeeks(
        widget.preloadWeekViewAmount,
        startWeekDay: widget.startWeekDay,
      );
      _weekPageController!.jumpToPage(widget.preloadWeekViewAmount ~/ 2);
    });
    if (widget.startWeekDay != null && widget.startWeekDay! < 7) {
      final time = _controller.value.subtract(
        Duration(days: _controller.value.weekday - widget.startWeekDay!),
      );
      final list = List<DateTime>.generate(
        8,
        (index) => time.add(Duration(days: index * 1)),
      ).toList();
      _weekNames = List<String>.generate(7, (index) {
        return DateFormat("EEEE").format(list[index]).split('').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: DefaultTextStyle(
        style: theme.textTheme.bodyText2!,
        child: GestureDetector(
          onVerticalDragStart: (details) {
            _captureOffset = details.globalPosition;
          },
          onVerticalDragUpdate: (details) {
            final moveOffset = details.globalPosition;
            final diffY = moveOffset.dy - _captureOffset!.dy;

            _animationController.value =
                _animationValue + diffY / (widget.weekLineHeight * 5);
          },
          onVerticalDragEnd: (details) => _handleFinishDrag(),
          // onVerticalDragCancel: _handleFinishDrag,
          child: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _monthViewCurrentPage,
                  builder: (_, value, __) {
                    return Header(
                      monthDate:
                          _monthRangeList[_monthViewCurrentPage.value].firstDay,
                      callback: monthJump,
                      dateStyle: widget.dateStyle,
                      todayStyle: widget.todayStyle,
                      onPressed: () async {
                        if (_animationValue == 1.0) {
                          //_handleDateChangedAgain(_todayDate!);
                          closeCalendar(resetToday:true);
                        } else {
                          openCalendar();
                        }
                      },
                      dateFormatter: DateFormat().add_MMMM(),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, __) {
                    final height = Tween<double>(
                      begin: 60,
                      end:
                          widget.weekLineHeight * widget.weeksInMonthViewAmount,
                    ).transform(_animationController.value);
                    return Column(
                      children: [
                        SizedBox(
                          height: height,
                          child: ValueListenableBuilder<DateTime>(
                            valueListenable: _controller,
                            builder: (_, selectedDate, __) {
                              _selectedDate = selectedDate;
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  IgnorePointer(
                                    ignoring: _animationController.value == 0.0,
                                    child: Opacity(
                                      opacity: Tween<double>(
                                        begin: 0.0,
                                        end: 1.0,
                                      ).evaluate(_animationController),
                                      child: PageView.builder(
                                        onPageChanged: (pageIndex) {
                                          if (widget.onHorizontalDrag != null) {
                                            widget.onHorizontalDrag!(
                                              _monthRangeList[pageIndex]
                                                  .firstDay,
                                            );
                                          }
                                          debugPrint("hello here ${pageIndex}");
                                          if (!weekchanged) {
                                            if (_monthViewCurrentPage.value !=
                                                pageIndex) {
                                              _monthViewCurrentPage.value =
                                                  pageIndex;
                                              weekJump(
                                                  _monthRangeList[pageIndex]
                                                      .firstDay);
                                            }
                                          }
                                        },
                                        controller: _monthPageController,
                                        physics: _animationController.value ==
                                                1.0
                                            ? const AlwaysScrollableScrollPhysics()
                                            : const NeverScrollableScrollPhysics(),
                                        itemCount: _monthRangeList.length,
                                        itemBuilder: (_, pageIndex) {
                                          monthready = true;
                                          return Container(
                                            margin: const EdgeInsets.only(
                                              top: 25,
                                            ),
                                            child: MonthView(
                                              innerDot: widget.innerDot,
                                              monthView:
                                                  _monthRangeList[pageIndex],
                                              todayDate: _todayDate,
                                              selectedDate: selectedDate,
                                              weekLineHeight: 50,
                                              weeksAmount:
                                                  widget.weeksInMonthViewAmount,
                                              onChanged: _handleDateChanged,
                                              events: widget.events,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  ValueListenableBuilder<int>(
                                    valueListenable: _monthViewCurrentPage,
                                    builder: (_, pageIndex, __) {
                                      final index = selectedDate.findWeekIndex(
                                        _monthRangeList[
                                                _monthViewCurrentPage.value]
                                            .dates,
                                      );
                                      final offset = index /
                                              (widget.weeksInMonthViewAmount -
                                                  1) *
                                              2 -
                                          1.0;
                                      print(offset);
                                      return Align(
                                        alignment: Alignment.center,
                                        child: IgnorePointer(
                                          ignoring:
                                              _animationController.value == 1.0,
                                          child: Opacity(
                                            opacity: Tween<double>(
                                              begin: 1.0,
                                              end: 0.0,
                                            ).evaluate(_animationController),
                                            child: SizedBox(
                                              height: 70,
                                              child: PageView.builder(
                                                onPageChanged: (indexPage) {
                                                  final pageIndex =
                                                      _monthRangeList
                                                          .indexWhere(
                                                    (index) =>
                                                        index.firstDay.month ==
                                                        _weekRangeList[
                                                                indexPage]
                                                            .first
                                                            .month,
                                                  );

                                                  if (widget.onHorizontalDrag !=
                                                      null) {
                                                    widget.onHorizontalDrag!(
                                                      _monthRangeList[pageIndex]
                                                          .firstDay,
                                                    );
                                                  }
                                                  if (_monthViewCurrentPage
                                                          .value !=
                                                      pageIndex) {
                                                    if (!weekchanged)
                                                      _monthViewCurrentPage
                                                          .value = pageIndex;
                                                    else
                                                      weekchanged = false;
                                                  }
                                                },
                                                controller: _weekPageController,
                                                itemCount:
                                                    _weekRangeList.length,
                                                physics: closeMonthScroll(),
                                                itemBuilder: (context, index) {
                                                  weekready = true;
                                                  return WeekView(
                                                    innerDot: widget.innerDot,
                                                    dates:
                                                        _weekRangeList[index],
                                                    selectedDate: selectedDate,
                                                    topPadding: 0,
                                                    lineHeight: 52,
                                                    dateHeight: 52,
                                                    onChanged:
                                                        _handleWeekDateChanged,
                                                    // _handleWeekDateChanged
                                                    events: widget.events,
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: WeekDays(
                                      selectedDate: selectedDate,
                                      style: theme.textTheme.bodyText1!
                                          .copyWith(
                                              color: const Color(0XFFBCC1CD),
                                              fontSize: 12),
                                      weekNames: _weekNames != null
                                          ? _weekNames!
                                          : const <String>[
                                              'S',
                                              'M',
                                              'T',
                                              'W',
                                              'T',
                                              'F',
                                              'S'
                                            ],
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                /*HandleBar(
                  onPressed: () async {
                    if (_animationValue == 1.0) {
                      await _animationController.reverse();
                      _animationValue = 0.0;
                    } else {
                      await _animationController.forward();
                      _animationValue = 1.0;
                    }
                  },
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  void monthJump(DateTime dateTime) {
    try {
      var v = _monthRangeList.lastIndexWhere(
          (monthRange) => monthRange.firstDay.isSameDate(dateTime));
      if (v != -1) {
        if (monthready) {
          if (!weekchanged) {
            _monthPageController!.jumpToPage(v);
          } else {
            weekchanged = false;
          }
        }
      }
    } catch (e) {}
  }

  bool weekchanged = false;
  void weekJump(DateTime dateTime) {
    var d = DateTime(dateTime.year, dateTime.month, dateTime.day, 12,
        dateTime.minute, dateTime.second);
    var v = -1;
    int i = -1;
    for (var e in _weekRangeList) {
      i++;
      v = e.lastIndexWhere((element) =>
          element.month == dateTime.month &&
          element.year == dateTime.year &&
          element.day == dateTime.day);
      if (v != -1) {
        v = i;
        break;
      }
    }
    if (v != -1) {
      if (weekready) {
        weekchanged = true;
        _weekPageController!.jumpToPage(v);
      }
    }
  }

  void _handleWeekDateChanged(DateTime date) {
    _handleDateChanged(date);

    _monthViewCurrentPage.value = _monthRangeList
        .lastIndexWhere((monthRange) => monthRange.dates.contains(date));
    // widget.callback(date, true);
  }

  void _handleDateChangedAgain(DateTime date) {
    _controller.value = _todayDate!;

    _monthViewCurrentPage.value = _monthRangeList
        .lastIndexWhere((monthRange) => monthRange.dates.contains(date));
  }

  void _handleDateChanged(DateTime date) {
    if (_todayDate!.isAtSameMomentAs(date)) {
      widget.callback(DateTime.now(), false);
    } else {
      widget.callback(date, true);
    }
    _controller.value = date;
    _monthViewCurrentPage.value = _monthRangeList
        .lastIndexWhere((monthRange) => monthRange.dates.contains(date));
  }

  void _handleFinishDrag() async {
    _captureOffset = null;

    if (_animationController.value > 0.5) {
      openCalendar();
    } else {
      closeCalendar(resetToday:false);
    }
  }
  openCalendar() async {
    _handleDateChanged(_controller.value);
    widget.callback(_controller.value, false);
    await _animationController.forward();
    _animationValue = 1.0;
  }
  closeCalendar({required bool resetToday}) async {
    if(resetToday){
      _handleTodayPressed();
    }else{
      _handleDateChanged(_controller.value);
    }
    widget.callback(_controller.value, false);
    await _animationController.reverse();
    _animationValue = 0.0;
  }
  void _handleTodayPressed() {
    _controller.value = DateTime.now().toZeroTime();
    _monthPageController!.jumpToPage(widget.preloadMonthViewAmount ~/ 2);
    _weekPageController!.jumpToPage(widget.preloadWeekViewAmount ~/ 2);
  }
  ScrollPhysics closeMonthScroll() {
    if ((_monthViewCurrentPage.value ==
            (widget.preloadMonthViewAmount ~/ 2) + 3 ||
        _monthViewCurrentPage.value ==
            (widget.preloadMonthViewAmount ~/ 2) - 3)) {
      return const NeverScrollableScrollPhysics();
    } else {
      return const AlwaysScrollableScrollPhysics();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _monthPageController!.dispose();
    _monthViewCurrentPage.dispose();

    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }
}
