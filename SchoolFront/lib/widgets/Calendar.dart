import 'package:flutter/material.dart';
import 'package:school/api/lesson_api.dart';
import 'package:table_calendar/table_calendar.dart';
import '../dataclasses/lesson.dart';
import 'booking_and_detail_widget.dart';

class LessonCalendarWidget extends StatefulWidget {
  @override
  _LessonCalendarWidgetState createState() => _LessonCalendarWidgetState();
}

class _LessonCalendarWidgetState extends State<LessonCalendarWidget> {
  final ValueNotifier<Map<DateTime, List<Lesson>>> _lessonsNotifier = ValueNotifier({});
  final ValueNotifier<DateTime> _selectedDayNotifier = ValueNotifier(DateTime.now());
  DateTime _focusedDay = DateTime.now();
  final lessonApi = LessonApi();

  @override
  void initState() {
    super.initState();
    _initializeLessons();
  }

  void _initializeLessons() async {
    final List<Lesson> lessons = await lessonApi.getLessons();
    Map<DateTime, List<Lesson>> resultLessons = {};

    for (var lesson in lessons) {
      // Extract only the date portion for mapping
      DateTime date = DateTime.utc(lesson.time.year, lesson.time.month, lesson.time.day);
      if (resultLessons.containsKey(date)) {
        resultLessons[date]!.add(lesson);
      } else {
        resultLessons[date] = [lesson];
      }
    }
    _lessonsNotifier.value = resultLessons;

    // Updating the ValueNotifier and triggering a UI rebuild
    setState(() {
      _lessonsNotifier;
    });
  }

  List<Lesson> _getLessonsForDay(DateTime day) {
    return _lessonsNotifier.value[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDayNotifier.value = selectedDay;
      _focusedDay = focusedDay;
    });
    _showBookingAndDetailWidget(selectedDay);
  }

  void _showBookingAndDetailWidget(DateTime day) {
    final bool allowAdding = day.isAfter(DateTime.now()) || isSameDay(day, DateTime.now());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BookingAndDetailWidget(
        day: day,
        lessonsNotifier: _lessonsNotifier,
        onSave: (lesson) => _addLesson(day, lesson),
        onDelete: (index) => _deleteLesson(day, index),
        allowAdding: allowAdding,
      ),
    );
  }

  void _deleteLesson(DateTime day, int index) {
    final lesson = _lessonsNotifier.value[day];
    if (lesson != null && lesson.isNotEmpty) {
      lesson.removeAt(index);
      if (lesson.isEmpty) {
        _lessonsNotifier.value.remove(day);
      }
      setState(() {
        _lessonsNotifier;
      });
    }
  }

  void _addLesson(DateTime day, Lesson lesson) {
    setState(() {
      final lessons = _lessonsNotifier.value[day] ?? [];
      lessons.add(lesson);
      _lessonsNotifier.value = {
        ..._lessonsNotifier.value,
        day: lessons,
      };
      _lessonsNotifier;// Notify listeners after adding a lesson
    });
    print(_lessonsNotifier.value);
  }

  @override
  void dispose() {
    _lessonsNotifier.dispose();
    _selectedDayNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _selectedDayNotifier,
      builder: (context, selectedDay, _) {
        return ValueListenableBuilder<Map<DateTime, List<Lesson>>>(
          valueListenable: _lessonsNotifier,
          builder: (context, lessonMap, __) {
            return TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2024, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              onDaySelected: _onDaySelected,
              eventLoader: _getLessonsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: _buildCalendarStyle(),
              headerStyle: _buildHeaderStyle(),
            );
          },
        );
      },
    );
  }

  CalendarStyle _buildCalendarStyle() {
    return CalendarStyle(
      markerDecoration: BoxDecoration(
        color: Colors.orangeAccent,
        shape: BoxShape.circle,
      ),
      defaultTextStyle: TextStyle(
        color: Colors.white70,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      weekendTextStyle: TextStyle(
        color: Colors.red,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      todayTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      todayDecoration: BoxDecoration(
        color: Color(0xFFFFA726),
        shape: BoxShape.circle,
      ),
      selectedDecoration: BoxDecoration(
        color: Color(0xFF66BB6A),
        shape: BoxShape.circle,
      ),
    );
  }

  HeaderStyle _buildHeaderStyle() {
    return HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }
}
