import 'package:flutter/material.dart';

class WriteReviewScreen extends StatefulWidget {
  @override
  _WriteReviewScreenState createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      // Логика отправки отзыва
      final review = _reviewController.text.trim();
      // TODO: Отправка отзыва на сервер

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Отзыв отправлен!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Написать отзыв')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _reviewController,
                decoration: InputDecoration(labelText: 'Ваш отзыв'),
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите отзыв';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReview,
                child: Text('Отправить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
