package com.open_inc.SchoolBack.dataclasses

import java.time.LocalDateTime

data class LessonData (
    val id :Int,
    val subject:String,
    val plainDateTime:LocalDateTime,
    val status:String,
)