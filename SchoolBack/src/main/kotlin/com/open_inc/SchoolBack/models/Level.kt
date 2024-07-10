package com.open_inc.SchoolBack.models

import java.time.LocalDateTime
import jakarta.persistence.*

@Entity
@Table(name = "Level")
data class Level(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,

    @Column(name = "name", length = 4, unique = true, nullable = false)
    val name: String,

    @Column(name = "created_at")
    val createdAt: LocalDateTime = LocalDateTime.now(),

    @Column(name = "updated_at")
    val updatedAt: LocalDateTime = LocalDateTime.now()
)
