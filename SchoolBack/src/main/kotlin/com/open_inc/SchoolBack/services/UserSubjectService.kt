package com.open_inc.SchoolBack.services

import com.open_inc.SchoolBack.models.Subject
import com.open_inc.SchoolBack.models.User
import com.open_inc.SchoolBack.models.UserSubject
import com.open_inc.SchoolBack.repositories.UserSubjectRepository
import org.springframework.stereotype.Service

@Service
class UserSubjectService(
    private val userSubjectRepository: UserSubjectRepository
) {
    fun getUserSubjectByUserAndSubject(user: User, subject: Subject):UserSubject{
        return userSubjectRepository.findUserSubjectsByUserAndSubject(user, subject)
    }

    fun addUserSubject(userSubject: UserSubject):UserSubject{
        return userSubjectRepository.save(userSubject)
    }
}