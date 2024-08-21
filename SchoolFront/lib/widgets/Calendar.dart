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
  final LessonApi _lessonApi = LessonApi();

  @override
  void initState() {
    super.initState();
    _initializeLessons();
  }

  void _initializeLessons() async {
    try {
      final List<Lesson> lessons = await _lessonApi.getLessons();
      final Map<DateTime, List<Lesson>> resultLessons = {};

      for (var lesson in lessons) {
        final DateTime date = DateTime.utc(lesson.time.year, lesson.time.month, lesson.time.day);
        if (resultLessons.containsKey(date)) {
          resultLessons[date]!.add(lesson);
        } else {
          resultLessons[date] = [lesson];
        }
      }

      _lessonsNotifier.value = resultLessons;
    } catch (e) {
      // Handle any errors
      print('Failed to initialize lessons: $e');
    }
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

  void _deleteLesson(DateTime day, int lessonId) {
    final lessons = _lessonsNotifier.value[day];
    if (lessons != null) {
      final lessonIndex = lessons.indexWhere((l) => l.id == lessonId);
      if (lessonIndex != -1) {
        setState(() {
          lessons.removeAt(lessonIndex);
          if (lessons.isEmpty) {
            _lessonsNotifier.value.remove(day);
          }
          _lessonsNotifier.value = Map.from(_lessonsNotifier.value); // Notify listeners
        });
      }
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
    });
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

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
  }
}
