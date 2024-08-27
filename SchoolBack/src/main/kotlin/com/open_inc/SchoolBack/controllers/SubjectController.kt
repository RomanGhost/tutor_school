package com.open_inc.SchoolBack.controllers

import com.open_inc.SchoolBack.dataclasses.SubjectData
import com.open_inc.SchoolBack.services.SubjectService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@CrossOrigin
@RequestMapping("/api/subject")
class SubjectController(
    private val subjectService: SubjectService
) {

    @GetMapping("/getall")
    fun getAll() : ResponseEntity<MutableList<SubjectData>> {
        val subjects = subjectService.getAllSubjects()
        val returnSubjects = mutableListOf<SubjectData>()
        for (subject in subjects) {
            returnSubjects.add(
                SubjectData(
                    subject.id,
                    subject.name,
                    subject.price?:0f,
                    level = ""
                )
            )
        }
        return ResponseEntity.ok(returnSubjects)
    }
}