package com.open_inc.SchoolBack.services

import com.open_inc.SchoolBack.models.User
import com.open_inc.SchoolBack.repositories.UserRepository
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service

@Service
class UserService(
    private val userRepository: UserRepository,
    private val passwordEncoder: PasswordEncoder
) {

    fun saveUser(user: User): User {
        // Проверка уникальности email
        if (userRepository.existsByEmail(user.email)) {
            throw IllegalArgumentException("Email is already in use")
        }

        // Шифрование пароля
        val encryptedPassword = passwordEncoder.encode(user.password)
        val newUser = user.copy(password = encryptedPassword)

        // Сохранение пользователя
        return userRepository.save(newUser)
    }

    fun findUserByEmail(email: String): User? {
        return userRepository.findByEmail(email)
    }

    fun existsByEmail(email: String): Boolean {
        return userRepository.existsByEmail(email)
    }

    fun updateUser(user:User):User{
        val newUser:User

        if (user.password != ""){
            // Шифрование пароля
            val encryptedPassword = passwordEncoder.encode(user.password)
            newUser = user.copy(password = encryptedPassword)
        }else{
            val existUser = userRepository.findByEmail(user.email)
            newUser = user.copy(password = existUser!!.password)
        }
        // Сохранение пользователя
        return userRepository.save(newUser)
    }
}
