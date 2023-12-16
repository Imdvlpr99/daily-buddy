import 'package:daily_buddy/widget/calendar_timeline.dart';
import 'package:daily_buddy/widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

typedef OnDateSelected = void Function(DateTime);

class CalendarTimeline extends StatefulWidget {
  CalendarTimeline({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
    this.selectableDayPredicate,
    this.leftMargin = 0,
    this.dayColor,
    this.activeDayColor,
    this.activeBackgroundDayColor,
    this.monthColor,
    this.dotsColor,
    this.dayNameColor,
    this.shrink = false,
    this.locale,
    this.showYears = false,
  })  : assert(
          initialDate.difference(firstDate).inDays >= 0,
          'initialDate must be on or after firstDate',
        ),
        assert(
          !initialDate.isAfter(lastDate),
          'initialDate must be on or before lastDate',
        ),
        assert(
          !firstDate.isAfter(lastDate),
          'lastDate must be on or after firstDate',
        ),
        assert(
          selectableDayPredicate == null || selectableDayPredicate(initialDate),
          'Provided initialDate must satisfy provided selectableDayPredicate',
        ),
        assert(
          locale == null || dateTimeSymbolMap().containsKey(locale),
          "Provided locale value doesn't exist",
        ),
        super(key: key);
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final SelectableDayPredicate? selectableDayPredicate;
  final OnDateSelected onDateSelected;
  final double leftMargin;
  final Color? dayColor;
  final Color? activeDayColor;
  final Color? activeBackgroundDayColor;
  final Color? monthColor;
  final Color? dotsColor;
  final Color? dayNameColor;
  final bool shrink;
  final String? locale;
  final bool showYears;

  @override
  State<CalendarTimeline> createState() => _CalendarTimelineState();
}

class _CalendarTimelineState extends State<CalendarTimeline> {
  final ItemScrollController _controllerYear = ItemScrollController();
  final ItemScrollController _controllerMonth = ItemScrollController();
  final ItemScrollController _controllerDay = ItemScrollController();
  final List<DateTime> _years = [];
  final List<DateTime> _months = [];
  final List<DateTime> _days = [];

  int? _yearSelectedIndex;
  int? _monthSelectedIndex;
  int? _daySelectedIndex;

