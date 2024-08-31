import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:school/dataclasses/review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/review_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _profileImageUrl =
      'https://sun9-17.userapi.com/impg/Y6qMi35j6HE6HeZ6uS4HGsRe4pc5BYeXHy-h8g/m71YiHlpWH8.jpg?size=2560x1920&quality=95&sign=f64d0fb93c2676b015ab8d974b347515&type=album';
  List<Review> _reviews = [];
  final ReviewApi _reviewApi = ReviewApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    List<Review> reviews = await _reviewApi.getAllReview();
    setState(() {
      _reviews = reviews;
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 60,
      title: const Text('Репетитор английского языка'),
      actions: [
        ElevatedButton(
          onPressed: _personalAccount,
          child: const Text('Личный кабинет'),
        ),
      ],
    );
  }

  void _personalAccount() async {
    Navigator.pushNamed(context, '/login');
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');

    if (jwt == null || JwtDecoder.isExpired(jwt)) {
      // Если нет токена или он истек, перенаправляем на страницу логина
      Navigator.pushNamed(context, '/login');
    } else {
      // Иначе перенаправляем на страницу аккаунта
      Navigator.pushNamed(context, '/account');
    }
  }

  Widget _buildBody() {
    return Container(
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
            Expanded(child: _buildInfoCard()),
            const SizedBox(width: 20),
            Expanded(child: _buildProfileAndReviews()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return _buildContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderText('Здравствуйте!', fontSize: 26),
          const SizedBox(height: 10),
          _buildBodyText(
            'Меня зовут Ольга, и я — Ваш личный репетитор по английскому и немецкому языкам. '
            'Готовы открыть новые горизонты? Вместе мы достигнем ваших языковых целей. '
            'Я помогу вам сделать учебу увлекательной и продуктивной. Присоединяйтесь ко мне в этом языковом путешествии!',
          ),
          const SizedBox(height: 20),
          _buildHeaderText('Мои услуги:'),
          const SizedBox(height: 10),
          _buildBodyText(
            '- Индивидуальные занятия Online\n- Индивидуальные занятия Offline в г. Самара\n',
          ),
          const SizedBox(height: 20),
          _buildHeaderText('Почему выбирают меня?'),
          const SizedBox(height: 10),
          _buildBodyText(
            '- Индивидуальный подход к каждому ученику\n'
            '- Опыт и квалификация\n'
            '- Доступность и гибкость\n'
            '- Дружелюбная атмосфера на занятиях',
          ),
          const SizedBox(height: 20),
          _buildHeaderText('Контакты:'),
          const SizedBox(height: 10),
          _buildLinkSection(
              label: 'Телеграм: ',
              linkText: '@ichbinOlya',
              url: 'https://t.me/ichbinOlya'),
        ],
      ),
    );
  }

  Widget _buildProfileAndReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildProfileImage(),
        const SizedBox(height: 20),
        _buildPracticingBlock(),
        const SizedBox(height: 20),
        _buildReviewSection(),
      ],
    );
  }

  Widget _buildProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        _profileImageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildReviewSection() {
    return _buildContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeaderText('Отзывы:'),
              IconButton(
                onPressed: _handleWriteReview,
                icon: Icon(Icons.add, color: Colors.blue.shade800),
              ),
            ],
          ),
          const SizedBox(height: 10), // Отступ между заголовком и первым отзывом
          SizedBox(
            height: 300, // Задаем фиксированную высоту для секции с отзывами
            child: ListView.builder(
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15), // Промежуток между отзывами
                  child: _buildReview(review: _reviews[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildReview({
    required Review review,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          review.userData,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < review.rate ? Icons.star : Icons.star_border,
              color: Colors.yellow,
            );
          }),
        ),
        const SizedBox(height: 5),
        Text(
          review.text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildPracticingBlock() {
    return _buildContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderText('Записаться на первый урок'),
          const SizedBox(height: 10),
          _buildDiscountText(),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/signup',
              arguments:
                  '/enroll_subject', // Передаем аргумент, что после регистрации нужно перейти на экран выбора предмета
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
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

  Widget _buildDiscountText() {
    return const Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: 'Первый урок со скидкой ', style: TextStyle(fontSize: 16)),
          TextSpan(
              text: '40% ',
              style: TextStyle(fontSize: 22, color: Colors.redAccent)),
          TextSpan(
              text: " 300 руб.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextSpan(
            text: "500 руб.",
            style: TextStyle(
              fontSize: 16,
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.red,
              decorationThickness: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSection(String text, {TextStyle? style}) {
    return Text(
      text,
      style: style ?? const TextStyle(fontSize: 16),
    );
  }

  Widget _buildHeaderText(String text, {double fontSize = 22}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade800,
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18),
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
            recognizer: TapGestureRecognizer()..onTap = () => _launchURL(url),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Future<void> _handleWriteReview() async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');

    if (jwt == null || JwtDecoder.isExpired(jwt)) {
      // Если нет токена или он истек, перенаправляем на страницу логина
      Navigator.pushNamed(context, '/login', arguments: '/write_review');
    } else {
      // Иначе перенаправляем на страницу написания отзыва
      Navigator.pushNamed(context, '/write_review');
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Не удалось открыть ссылку $url';
    }
  }
}
