package com.open_inc.SchoolBack.controllers

import com.open_inc.SchoolBack.models.*
import com.open_inc.SchoolBack.services.QuestionTypeService
import jakarta.websocket.server.PathParam
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@CrossOrigin(maxAge = 9600)
@RestController
@RequestMapping("/api/v1/school/survey")
class Survey(
    private val questionTypeService: QuestionTypeService
) {
    private val questionsEng:Map<Long, MockQuestion> = mapOf(
        Pair(1L, MockQuestion(1, 1, "checkbox", "Question1", "Choose an answer", arrayListOf("answer1", "answer2", "answer3"))),
        Pair(2L, MockQuestion(2, 1,"radio", "Question2", "Choose an answer", arrayListOf("answer1", "answer2", "answer3"))),
        Pair(3L, MockQuestion(2, 1, "text", "Question3", "Choose an answer", arrayListOf())),
        Pair(4L, MockQuestion(2, 1, "multitext", "Question4", "Choose an answer", arrayListOf()))
    )

    @GetMapping("/{subjectName}/{testId}")
    fun getTestQuestions(@RequestParam("question_id") questionId:Long,
                         @PathVariable subjectName:String,
                         @PathVariable testId:Long
    ):ResponseEntity<MockQuestion>{
        println("Send json")
        if (subjectName.trim().lowercase() == "eng")
            return ResponseEntity(questionsEng[questionId], HttpStatus.OK)
        return ResponseEntity(HttpStatus.NOT_FOUND)
    }

    @GetMapping("/{subjectName}/{testId}/count_questions")
    fun getCountTestQuestions(
        @PathVariable subjectName:String,
        @PathVariable testId:Long
    ):ResponseEntity<Int>{
        println("Send size")
        if (subjectName.trim().lowercase() == "eng")
            return ResponseEntity(questionsEng.size, HttpStatus.OK)
        return ResponseEntity(HttpStatus.NOT_FOUND)
    }

    @PostMapping("/create_test")
    fun createSurvey(@RequestBody jsonObject:Map<String, Any>){
        val subject: Subject = Subject(name="English")
        val level  = Level(name="b2")
        val user:User = User(lastName = "", firstName = "", surname = "", level = level, password = "", email="")
        val newTeacher = TeacherProfile(user=user, subject = subject)
        val newTest:Test = Test(teacher = newTeacher, timeLimit = 0, name= jsonObject["name"].toString())

        for(questionMap in jsonObject["questions"] as List<Map<String, Any>>) {
            val newQuestion: Question = Question(
                test = newTest,
                questionType = QuestionType(type = questionMap["type"].toString()),
                title = questionMap["question"].toString(),
                description = questionMap["description"].toString(),
                options = questionMap["options"] as ArrayList<Map<String, Any>>
            )
            println(newQuestion)
        }
    }

    @GetMapping("/question_options")
    fun getQuestionOptions(): ResponseEntity<List<QuestionType>> {
        return ResponseEntity(questionTypeService.getAllQuestionTypes(), HttpStatus.OK)
    }
}