import 'package:flutter/material.dart';
import 'package:school/screens/user_lesson/widgets/subject_card.dart';
import 'package:school/widgets/side_menu.dart'; // Импорт виджета бокового меню

import '../../api/subject_api.dart';
import '../../dataclasses/subject.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  List<Subject> subjects = [];
  SubjectApi subjectApi = SubjectApi();

  @override
  void initState() {
    super.initState();
    _initializeSubjects();
  }

  void _initializeSubjects() async {
    List<Subject> loadedSubjects = await subjectApi.getUserSubjects();
    setState(() {
      subjects = loadedSubjects;
    });
  }

  void _onCancel(int subjectId) {
    Subject delSubject = subjects.where((subject) => subject.id == subjectId).first;
    subjectApi.deleteUserSubject(delSubject);
    setState(() {
      subjects.remove(delSubject);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Запись на предмет с ID: $subjectId отменена')),
    );
  }

  Future<void> _onEnrollNew() async {
    Navigator.pushNamed(context, '/enroll_subject');
  }

  @override
Widget build(BuildContext context) {
  // Получаем ширину экрана
  final screenWidth = MediaQuery.of(context).size.width;

  // Устанавливаем количество колонок в зависимости от ширины экрана
  final crossAxisCount = screenWidth < 600 ? 2 : 4; // 2 колонки для мобильных устройств, 4 — для больших экранов

  return Scaffold(
    appBar: AppBar(
      title: const Text('Мои предметы'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _onEnrollNew,
        ),
      ],
    ),
    drawer: SideMenu(), // Добавление боковой панели
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: subjects.isEmpty
          ? Center(
              child: Text(
                'Нет записанных предметов',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount, // Используем динамическое количество колонок
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return SubjectCard(
                  subject: subject,
                  onCancel: _onCancel,
                );
              },
            ),
    ),
  );
}
}
