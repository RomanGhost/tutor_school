package com.open_inc.SchoolBack.controllers

import com.open_inc.SchoolBack.models.User
import com.open_inc.SchoolBack.services.UserService
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@CrossOrigin
@RestController
@RequestMapping("/api/auth")
class UserController(private val userService: UserService) {

    @GetMapping("/user")
    fun getUser(@RequestParam email: String): ResponseEntity<User> {
        val user = userService.findUserByEmail(email) ?: return ResponseEntity(HttpStatus.NOT_FOUND)
        return ResponseEntity.ok(user)
    }

    @PutMapping("/user/update")
    fun updateUser(@RequestBody user: User): ResponseEntity<User> {
        userService.updateUser(user)
        return ResponseEntity.ok(user)
    }
}