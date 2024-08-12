import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NextLessonWidget extends StatefulWidget{
  @override
  _NextLessonWidget createState() => _NextLessonWidget();
}

class _NextLessonWidget extends State<NextLessonWidget> {
  static const String datetime = '13:34 23.02';
  static const String goodText = "Хорошего дня😜";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Card(
        elevation: 2,
        color: Colors.blueAccent,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Следующий урок:",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 24,
                ),
              ),
              Text(
                datetime,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              ),
              Text(
                goodText,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}