class Question{
  late String question='';
  late String description='';
  late String type='';
  late List<Map<String, dynamic>> options_answer=[];

  Question(String question,
    String? description,
    String? type,
    List<Map<String, dynamic>>? options_answer
  ){
    this.question = question??'';
    this.description = description??'';
    this.type = type??'';
    this.options_answer = options_answer??[];
  }

  Question.clone(Question questionObject):
        this(
          questionObject.question,
          questionObject.description,
          questionObject.type,
          new List<Map<String, dynamic>>.from(questionObject.options_answer));

  Map<String, dynamic> toJson(){
    Map<String, dynamic> dataOf = {
      "question": this.question,
      "type": this.type,
      "description": this.description,
      "options": this.options_answer
    };
    return dataOf;
  }

  void addOption(String option_text) {
    if (option_text.isNotEmpty) {
      for(Map<String, dynamic> option in options_answer){
        if(option['text'] == option_text)
          return;
      }
      options_answer.add({'text': option_text, 'isCorrect': false});
    }
  }

  void removeOption(int index) {
    options_answer.removeAt(index);
  }

  void removeAllOption() {
    options_answer.clear();
  }

  void toggleCorrectOption(int index, {String? answer_text}) {
    switch(this.type){
      case 'checkbox':
        options_answer[index]['isCorrect'] = !options_answer[index]['isCorrect'];
        break;
      case 'radio':
        for (var i = 0; i < options_answer.length; i++) {
          options_answer[i]['isCorrect'] = i == index;
        }
        break;
      case 'text':
        options_answer[index]['correct'] = answer_text;
        break;
      case 'multitext':
        options_answer[index]['correct'] = answer_text;
        break;
    }
  }
}