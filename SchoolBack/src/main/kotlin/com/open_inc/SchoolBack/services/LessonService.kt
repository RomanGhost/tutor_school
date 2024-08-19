package com.open_inc.SchoolBack.services

import com.open_inc.SchoolBack.models.Lesson
import com.open_inc.SchoolBack.repositories.LessonRepository
import org.springframework.stereotype.Service

@Service
class LessonService(
    private val lessonRepository: LessonRepository
) {
    fun addLesson(lesson: Lesson): Lesson {
        return lessonRepository.save(lesson)
    }

    fun getLessonsByEmail(email:String):List<Lesson>{
        return lessonRepository.findLessonByEmail(email)
    }
}