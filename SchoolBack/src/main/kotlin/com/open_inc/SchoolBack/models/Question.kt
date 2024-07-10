package com.open_inc.SchoolBack.models

import java.time.LocalDateTime
import jakarta.persistence.*

@Entity
@Table(name = "Question")
data class Question(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "test_id")
    val test: Test,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_type_id")
    val questionType: QuestionType,

    @Column(name = "title", length = 64)
    val title: String,

    @Column(name = "description", length = 128)
    val description: String? = null,

    @Column(name = "options", length = 256)
    val options: ArrayList<Map<String, Any>>,

    @Column(name = "created_at")
    val createdAt: LocalDateTime = LocalDateTime.now(),

    @Column(name = "updated_at")
    val updatedAt: LocalDateTime = LocalDateTime.now()
)
