import 'package:flutter/material.dart';
import 'option_widget.dart';

class CheckboxOptions extends OptionWidget {
  final List<String> options;

  CheckboxOptions({
    required this.options,
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
    final Map<String, bool> _selectedOptions = {};

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
          ...options.map((option) => _buildCheckboxOption(option, _selectedOptions)).toList(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onSubmit,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption(String option, Map<String, bool> _selectedOptions) {
    return StatefulBuilder(
      builder: (context, setState) {
        return CheckboxListTile(
          title: Text(option),
          value: _selectedOptions[option] ?? false,
          onChanged: (value) {
            setState(() {
              _selectedOptions[option] = value!;
            });
          },
        );
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
}
