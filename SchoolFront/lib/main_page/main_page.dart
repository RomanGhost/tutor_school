import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:school/auth/login_screen.dart';
import "package:url_launcher/url_launcher.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _profileImage = 'https://sun9-17.userapi.com/impg/Y6qMi35j6HE6HeZ6uS4HGsRe4pc5BYeXHy-h8g/m71YiHlpWH8.jpg?size=2560x1920&quality=95&sign=f64d0fb93c2676b015ab8d974b347515&type=album';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text('Репетитор английского языка'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: const Text('Личный кабинет'),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInfoCard(),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildProfileImage(),
                    const SizedBox(height: 20),
                    _buildPracticingBlock(),
                    const SizedBox(height: 20),
                    _buildReviewSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return _buildContainer(
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

  Widget _buildReviewSection() {
    return _buildContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Отзыв:',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Роман Романович',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < 5 ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                    );
                  }),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Отличный преподаватель! Занятия проходят интересно и продуктивно. Очень доволен результатом.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Иван Иванов',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < 4 ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                    );
                  }),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Отличный преподаватель! Занятия проходят интересно и продуктивно. Очень доволен результатом.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Олег Олегович',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < 2 ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                    );
                  }),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Отличный преподаватель! Занятия проходят интересно и продуктивно. Очень доволен результатом.',
                  style: TextStyle(fontSize: 16),
                ),
              ]
          )
        ],
      ),
    );
  }

  Widget _buildPracticingBlock() {
    return _buildContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Записаться на первый урок',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 10),
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Перый урок со скидкой ',
                  style: TextStyle(fontSize: 16),
                ),
                TextSpan(
                  text: '40% ',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text: "500 руб.",
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.red,
                    decorationThickness: 2,
                  ),
                ),
                TextSpan(
                  text: " 300 руб. ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlaceholderWidget()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Цвет кнопки
            ),
            child: const Text(
              'Записаться',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildLinkSection({
    required String label,
    required String linkText,
    required String url,
  }) {
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

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildContainer({required Widget child}) {
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
      child: child,
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  const PlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заглушка')),
      body: const Center(child: Text('Заглушка')),
    );
  }
}
