package com.open_inc.SchoolBack.models

import java.time.LocalDateTime
import jakarta.persistence.*

@Entity
@Table(name = "Mark")
data class Mark(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_teacher_id")
    val studentTeacher: StudentTeacher,

    @Column(name = "mark")
    val mark: Byte,

    @Column(name = "description", length = 256)
    val description: String? = null,

    @Column(name = "date")
    val date: LocalDateTime,

    @Column(name = "created_at")
    val createdAt: LocalDateTime = LocalDateTime.now(),

    @Column(name = "updated_at")
    val updatedAt: LocalDateTime = LocalDateTime.now()
)
