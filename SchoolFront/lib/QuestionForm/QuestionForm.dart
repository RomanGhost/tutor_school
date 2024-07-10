import 'package:school/QuestionForm/widgets/check_boxes.dart';
import 'package:school/QuestionForm/widgets/multi_text_field.dart';
import 'package:school/QuestionForm/widgets/option_widget.dart';
import 'package:school/QuestionForm/widgets/radio_buttons.dart';
import 'package:school/QuestionForm/widgets/text_field.dart';

class OptionWidgetFactory {
  static OptionWidget createOptionWidget({
    required String type,
    List<String>? options,
    required String title,
    required String description,
    required String buttonText,
    required Function() onSubmit,
  }) {
    switch (type) {
      case 'checkbox':
        return CheckboxOptions(
          options: options!,
          title: title,
          description: description,
          buttonText: buttonText,
          onSubmit: onSubmit,
        );
      case 'radio':
        return RadioOptions(
          options: options!,
          title: title,
          description: description,
          buttonText: buttonText,
          onSubmit: onSubmit,
        );
      case 'text':
        return TextOptions(
          title: title,
          description: description,
          buttonText: buttonText,
          onSubmit: onSubmit,
        );
      case 'multitext':
        return MultiTextOptions(
          title: title,
          description: description,
          buttonText: buttonText,
          onSubmit: onSubmit,
        );
      default:
        throw Exception('Unknown widget type: $type');
    }
  }

  // static OptionWidget createEditOptionWidget({
  //   required String type,
  //   List<String>? options,
  //   required String title,
  //   required String description,
  //   required String buttonText,
  //   required Function() onSubmit,
  // }) {
  //   switch (type) {
  //     case 'checkbox':
  //       return CheckboxOptions(
  //         options: options!,
  //         title: title,
  //         description: description,
  //         buttonText: buttonText,
  //         onSubmit: onSubmit,
  //       );
  //     case 'radio':
  //       return RadioOptions(
  //         options: options!,
  //         title: title,
  //         description: description,
  //         buttonText: buttonText,
  //         onSubmit: onSubmit,
  //       );
  //     case 'text':
  //       return TextOptions(
  //         title: title,
  //         description: description,
  //         buttonText: buttonText,
  //         onSubmit: onSubmit,
  //       );
  //     case 'multitext':
  //       return MultiTextOptions(
  //         title: title,
  //         description: description,
  //         buttonText: buttonText,
  //         onSubmit: onSubmit,
  //       );
  //     default:
  //       throw Exception('Unknown widget type: $type');
  //   }
  // }
}
