import 'package:flutter/material.dart';
import 'package:school/dataclasses/subject.dart';

class SubjectPickerWidget extends StatelessWidget {
  final List<Subject> subjects;
  final String? selectedSubject;
  final ValueChanged<String?> onSubjectSelected;

  const SubjectPickerWidget({
    Key? key,
    required this.subjects,
    required this.selectedSubject,
    required this.onSubjectSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: "Выберите предмет"),
      value: _getSelectedValue(),
      items: _buildDropdownMenuItems(),
      onChanged: onSubjectSelected,
    );
  }

  /// Получение текущего значения для выпадающего списка.
  String? _getSelectedValue() {
    return subjects.firstOrNull?.name ?? selectedSubject;
  }

  /// Создание элементов для выпадающего списка.
  List<DropdownMenuItem<String>> _buildDropdownMenuItems() {
    return subjects.map((subject) {
      return DropdownMenuItem<String>(
        value: subject.name,
        child: Text("${subject.toString()}"),
      );
    }).toList();
  }
}
