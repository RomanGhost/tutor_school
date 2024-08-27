import 'package:flutter/material.dart';
import 'package:school/widgets/side_menu.dart'; // Импорт виджета бокового меню
import 'package:school/screens/user_lesson/subject_card.dart';
import '../../dataclasses/subject.dart';
import 'enroll_new_subject_screen.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  late List<Subject> subjects;

  @override
  void initState() {
    super.initState();
    subjects = _initializeSubjects();
  }

  List<Subject> _initializeSubjects() {
    return [
      Subject(id: 1, name: 'Английский', price: 1505, level: 'B2'),
      Subject(id: 2, name: 'Немецкий', price: 1200, level: 'A1'),
    ];
  }

  void _onCancel(int subjectId) {
    setState(() {
      subjects.removeWhere((subject) => subject.id == subjectId);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои Предметы'),
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
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
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
