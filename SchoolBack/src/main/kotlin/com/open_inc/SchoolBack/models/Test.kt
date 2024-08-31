package com.open_inc.SchoolBack.models

import java.time.OffsetDateTime
import jakarta.persistence.*

@Entity
@Table(name = "Test")
data class Test(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "teacher_id")
    val teacher: TeacherProfile,

    @Column(name = "name", length = 32, nullable = false)
    val name: String,

    @Column(name = "timelimit")
    val timeLimit: Int,

    @Column(name = "created_at")
    val createdAt: OffsetDateTime = OffsetDateTime.now(),

    @Column(name = "updated_at")
    val updatedAt: OffsetDateTime = OffsetDateTime.now()
)
