import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:school/dataclasses/review.dart';

import 'home_screen_helpers.dart';

// Виджет для карточки информации
Widget buildInfoCard() {
  return buildContainer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeaderText('Здравствуйте!', fontSize: 26),
        const SizedBox(height: 10),
        buildBodyText(
          'Меня зовут Ольга, и я — Ваш личный репетитор по английскому и немецкому языкам. '
              'Готовы открыть новые горизонты? Вместе мы достигнем ваших языковых целей. '
              'Я помогу вам сделать учебу увлекательной и продуктивной. Присоединяйтесь ко мне в этом языковом путешествии!',
        ),
        const SizedBox(height: 20),
        buildHeaderText('Мои услуги:'),
        const SizedBox(height: 10),
        buildBodyText(
          '- Индивидуальные занятия Online\n- Индивидуальные занятия Offline в г. Самара\n',
        ),
        const SizedBox(height: 20),
        buildHeaderText('Почему выбирают меня?'),
        const SizedBox(height: 10),
        buildBodyText(
          '- Индивидуальный подход к каждому ученику\n'
              '- Опыт и квалификация\n'
              '- Доступность и гибкость\n'
              '- Дружелюбная атмосфера на занятиях',
        ),
        const SizedBox(height: 20),
        buildHeaderText('Контакты:'),
        const SizedBox(height: 10),
        buildLinkSection(
          label: 'Телеграм: ',
          linkText: '@ichbinOlya',
          url: 'https://t.me/ichbinOlya',
        ),
      ],
    ),
  );
}

// Виджет для профиля и отзывов
Widget buildProfileAndReviews(BuildContext context, String profileImageUrl, List<Review> reviews) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      buildProfileImage(profileImageUrl),
      const SizedBox(height: 20),
      buildPracticingBlock(context),
      const SizedBox(height: 20),
      buildReviewSection(context, reviews),
    ],
  );
}

// Виджет изображения профиля
Widget buildProfileImage(String url) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: Image.network(
      url,
      fit: BoxFit.cover,
    ),
  );
}

// Виджет для блока записи на урок
Widget buildPracticingBlock(BuildContext context) {
  return buildContainer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeaderText('Записаться на первый урок'),
        const SizedBox(height: 10),
        buildDiscountText(),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(
            context,
            '/signup',
            arguments: '/enroll_subject',
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

// Виджет для отображения скидки
Widget buildDiscountText() {
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

// Виджет для отображения текста
Widget buildTextSection(String text, {TextStyle? style}) {
  return Text(
    text,
    style: style ?? const TextStyle(fontSize: 16),
  );
}

// Виджет для заголовка
Widget buildHeaderText(String text, {double fontSize = 22}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: Colors.blue.shade800,
    ),
  );
}

// Виджет для текста основного контента
Widget buildBodyText(String text) {
  return Text(
    text,
    style: const TextStyle(fontSize: 18),
  );
}

// Виджет для отображения ссылки
Widget buildLinkSection({
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
          recognizer: TapGestureRecognizer()..onTap = () => launchURL(url),
        ),
      ],
    ),
  );
}

// Контейнер с тенью
Widget buildContainer({required Widget child}) {
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

// Виджет для секции отзывов

// Виджет для секции отзывов
Widget buildReviewSection(BuildContext context, List<Review> reviews) {
  return buildContainer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildHeaderText('Отзывы:'),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/login', arguments: '/write_review'),
              icon: Icon(Icons.add, color: Colors.blue.shade800),
            ),
          ],
        ),
        const SizedBox(height: 10), // Отступ между заголовком и первым отзывом
        SizedBox(
          height: 300, // Установите высоту по вашему усмотрению
          child: SingleChildScrollView(
            child: Column(
              children: reviews.map((review) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15), // Промежуток между отзывами
                  child: _buildReview(review: review),
                );
              }).toList(),
            ),
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
