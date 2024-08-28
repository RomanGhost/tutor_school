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

  /// Инициализация уроков, получение данных с API и обновление уведомлений.
  void _initializeLessons() async {
    try {
      final lessons = await _lessonApi.getLessons();
      _lessonsNotifier.value = _groupLessonsByDate(lessons);
    } catch (e) {
      // Обработка ошибок
      print('Failed to initialize lessons: $e');
    }
  }

  /// Группировка уроков по датам.
  Map<DateTime, List<Lesson>> _groupLessonsByDate(List<Lesson> lessons) {
    final resultLessons = <DateTime, List<Lesson>>{};
    for (var lesson in lessons) {
      final date = DateTime.utc(lesson.time.year, lesson.time.month, lesson.time.day);
      resultLessons[date] = (resultLessons[date] ?? [])..add(lesson);
    }
    return resultLessons;
  }

  /// Получение уроков для определенного дня.
  List<Lesson> _getLessonsForDay(DateTime day) => _lessonsNotifier.value[day] ?? [];

  /// Обработка выбора дня в календаре.
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDayNotifier.value = selectedDay;
    setState(() {
      _focusedDay = focusedDay;
    });
    _showBookingAndDetailWidget(selectedDay);
  }

  /// Отображение модального окна с деталями и возможностью бронирования.
  void _showBookingAndDetailWidget(DateTime day) {
    final allowAdding = day.isAfter(DateTime.now()) || _isSameDay(day, DateTime.now());
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

  /// Удаление урока.
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
          _lessonsNotifier.value = Map.from(_lessonsNotifier.value); // Уведомление слушателей
        });
      }
    }
  }

  /// Добавление нового урока.
  void _addLesson(DateTime day, Lesson lesson) {
    final lessons = _lessonsNotifier.value[day] ?? [];
    lessons.add(lesson);
    _lessonsNotifier.value = {
      ..._lessonsNotifier.value,
      day: lessons,
    };
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
            return _buildCalendar(selectedDay);
          },
        );
      },
    );
  }

  /// Создание виджета календаря.
  Widget _buildCalendar(DateTime selectedDay) {
    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2024, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => _isSameDay(selectedDay, day),
      onDaySelected: _onDaySelected,
      eventLoader: _getLessonsForDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: _buildCalendarStyle(),
      headerStyle: _buildHeaderStyle(),
    );
  }

  /// Стиль календаря.
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

  /// Стиль заголовка календаря.
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

  /// Проверка на одинаковый день.
  bool _isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
  }
}
