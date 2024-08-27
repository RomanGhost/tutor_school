package com.open_inc.SchoolBack.controllers

import com.open_inc.SchoolBack.configs.JWTUtil
import com.open_inc.SchoolBack.configs.MyUserDetails
import com.open_inc.SchoolBack.dataclasses.SubjectData
import com.open_inc.SchoolBack.models.UserSubject
import com.open_inc.SchoolBack.services.*
import org.springframework.web.bind.annotation.*

@RestController
@CrossOrigin
@RequestMapping("/api/user_subject")
class UserSubjectController(
    private val userSubjectService: UserSubjectService,
    private val jwtUtil: JWTUtil,
    private val userService: UserService,
    private val subjectService: SubjectService,
    private val levelService: LevelService
//    private val
){
    @PostMapping("/add")
    fun addUserSubject(@RequestHeader("Authorization") token: String, @RequestBody subjectGet:SubjectData){
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)
        val user = userService.findUserByEmail(userEmail)

        val subject = subjectService.getSubjectByName(subjectGet.name)
        val level = levelService.getLevelByName(subjectGet.level!!)

        println(user)
        println(subject)
        println(level)

        val userSubject = UserSubject(user=user!!, subject=subject, level=level!!)

        userSubjectService.addUserSubject(userSubject)
    }
}