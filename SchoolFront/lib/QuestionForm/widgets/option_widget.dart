import 'package:flutter/material.dart';

abstract class OptionWidget extends StatelessWidget {
  String title;
  String description;
  String buttonText;
  Function() onSubmit;

  OptionWidget({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onSubmit,
  });
}
