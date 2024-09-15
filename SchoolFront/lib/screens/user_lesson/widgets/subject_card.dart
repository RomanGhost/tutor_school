import 'package:flutter/material.dart';
import '../../../dataclasses/subject.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final bool isEnrolled; // Флаг для того, записан пользователь или нет
  final Function()? onCancel; // Изменённая функция, теперь она без параметров
  final Function()? onEnroll; // Функция для записи на предмет

  const SubjectCard({
    Key? key,
    required this.subject,
    this.isEnrolled = false, // По умолчанию false, если предмет не записан
    this.onCancel,
    this.onEnroll,
  }) : super(key: key);

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтвердите удаление'),
          content: Text(
              'Вы уверены, что хотите отменить запись на предмет "${subject.name}"? (Все будущие предметы удалятся)'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    ) ?? false;

    if (shouldDelete && onCancel != null) {
      onCancel!(); // Вызов onCancel без аргументов
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              subject.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Цена: ${subject.price}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            Text(
              'Уровень: ${subject.level ?? "Уровень не определен"}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            isEnrolled
                ? ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent[200],
                minimumSize: Size.zero,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              onPressed: () => _showDeleteConfirmationDialog(context),
              icon: const Icon(
                Icons.cancel,
                size: 17,
                color: Colors.white,
              ),
              label: const Text(
                'Отменить',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            )
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6498E4),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              onPressed: onEnroll, // Используем onEnroll для записи
              child: const Text(
                'Записаться',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
