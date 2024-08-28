package com.open_inc.SchoolBack.services

import com.open_inc.SchoolBack.models.Subject
import com.open_inc.SchoolBack.models.User
import com.open_inc.SchoolBack.models.UserSubject
import com.open_inc.SchoolBack.repositories.UserSubjectRepository
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.stereotype.Service

@Service
class UserSubjectService(
    private val userSubjectRepository: UserSubjectRepository
) {
    fun getUserSubjectByUserAndSubject(user: User, subject: Subject):UserSubject?{
        return userSubjectRepository.findUserSubjectsByUserAndSubject(user, subject).firstOrNull { it.isVisible }
    }

    fun getUserSubjects(user: User): List<UserSubject> {
        val result = userSubjectRepository.findUserSubjectByUser(user)
        return result.filter { it.isVisible }
    }

    fun addUserSubject(userSubject: UserSubject):UserSubject{
        return userSubjectRepository.save(userSubject)
    }

    fun deleteUserSubject(userSubject: UserSubject?){
        if(userSubject == null)
            return
        try {
            userSubjectRepository.delete(userSubject)
        }catch (e: DataIntegrityViolationException){
            userSubject.isVisible = false
            userSubjectRepository.save(userSubject)
        }
    }

    fun getUserSubjectById(id: Int): UserSubject? {
        return userSubjectRepository.getReferenceById(id)
    }
}