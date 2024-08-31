package com.open_inc.SchoolBack.models

import java.time.OffsetDateTime
import jakarta.persistence.*

@Entity
@Table(name = "Level")
data class Level(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,

    @Column(name = "name", length = 4, unique = true, nullable = false)
    val name: String,

    @Column(name = "description", length = 256)
    val description: String? = null,

    @Column(name = "coefficient")
    val coefficient: Float? = null,

    @Column(name = "created_at", nullable = false)
    val createdAt: OffsetDateTime = OffsetDateTime.now(),

    @Column(name = "updated_at", nullable = false)
    val updatedAt: OffsetDateTime = OffsetDateTime.now()
)
