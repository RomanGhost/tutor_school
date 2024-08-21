package com.open_inc.SchoolBack.services

import com.open_inc.SchoolBack.models.Lesson
import com.open_inc.SchoolBack.repositories.LessonRepository
import org.springframework.stereotype.Service
import java.util.*

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

    fun getLessonById(id:Int): Lesson? {
        return lessonRepository.getReferenceById(id)
    }

    fun deleteLessonById(id:Int):Boolean {
        if (lessonRepository.existsById(id)) {
            lessonRepository.deleteById(id)
            return true
        }
        return false
    }
}
