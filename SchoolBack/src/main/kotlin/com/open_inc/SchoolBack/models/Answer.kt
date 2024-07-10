package com.open_inc.SchoolBack.models

import java.time.LocalDateTime
import jakarta.persistence.*

@Entity
@Table(name = "Answer")
data class Answer(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    val user: User,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id")
    val question: Question,

    @Column(name = "answer", length = 256)
    val answer: String,

    @Column(name = "answer_start_time")
    val answerStartTime: LocalDateTime,

    @Column(name = "answer_end_time")
    val answerEndTime: LocalDateTime,

    @Column(name = "created_at")
    val createdAt: LocalDateTime = LocalDateTime.now(),

    @Column(name = "updated_at")
    val updatedAt: LocalDateTime = LocalDateTime.now()
)
