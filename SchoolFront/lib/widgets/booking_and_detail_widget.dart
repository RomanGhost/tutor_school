import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../dataclasses/lesson.dart';
import 'subject_picker_widget.dart';

class BookingAndDetailWidget extends StatefulWidget {
  final DateTime day;
  final ValueNotifier<Map<DateTime, List<Lesson>>> lessonsNotifier;
  final ValueChanged<Lesson> onSave;
  final ValueChanged<int> onDelete;
  final bool allowAdding;

  const BookingAndDetailWidget({
    Key? key,
    required this.day,
    required this.lessonsNotifier,
    required this.onSave,
    required this.onDelete,
    required this.allowAdding,
  }) : super(key: key);

  @override
  _BookingAndDetailWidgetState createState() => _BookingAndDetailWidgetState();
}

class _BookingAndDetailWidgetState extends State<BookingAndDetailWidget> {
  final List<String> _availableSubjects = [
    'Математика',
    'Физика',
    'Химия',
    'Биология',
    'История',
    'География',
    'Английский язык',
    'Русский язык',
    'Литература',
  ];

  String? _selectedSubject;
  TimeOfDay? _selectedTime;

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
            "Уроки на ${_formatDate(widget.day)}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<Map<DateTime, List<Lesson>>>(
            valueListenable: widget.lessonsNotifier,
            builder: (context, lessonsMap, _) {
              final lessons = lessonsMap[widget.day] ?? [];
              return Column(
                children: lessons.asMap().entries.map((entry) {
                  final index = entry.key;
                  final lesson = entry.value;
                  return _buildLessonCard(index, lesson);
                }).toList(),
              );
            },
          ),
          if (widget.allowAdding) _buildLessonForm(),
        ],
      ),
    );
  }

  Widget _buildLessonCard(int index, Lesson lesson) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Row(
          children: [
            Text(
              '${lesson.status}: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(lesson.status),
              ),
            ),
            Expanded(
              child: Text(
                lesson.toString(),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        trailing: _buildDeleteButton(index, widget.day),
      ),
    );
  }

  IconButton? _buildDeleteButton(int index, DateTime day) {
    final isPast = day.isBefore(DateTime.now()) && !isSameDay(day, DateTime.now());
    return isPast
        ? null
        : IconButton(
      icon: const Icon(Icons.delete, color: Colors.black87),
      onPressed: () {
        widget.onDelete(index);
        setState(() {});
      },
    );
  }

  Widget _buildLessonForm() {
    return Column(
      children: [
        const SizedBox(height: 16),
        SubjectPickerWidget(
          subjects: _availableSubjects,
          selectedSubject: _selectedSubject,
          onSubjectSelected: (subject) {
            setState(() {
              _selectedSubject = subject;
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                _selectedTime != null
                    ? "Время: ${_selectedTime!.format(context)}"
                    : "Выберите время",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () => _pickTime(context),
              child: const Text("Выбрать время"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _saveLesson,
          child: const Text("Добавить урок"),
        ),
      ],
    );
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
    if (_selectedSubject != null && _selectedTime != null) {
      // Convert _selectedTime (TimeOfDay) to DateTime
      final DateTime lessonDateTime = DateTime(
        widget.day.year,
        widget.day.month,
        widget.day.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final newLesson = Lesson(
        title: _selectedSubject!,
        time: lessonDateTime,  // Use the converted DateTime
        status: "Создан",
      );

      widget.onSave(newLesson);

      setState(() {
        _selectedSubject = null;
        _selectedTime = null;
      });
    }
  }


  Color _getStatusColor(String status) {
    switch (status) {
      case 'Проведен':
        return Colors.green;
      case 'Отменен':
        return Colors.red;
      case 'Создан':
      default:
        return Colors.orange;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}.${date.month}.${date.year}";
  }
}
