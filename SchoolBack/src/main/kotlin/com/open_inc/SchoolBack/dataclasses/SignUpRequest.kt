package com.open_inc.SchoolBack.dataclasses

data class SignUpRequest(
    val firstName: String,
    val lastName: String,
    val surname: String,
    val email: String,
    val password: String
)