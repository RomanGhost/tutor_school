import 'package:flutter/material.dart';
import 'option_widget.dart';

class MultiTextOptions extends OptionWidget {
  MultiTextOptions({
    required String title,
    required String description,
    required String buttonText,
    required Function() onSubmit,
  }) : super(
    title: title,
    description: description,
    buttonText: buttonText,
    onSubmit: onSubmit,
  );

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextSection(
            title,
            fontSize: 22,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildTextSection(
            description,
            fontSize: 18,
          ),
          const SizedBox(height: 10),
          _buildTextFieldSection("Вставь ответ здесь"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onSubmit,
            child: Text(buttonText),
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

  Widget _buildTextFieldSection(
      String labelText, {
        TextStyle? style,
        double fontSize = 16,
        FontStyle? fontStyle,
      }) {
    return TextField(
      style: style ??
          TextStyle(
            fontSize: fontSize,
            fontStyle: fontStyle,
          ),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
      ),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      minLines: 2,
    );
  }
}
