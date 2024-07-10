import 'package:flutter/material.dart';
import 'question_form.dart';

class TestListPage extends StatefulWidget {
  final int teacherId;

  TestListPage({required this.teacherId});

  @override
  _TestListPageState createState() => _TestListPageState();
}

class _TestListPageState extends State<TestListPage> with SingleTickerProviderStateMixin {
  late Future<List<Test>> _testsFuture;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    // Вместо fetchTests используем локальные данные (пустые данные)
    _testsFuture = Future.delayed(Duration(seconds: 2), () => []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          title: const Text('Список тестов'),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Обработка нажатия на кнопку "Раздел тестов"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TestCreationPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Цвет кнопки
              ),
              child: Text('+'),
            ),
          ],
        ),
      body: FutureBuilder<List<Test>>(
        future: _testsFuture,
        builder: (context, snapshot) {
          return _buildContent(snapshot);
        },
      ),
    );
  }

  Widget _buildContent(AsyncSnapshot<List<Test>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return _buildLoading();
    } else if (snapshot.hasError) {
      return _buildError(snapshot.error.toString());
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return _buildEmpty();
    } else {
      return _buildList(snapshot.data!);
    }
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildError(String error) {
    return Center(child: Text('Error: $error'));
  }

  Widget _buildEmpty() {
    return Center(child: Text('Нет доступных тестов'));
  }

  Widget _buildList(List<Test> tests) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: tests.length,
        itemBuilder: (context, index) {
          return _buildTestCard(tests[index], index);
        },
      ),
    );
  }

  Widget _buildTestCard(Test test, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = isSelected ? null : index;
        });
      },
      child: AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Card(
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          test.name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Ограничение по времени: ${test.timelimit} мин',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Создан: ${test.createdAt}',
                          style: TextStyle(fontSize: 14),
                        ),
                        if (isSelected) SizedBox(height: 10), // Добавить пространство перед кнопками, если карточка выбрана
                      ],
                    ),
                  ),
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Обработка редактирования
                        },
                        child: Text('Редактировать'),
                      ),
                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          // Обработка удаления
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Удалить'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Test {
  final int id;
  final int teacherId;
  final String name;
  final int timelimit;
  final String createdAt;

  Test({
    required this.id,
    required this.teacherId,
    required this.name,
    required this.timelimit,
    required this.createdAt,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['id'],
      teacherId: json['teacher_id'],
      name: json['name'],
      timelimit: json['timelimit'],
      createdAt: json['created_at'],
    );
  }
}
