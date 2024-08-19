package com.open_inc.SchoolBack.repositories

import com.open_inc.SchoolBack.models.Lesson
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository

@Repository
interface LessonRepository: JpaRepository<Lesson, Int>{
    @Query("select l from Lesson l join UserSubject usub on usub = l.userSubject join User u on u = usub.user where u.email = :email" )
    fun findLessonByEmail(email:String):List<Lesson>
}