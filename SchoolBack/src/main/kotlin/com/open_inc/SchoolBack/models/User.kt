package com.open_inc.SchoolBack.models

import java.time.LocalDateTime
import jakarta.persistence.*

@Entity
@Table(name = "_User")
data class User(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,

    @Column(name = "last_name", length = 128)
    val lastName: String,

    @Column(name = "first_name", length = 128)
    val firstName: String,

    @Column(name = "surname", length = 128)
    val surname: String,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "level_id")
    val level: Level,

    @Column(name = "email", length = 256, unique = true, nullable = false)
    val email: String,

    @Column(name = "password", length = 256, nullable = false)
    val password: String,

    @Column(name = "description", length = 512)
    val description: String? = null,

    @Column(name = "photo", length = 128)
    val photo: String? = null,

    @Column(name = "created_at")
    val createdAt: LocalDateTime = LocalDateTime.now(),

    @Column(name = "updated_at")
    val updatedAt: LocalDateTime = LocalDateTime.now()
)
