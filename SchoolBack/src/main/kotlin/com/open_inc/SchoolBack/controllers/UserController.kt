package com.open_inc.SchoolBack.controllers

import com.open_inc.SchoolBack.configs.JWTUtil
import com.open_inc.SchoolBack.models.User
import com.open_inc.SchoolBack.services.UserService
import io.jsonwebtoken.Claims
import io.jsonwebtoken.Jwts
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@CrossOrigin
@RestController
@RequestMapping("/api/user")
class UserController(private val userService: UserService, private val jwtUtil: JWTUtil) {
    @GetMapping("/get")
    fun getUser(@RequestParam email: String, @RequestHeader("Authorization") token: String): ResponseEntity<User> {
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)

        if (userEmail != email) {
            return ResponseEntity(HttpStatus.UNAUTHORIZED)
        }

        val user = userService.findUserByEmail(email) ?: return ResponseEntity(HttpStatus.NOT_FOUND)
        return ResponseEntity.ok(user)
    }

    @PutMapping("/update")
    fun updateUser(@RequestBody user: User, @RequestHeader("Authorization") token: String): ResponseEntity<User> {
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)

        if (userEmail != user.email) {
            return ResponseEntity(HttpStatus.UNAUTHORIZED)
        }

        val updatedUser = userService.updateUser(user) ?: return ResponseEntity(HttpStatus.NOT_FOUND)
        return ResponseEntity.ok(updatedUser)
    }
}
