import 'package:flutter/material.dart';
import 'Calendar.dart';

class NextLessonWidget extends StatefulWidget {
  @override
  _NextLessonWidgetState createState() => _NextLessonWidgetState();
}

class _NextLessonWidgetState extends State<NextLessonWidget> {
  static const String datetime = '13:34 23.02';
  static const String goodText = "Хорошего дня😜";
  final lessonWidget = LessonCalendarWidget();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Color(0xFF6498E4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Выровнять текст по левому краю
          children: [
            _buildText("Следующий урок:", 24, Colors.white, FontWeight.w300),
            _buildText(datetime, 20, Colors.white, FontWeight.w300),
            _buildText(goodText, 22, Colors.white70, FontWeight.bold),
            ExpansionTile(
              title: _buildText("Показать календарь", 20, Colors.white, FontWeight.w200),
              children: [
                lessonWidget, // Встроенный виджет календаря
              ],
              tilePadding: EdgeInsets.zero, // Убираем отступы
              childrenPadding: EdgeInsets.zero, // Убираем отступы для контента внутри
              collapsedBackgroundColor: Colors.transparent, // Убираем фон у заголовка при свернутом состоянии
              backgroundColor: Colors.transparent, // Убираем фон у заголовка при раскрытом состоянии
              collapsedIconColor: Colors.white, // Цвет иконки в свернутом состоянии
              iconColor: Colors.white, // Цвет иконки в раскрытом состоянии
              // dividerColor: Colors.transparent, // Убираем линию
            ),
          ],
        ),
      ),
    );
  }

  Text _buildText(String text, double fontSize, Color color, FontWeight fontWeight) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight),
    );
  }
}
