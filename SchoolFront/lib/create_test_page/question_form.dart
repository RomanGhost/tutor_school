import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school/create_test_page/question/question.dart';

class TestCreationPage extends StatefulWidget {
  @override
  _TestCreationPageState createState() => _TestCreationPageState();
}

class _TestCreationPageState extends State<TestCreationPage> {
  String testName = 'Название теста';
  List<Question> questions = [];
  Question question = new Question('', '', '', []);
  List<String> questionTypes = [];
  TextEditingController testNameController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController optionController = TextEditingController();
  TextEditingController textAnswerController = TextEditingController();
  String? selectedQuestionType;
  int? selectedQuestionIndex;

  @override
  void initState() {
    super.initState();
    fetchQuestionTypes();
  }

  Future<void> fetchQuestionTypes() async {
    const String url = "http://localhost:8080/api/v1/school/survey/question_options";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          questionTypes = data.map((item) => item['type'] as String).toList();
        });
      } else {
        print('Failed to load question types');
      }
    } catch (e) {
      print('Error fetching question types: $e');
    }
  }

  void prepareNewQuestion() {
    setState(() {
      questionController.clear();
      descriptionController.clear();
      textAnswerController.clear();
      selectedQuestionType = null;
      selectedQuestionIndex = null;
      question = new Question('', '', '', []);
    });
  }

  void addQuestion() {
    setState(() {
      if (questionController.text.isNotEmpty && selectedQuestionType != null) {
        setState(() {
          question.question = questionController.text;
          question.description = descriptionController.text;
          question.type = selectedQuestionType!;

          if(textAnswerController.text.isNotEmpty){
            question.removeAllOption();
            question.addOption(question.question);
            question.toggleCorrectOption(0, answer_text: textAnswerController.text);
          }

          if (selectedQuestionIndex == null) {
            questions.add(question);
          } else {
            questions[selectedQuestionIndex!] = question;
            selectedQuestionIndex = null;
          }
          prepareNewQuestion();
        });
      }
    });
  }

  void addOption() {
    if (optionController.text.isNotEmpty) {
      setState(() {
        question.addOption(optionController.text);
        optionController.clear();
      });
    }
  }

  void removeOption(int index) {
    setState(() {
      question.removeOption(index);
    });
  }

  void selectQuestion(int index) {
    print(questions[index].toJson());
    setState(() {
      selectedQuestionIndex = index;
      questionController.text = questions[index].question;
      descriptionController.text = questions[index].description;
      selectedQuestionType = questions[index].type;
      textAnswerController.text = questions[index].options_answer[0]['correct'] ?? '';
      this.question = questions[index];
    });
  }

  void reorderQuestions(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = questions.removeAt(oldIndex);
      questions.insert(newIndex, item);
    });
  }

  void removeQuestion(int index) {
    setState(() {
      questions.removeAt(index);
    });
  }

  Future<void> sendTest() async {
    const String baseUrl = "http://localhost:8080/api/v1/school/survey/create_test";
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'test_name': testName,
          'questions': questions,
        }),
      );
      if (response.statusCode == 200) {
        print('Test saved successfully');
      } else {
        print('Failed to save the test');
      }
    } catch (e) {
      print('Error saving test: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создание Вопроса'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Row(
        children: [
          buildQuestionList(),
          buildQuestionForm(),
        ],
      ),
    );
  }

  Widget buildQuestionList() {
    return Container(
      width: 250,
      color: Colors.blueGrey[50],
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: TextField(
              controller: testNameController,
              decoration: InputDecoration(
                hintText: testName,
                hintStyle: TextStyle(color: Colors.white, fontSize: 24),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white, fontSize: 24),
              onChanged: (value) => setState(() => testName = value),
            ),
          ),
          Expanded(
            child: ReorderableListView(
              onReorder: reorderQuestions,
              children: List.generate(questions.length, (index) {
                return ListTile(
                  key: ValueKey('question_$index'),
                  title: Text(questions[index].question),
                  onTap: () => selectQuestion(index),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => removeQuestion(index),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: sendTest,
              child: Text('Сохранить тест'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuestionForm() {
    question.type = selectedQuestionType??"";
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            buildTextField(controller: questionController, label: 'Вопрос'),
            buildTextField(controller: descriptionController, label: 'Описание'),
            buildQuestionTypeDropdown(),
            if (selectedQuestionType == 'checkbox' || selectedQuestionType == 'radio')
              Column(
                children: [
                  buildTextField(
                      controller: optionController,
                      label: 'Добавить вариант ответа',
                      onSubmitted: addOption,
                  ),
                  ElevatedButton(onPressed: addOption, child: Text('Добавить вариант')),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: question.options_answer.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(question.options_answer[index]['text']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (selectedQuestionType == 'checkbox')
                              Checkbox(
                                value: question.options_answer[index]['isCorrect'] as bool,
                                onChanged: (bool? value) {
                                  setState(() {
                                    question.toggleCorrectOption(index);
                                  });
                                },
                              ),
                            if (selectedQuestionType == 'radio')
                              Radio<bool>(
                                value: question.options_answer[index]['isCorrect'] as bool,
                                groupValue: true,
                                onChanged: (bool? value) {
                                  setState(() {
                                    question.toggleCorrectOption(index);
                                  });
                                },
                              ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => removeOption(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            if (selectedQuestionType == 'text')
              buildTextField(controller: textAnswerController, label: 'Введите ответ'),
            if (selectedQuestionType == 'multitext')
              buildMultiTextField(controller: textAnswerController, label: 'Введите абзацы ответа'),
            ElevatedButton(onPressed: addQuestion, child: Text('Создать вопрос')),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({required TextEditingController controller, required String label, Function? onSubmitted}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      onChanged: (value) => setState(() {}),
      onSubmitted: (value) => setState(() {onSubmitted!();}),
    );
  }

  Widget buildMultiTextField({required TextEditingController controller, required String label}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      maxLines: null,
      keyboardType: TextInputType.multiline,
      onChanged: (value) => setState(() {}),
    );
  }

  Widget buildQuestionTypeDropdown() {
    return DropdownButton<String>(
      value: selectedQuestionType,
      hint: Text('Выберите тип вопроса'),
      onChanged: (String? newValue) {
        setState(() {
          selectedQuestionType = newValue;
        });
      },
      items: questionTypes.map<DropdownMenuItem<String>>((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
    );
  }
}
