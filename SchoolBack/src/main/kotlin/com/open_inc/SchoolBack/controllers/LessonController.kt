package com.open_inc.SchoolBack.controllers

import com.open_inc.SchoolBack.configs.JWTUtil
import com.open_inc.SchoolBack.dataclasses.LessonData
import com.open_inc.SchoolBack.models.Lesson
import com.open_inc.SchoolBack.services.*
import org.springframework.http.HttpHeaders
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
                subject=lesson.userSubject.subject.name,
                plainDateTime = lesson.plainDateTime!!,
                status = lesson.status.name!!,
            )
            returnLessons.add(returnLesson)
        }
        val res = ResponseEntity.ok(returnLessons)
        println(res)
        return ResponseEntity.ok(returnLessons)
    }

    @PostMapping("/add")
    fun addLesson(@RequestHeader("Authorization") token: String, @RequestBody lesson: LessonData): ResponseEntity<LessonData> {
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)
        val user = userService.findUserByEmail(userEmail)

        val subject = subjectService.getSubjectByName(lesson.subject)

        val userSubject = userSubjectService.getUserSubjectByUserAndSubject(user!!, subject)

        val status = statusService.getStatusByName(lesson.status)

        val newLesson = Lesson(userSubject=userSubject, status=status)
        lessonService.addLesson(newLesson)
//        println(returnLesson)

        val returnLesson = LessonData(
            subject=newLesson.userSubject.subject.name,
            plainDateTime = newLesson.plainDateTime!!,
            status = newLesson.status.name!!,
        )
        return ResponseEntity.ok(returnLesson)
    }
}