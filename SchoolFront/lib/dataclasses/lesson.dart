// Модель данных для уроков
import 'package:flutter/material.dart';

class Lesson {
  final String title;
  final DateTime time;
  final String status;

  Lesson({required this.title, required this.time, required this.status});

  @override
  String toString() {
    final String formattedTime = _formatTimeOfDay(time);
    return '$title в $formattedTime';
  }

  String _formatTimeOfDay(DateTime time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}