import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// Модель данных для уроков
class Lesson {
  final String title;
  final TimeOfDay time;

  Lesson({required this.title, required this.time});

  @override
  String toString() {
    final String formattedTime = _formatTimeOfDay(time);
    return '$title в $formattedTime';
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}

class LessonCalendarWidget extends StatefulWidget {
  @override
  _LessonCalendarWidgetState createState() => _LessonCalendarWidgetState();
}

class _LessonCalendarWidgetState extends State<LessonCalendarWidget> {
  final ValueNotifier<Map<DateTime, List<Lesson>>> _lessonsNotifier = ValueNotifier({});
  final ValueNotifier<DateTime> _selectedDayNotifier = ValueNotifier(DateTime.now());
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _lessonsNotifier.value = {
      DateTime.utc(2024, 8, 15): [Lesson(title: 'Математика', time: TimeOfDay(hour: 10, minute: 0))],
      DateTime.utc(2024, 8, 16): [Lesson(title: 'Физика', time: TimeOfDay(hour: 14, minute: 0))],
      DateTime.utc(2024, 8, 17): [Lesson(title: 'Химия', time: TimeOfDay(hour: 11, minute: 30))],
    };
  }

  List<Lesson> _getLessonsForDay(DateTime day) {
    return _lessonsNotifier.value[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDayNotifier.value = selectedDay;
    _focusedDay = focusedDay;
    _showBookingAndDetailWidget(selectedDay);
  }

  void _showBookingAndDetailWidget(DateTime day) {
    final allowAdding = day.isAfter(DateTime.now()) || isSameDay(day, DateTime.now());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BookingAndDetailWidget(
        day: day,
        lessonsNotifier: _lessonsNotifier,
        onSave: (Lesson lesson) => _addLesson(day, lesson),
        onDelete: (int index) => _deleteLesson(day, index),
        allowAdding: allowAdding,
      ),
    );
  }

  void _deleteLesson(DateTime day, int index) {
    final lessons = _lessonsNotifier.value[day];
    if (lessons != null && lessons.isNotEmpty) {
      lessons.removeAt(index);
      if (lessons.isEmpty) {
        _lessonsNotifier.value.remove(day);
      }
      _lessonsNotifier.notifyListeners();
    }
  }

  void _addLesson(DateTime day, Lesson lesson) {
    final lessons = _lessonsNotifier.value[day] ?? [];
    lessons.add(lesson);
    _lessonsNotifier.value[day] = lessons;
    _lessonsNotifier.notifyListeners();
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

class BookingAndDetailWidget extends StatefulWidget {
  final DateTime day;
  final ValueNotifier<Map<DateTime, List<Lesson>>> lessonsNotifier;
  final ValueChanged<Lesson> onSave;
  final ValueChanged<int> onDelete;
  final bool allowAdding;

  BookingAndDetailWidget({
    required this.day,
    required this.lessonsNotifier,
    required this.onSave,
    required this.onDelete,
    required this.allowAdding,
  });

  @override
  _BookingAndDetailWidgetState createState() => _BookingAndDetailWidgetState();
}

class _BookingAndDetailWidgetState extends State<BookingAndDetailWidget> {
  final TextEditingController _lessonController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _lessonController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveLesson() {
    if (_lessonController.text.isNotEmpty && _selectedTime != null) {
      widget.onSave(Lesson(
        title: _lessonController.text,
        time: _selectedTime!,
      ));
      _lessonController.clear();
      _selectedTime = null;
      // Обновление состояния виджета без закрытия модального окна
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Уроки на ${widget.day.toLocal()}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ValueListenableBuilder<Map<DateTime, List<Lesson>>>(
            valueListenable: widget.lessonsNotifier,
            builder: (context, lessonsMap, _) {
              final lessons = lessonsMap[widget.day] ?? [];
              return Column(
                children: lessons.asMap().entries.map(
                      (entry) {
                    final index = entry.key;
                    final lesson = entry.value;
                    return Card(
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          lesson.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.black87),
                          onPressed: () {
                            widget.onDelete(index);
                            // Обновление состояния виджета без закрытия модального окна
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                ).toList(),
              );
            },
          ),
          if (widget.allowAdding) _buildLessonForm(),
        ],
      ),
    );
  }

  Widget _buildLessonForm() {
    return Column(
      children: [
        SizedBox(height: 16),
        TextField(
          controller: _lessonController,
          decoration: InputDecoration(labelText: "Название урока"),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                _selectedTime != null
                    ? "Время: ${_selectedTime!.format(context)}"
                    : "Выберите время",
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () => _pickTime(context),
              child: Text("Выбрать время"),
            ),
          ],
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _saveLesson,
          child: Text("Добавить урок"),
        ),
      ],
    );
  }
}
