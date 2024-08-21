package com.open_inc.SchoolBack.controllers

import com.open_inc.SchoolBack.configs.JWTUtil
import com.open_inc.SchoolBack.dataclasses.LessonData
import com.open_inc.SchoolBack.models.Lesson
import com.open_inc.SchoolBack.services.*
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@CrossOrigin
@RequestMapping("/api/lesson")
class LessonController (
    private val lessonService: LessonService,
    private val subjectService: SubjectService,
    private val userService: UserService,
    private val userSubjectService: UserSubjectService,
    private val statusService: StatusService,
    private val jwtUtil: JWTUtil,
){
    @GetMapping("/get")
    fun getLessons(@RequestHeader("Authorization") token: String): ResponseEntity<MutableList<LessonData>> {
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)

        val lessons = lessonService.getLessonsByEmail(userEmail)
        val returnLessons:MutableList<LessonData> = mutableListOf()
        for(lesson in lessons){
            val returnLesson = LessonData(
                id = lesson.id,
                subject=lesson.userSubject.subject.name,
                plainDateTime = lesson.plainDateTime!!,
                status = lesson.status.name!!,
            )
            returnLessons.add(returnLesson)
        }
//        val res = ResponseEntity.ok(returnLessons)
        return ResponseEntity.ok(returnLessons)
    }

    @PostMapping("/add")
    fun addLesson(@RequestHeader("Authorization") token: String, @RequestBody lesson: LessonData): ResponseEntity<LessonData> {
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)
        val user = userService.findUserByEmail(userEmail)

        val subject = subjectService.getSubjectByName(lesson.subject)
        //TODO "Сделать обработку ошибки с предметом"
        val userSubject = userSubjectService.getUserSubjectByUserAndSubject(user!!, subject)

        val status = statusService.getStatusByName(lesson.status)

        val newLesson = Lesson(userSubject=userSubject, status=status, plainDateTime = lesson.plainDateTime)
//        println(returnLesson)

        val returnLesson = lessonService.addLesson(newLesson)

        val returnLessonData = LessonData(
            id=returnLesson.id,
            subject=newLesson.userSubject.subject.name,
            plainDateTime = newLesson.plainDateTime!!,
            status = newLesson.status.name!!,
        )

        return ResponseEntity.ok(returnLessonData)
    }

    @DeleteMapping("/remove")
    fun removeLesson(@RequestHeader("Authorization") token: String, @RequestParam lessonId: Int): ResponseEntity<Void> {
        val result = lessonService.deleteLessonById(lessonId)
        return if (result) {
            ResponseEntity.ok().build()
        } else {
            ResponseEntity.notFound().build()
        }
    }

}