  late DateTime _selectedDate;
  late String _locale;
  late double _scrollAlignment;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initCalendar();
  }

  @override
  void didUpdateWidget(CalendarTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != _selectedDate ||
        widget.showYears != oldWidget.showYears) {
      _initCalendar();
    }
  }

  void _initCalendar() {
    _locale = widget.locale ?? Localizations.localeOf(context).languageCode;
    initializeDateFormatting(_locale);
    _selectedDate = widget.initialDate;
    if (widget.showYears) {
      _generateYears();
      _selectedYearIndex();
      _moveToYearIndex(_yearSelectedIndex ?? 0);
    }
    _generateMonths(_selectedDate);
    _selectedMonthIndex();
    _moveToMonthIndex(_monthSelectedIndex ?? 0);
    _generateDays(_selectedDate);
    _selectedDayIndex();
    _moveToDayIndex(_daySelectedIndex ?? 0);
  }

  void _generateYears() {
    _years.clear();
    var date = widget.firstDate;
    while (date.isBefore(widget.lastDate)) {
      _years.add(date);
      date = DateTime(date.year + 1);
    }
  }

  void _generateMonths(DateTime? selectedDate) {
    _months.clear();
    if (widget.showYears) {
      final month = selectedDate!.year == widget.firstDate.year
          ? widget.firstDate.month
          : 1;
      var date = DateTime(selectedDate.year, month);
      while (date.isBefore(DateTime(selectedDate.year + 1)) &&
          date.isBefore(widget.lastDate)) {
        _months.add(date);
        date = DateTime(date.year, date.month + 1);
      }
    } else {
      var date = DateTime(widget.firstDate.year, widget.firstDate.month);
      while (date.isBefore(widget.lastDate)) {
        _months.add(date);
        date = DateTime(date.year, date.month + 1);
      }
    }
  }

  void _generateDays(DateTime? selectedDate) {
    _days.clear();
    for (var i = 1; i <= 31; i++) {
      final day = DateTime(selectedDate!.year, selectedDate.month, i);
      if (day.difference(widget.firstDate).inDays < 0) continue;
      if (day.month != selectedDate.month || day.isAfter(widget.lastDate)) {
        break;
      }
      _days.add(day);
    }
  }

  void _selectedYearIndex() {
    _yearSelectedIndex = _years.indexOf(
      _years.firstWhere((yearDate) => yearDate.year == _selectedDate.year),
    );
  }

  void _selectedMonthIndex() {
    if (widget.showYears) {
      _monthSelectedIndex = _months.indexOf(
        _months
            .firstWhere((monthDate) => monthDate.month == _selectedDate.month),
      );
    } else {
      _monthSelectedIndex = _months.indexOf(
        _months.firstWhere(
          (monthDate) =>
              monthDate.year == _selectedDate.year &&
              monthDate.month == _selectedDate.month,
        ),
      );
    }
  }

  void _selectedDayIndex() {
    _daySelectedIndex = _days.indexOf(
      _days.firstWhere((dayDate) => dayDate.day == _selectedDate.day),
    );
  }

  void _moveToYearIndex(int index) {
    if (_controllerYear.isAttached) {
      _controllerYear.scrollTo(
        index: index,
        alignment: _scrollAlignment,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
  }

  void _moveToMonthIndex(int index) {
    if (_controllerMonth.isAttached) {
      _controllerMonth.scrollTo(
        index: index,
        alignment: _scrollAlignment,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
  }

  void _moveToDayIndex(int index) {
    if (_controllerDay.isAttached) {
      _controllerDay.scrollTo(
        index: index,
        alignment: _scrollAlignment,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
  }

  void _onSelectYear(int index) {
    _yearSelectedIndex = index;
    _moveToYearIndex(index);

    _monthSelectedIndex = null;
    _daySelectedIndex = null;

    final date = _years[index];
    if (widget.showYears) {
      _generateMonths(date);
      _moveToMonthIndex(0);
    }
    _generateDays(date);
    _moveToDayIndex(0);
    setState(() {});
  }

  void _onSelectMonth(int index) {
    _monthSelectedIndex = index;
    _moveToMonthIndex(index);

    _daySelectedIndex = null;

    _generateDays(_months[index]);
    _moveToDayIndex(0);
    setState(() {});
  }

  void _onSelectDay(int index) {
    // Move to selected day
    _daySelectedIndex = index;
    _moveToDayIndex(index);
    setState(() {});

    _selectedDate = _days[index];
    widget.onDateSelected(_selectedDate);
  }

  bool _isSelectedDay(int index) =>
      _monthSelectedIndex != null &&
      (index == _daySelectedIndex || index == _indexOfDay(_selectedDate));

  int _indexOfDay(DateTime date) {
    try {
      return _days.indexOf(
        _days.firstWhere(
          (dayDate) =>
              dayDate.day == date.day &&
              dayDate.month == date.month &&
              dayDate.year == date.year,
        ),
      );
    } catch (_) {
      return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    _scrollAlignment = widget.leftMargin / MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.showYears) _buildYearList(),
        _buildMonthList(),
        _buildDayList(),
      ],
    );
  }

  Widget _buildYearList() {
    return SizedBox(
      key: const Key('ScrollableYearList'),
      height: 40,
      child: ScrollablePositionedList.builder(
        initialScrollIndex: _yearSelectedIndex ?? 0,
        initialAlignment: _scrollAlignment,
        itemScrollController: _controllerYear,
        padding: EdgeInsets.only(left: widget.leftMargin),
        scrollDirection: Axis.horizontal,
        itemCount: _years.length,
        itemBuilder: (BuildContext context, int index) {
          final currentDate = _years[index];
          final yearName = DateFormat.y(_locale).format(currentDate);

          return Padding(
            padding: const EdgeInsets.only(right: 12, left: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                YearItem(
                  isSelected: _yearSelectedIndex == index,
                  name: yearName,
                  onTap: () => _onSelectYear(index),
                  color: widget.monthColor,
                  small: false,
                  shrink: widget.shrink,
                ),
                if (index == _years.length - 1)
                  SizedBox(
                    width: MediaQuery.of(context).size.width -
                        widget.leftMargin -
                        (yearName.length * 10),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthList() {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Selected Month on the Left
          Padding(
            padding: EdgeInsets.only(left: widget.leftMargin),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.showYears) _buildYearList(),
                MonthItem(
                  isSelected: true,
                  name: DateFormat('MMMM yyyy', _locale).format(_months[_monthSelectedIndex ?? 0]),
                  onTap: () => _onSelectMonth(_monthSelectedIndex ?? 0),
                  color: widget.monthColor,
                  shrink: widget.shrink,
                  activeColor: widget.activeBackgroundDayColor,
                ),
                const SizedBox(width: 5),
                PopupMenuButton<int>(
                  icon: const Icon(Iconsax.arrow_down5, color: Colors.white),
                  itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 1,
                      child: Container(
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: List.generate(
                            _months.length,
                                (index) => PopupMenuItem<int>(
                              value: index,
                              child: SizedBox(
                                width: 120,
                                child: Center(
                                  child: Text(
                                    DateFormat.MMMM(_locale).format(_months[index]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  onSelected: (int value) {
                    setState(() {
                      _monthSelectedIndex = value;
                      _onSelectMonth(value);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayList() {
    return SizedBox(
      key: const Key('ScrollableDayList'),
      height: 100,
      child: ScrollablePositionedList.builder(
        itemScrollController: _controllerDay,
        initialScrollIndex: _daySelectedIndex ?? 0,
        initialAlignment: _scrollAlignment,
        scrollDirection: Axis.horizontal,
        itemCount: _days.length,
        padding: EdgeInsets.only(left: widget.leftMargin, right: 6),
        itemBuilder: (BuildContext context, int index) {
          final currentDay = _days[index];
          final shortName =
          Utils.capitalize(DateFormat.E(_locale).format(currentDay));
          return Padding(
            padding: const EdgeInsets.only(right: 10), // Add padding to the end
            child: Row(
              children: <Widget>[
                DayItem(
                  isSelected: _isSelectedDay(index),
                  dayNumber: currentDay.day,
                  shortName: shortName.length > 3
                      ? shortName.substring(0, 3)
                      : shortName,
                  onTap: () => _onSelectDay(index),
                  available: widget.selectableDayPredicate == null ||
                      widget.selectableDayPredicate!(currentDay),
                  dayColor: widget.dayColor,
                  activeDayColor: widget.activeDayColor,
                  activeDayBackgroundColor: widget.activeBackgroundDayColor,
                  dotsColor: widget.dotsColor,
                  dayNameColor: widget.dayNameColor,
                  shrink: widget.shrink,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
