import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:school/QuestionForm/QuestionForm.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:school/create_test_page/list_test_page.dart";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _profileImage = 'https://sun9-17.userapi.com/impg/Y6qMi35j6HE6HeZ6uS4HGsRe4pc5BYeXHy-h8g/m71YiHlpWH8.jpg?size=2560x1920&quality=95&sign=f64d0fb93c2676b015ab8d974b347515&type=album';

  int _currentQuestionIndex = 1;
  int _maxQuestionCount = -1;

  @override
  void initState() {
    super.initState();
    _updateMaxQuestionCount();
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _maxQuestionCount) {
        _currentQuestionIndex++;
      } else {
        _currentQuestionIndex = 1;
      }
    });
  }

  void _updateMaxQuestionCount() async {
    int count = await getQuestionCount();
    setState(() {
      _maxQuestionCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text('Репетитор английского языка'),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Обработка нажатия на кнопку "Раздел тестов"
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TestListPage(teacherId: 1)), // Предполагается, что у вас есть страница CreateTestPage
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Цвет кнопки
            ),
            child: Text('Раздел тестов'),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: _buildInfoCard(context),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildProfileImage(),
                    const SizedBox(height: 20),
                    _buildTextBlock(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTextSection(
            'Здравствуйте!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 10),
          _buildTextSection(
            'Меня зовут Ольга, и я — Ваш личный репетитор по английскому и немецкому языкам. '
                'Готовы открыть новые горизонты? '
                'Вместе мы достигнем ваших языковых целей, повышение уровня владения языком для работы или путешествий, '
                'или просто желание свободно и уверенно общаться на английском и немецком. '
                'Я помогу вам сделать учебу увлекательной и продуктивной. '
                'Присоединяйтесь ко мне в этом языковом путешествии, '
                'и вы скоро заметите, как легко и приятно овладевать новыми языками!',
            fontSize: 18,
          ),
          const SizedBox(height: 20),
          _buildTextSection(
            'Мои услуги:',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 10),
          _buildTextSection(
            '- Индивидуальные занятия Online\n- Индивидуальные занятия Offline в г. Самара\n',
            fontSize: 18,
          ),
          const SizedBox(height: 20),
          _buildTextSection(
            'Почему выбирают меня?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 10),
          _buildTextSection(
            '- Индивидуальный подход к каждому ученику\n- Опыт и квалификация\n- Доступность и гибкость\n- Дружелюбная атмосфера на занятиях',
            fontSize: 18,
          ),
          const SizedBox(height: 20),
          _buildTextSection(
            'Контакты:',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 10),
          _buildLinkSection(
            context,
            label: 'Телеграм: ',
            linkText: '@ichbinOlya',
            url: 'https://t.me/ichbinOlya',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        _profileImage,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTextBlock() {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchQuestion(_currentQuestionIndex),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          var currentQuestion = snapshot.data!;
          var type = currentQuestion['type'] as String?;
          var title = currentQuestion['title'] as String?;
          var description = currentQuestion['description'] as String?;
          var options = currentQuestion['options'] as List<dynamic>?;

          if (type == null || title == null || description == null ||
              options == null) {
            return const Center(child: Text('Invalid question data'));
          }

          // Преобразуем options в List<String>
          List<String> optionsList = options.cast<String>();

          return OptionWidgetFactory.createOptionWidget(
            type: type,
            // или другой тип, который нужен
            options: optionsList,
            title: title,
            description: description,
            buttonText: 'Ответить',
            onSubmit: _nextQuestion,
          );
        } else {
          return const Center(child: Text('No question found'));
        }
      },
    );
  }

  Widget _buildTextSection(
      String text, {
        TextStyle? style,
        double fontSize = 16,
        FontStyle? fontStyle,
      }) {
    return Text(
      text,
      style: style ??
          TextStyle(
            fontSize: fontSize,
            fontStyle: fontStyle,
          ),
    );
  }

  Widget _buildLinkSection(BuildContext context,
      {required String label, required String linkText, required String url}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 18, color: Colors.black),
        children: [
          TextSpan(text: label),
          TextSpan(
            text: linkText,
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _launchURL(url);
              },
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> fetchQuestion(int questionId) async {
    final String baseUrl = "http://localhost:8080/api/v1/school/survey/eng/1?question_id=${questionId}";

    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load survey');
      }
    } catch (e) {
      print('Error fetching question: $e');
      return {};
    }
  }

  Future<int> getQuestionCount() async {
    final String baseUrl = "http://localhost:8080/api/v1/school/survey/eng/1/count_questions";

    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body) as int;
      } else {
        throw Exception('Failed to load survey');
      }
    } catch (e) {
      print('Error fetching question: $e');
      return -1;
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
