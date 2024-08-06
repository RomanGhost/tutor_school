package com.open_inc.SchoolBack.models

import jakarta.persistence.*

@Entity
@Table(name = "Review")
data class Review(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    val user: User,

    @Column(name = "rate")
    val rate: Int? = null,

    @Column(name = "text", length = 1024)
    val text: String? = null
)
