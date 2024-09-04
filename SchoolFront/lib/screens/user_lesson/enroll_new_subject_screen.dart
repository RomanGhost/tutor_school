import 'package:flutter/material.dart';
import 'package:school/api/subject_api.dart';

import '../../dataclasses/subject.dart';

class EnrollNewSubjectScreen extends StatefulWidget {
  @override
  _EnrollNewSubjectScreenState createState() => _EnrollNewSubjectScreenState();
}

class _EnrollNewSubjectScreenState extends State<EnrollNewSubjectScreen> {
  List<Subject> availableSubjects = [];
  SubjectApi subjectApi = SubjectApi();
  final crossAxisCount = screenWidth < 600 ? 2 : 4;

  @override
  void initState() {
    super.initState();
    // Инициализация списка доступных предметов
    _initialize();
  }

  void _initialize() async {
    List<Subject> loadedSubjects = await subjectApi.getAvailableSubjects();
    setState(() {
      availableSubjects = loadedSubjects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Запись'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 3 / 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: availableSubjects.length,
          itemBuilder: (context, index) {
            final subject = availableSubjects[index];
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Цена: ${subject.price}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildLevelDropdown(subject),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6498E4),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      ),
                      onPressed: () {
                        subjectApi.addSubjectUser(subject);
                        Navigator.pushNamed(context, '/user_lesson');
                      },
                      child: const Text('Записаться',
                      style: TextStyle(
                        color: Colors.white
                      ),),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLevelDropdown(Subject subject) {
    return Container(
      width: 120, // Задаем фиксированную ширину для выпадающего списка
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          labelText: 'Уровень',
          labelStyle: TextStyle(fontSize: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        style: TextStyle(fontSize: 12), // Размер шрифта внутри выпадающего списка
        items: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
            .map((level) => DropdownMenuItem<String>(
          value: level,
          child: Text(level),
        ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              subject.level = value;
            });
          }
        },
      ),
    );
  }
}
