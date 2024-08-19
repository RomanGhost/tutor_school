import 'package:flutter/material.dart';

class SubjectPickerWidget extends StatelessWidget {
  final List<String> subjects;
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
      decoration: const InputDecoration(labelText: 'Выберите предмет'),
      value: selectedSubject,
      items: subjects.map((subject) {
        return DropdownMenuItem<String>(
          value: subject,
          child: Text(subject),
        );
      }).toList(),
      onChanged: onSubjectSelected,
    );
  }
}