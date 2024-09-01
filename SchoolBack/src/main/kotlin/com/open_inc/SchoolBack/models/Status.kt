package com.open_inc.SchoolBack.models

import jakarta.persistence.*

@Entity
@Table(name = "Status")
data class Status(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,

    @Column(name = "name", length = 16, unique = true)
    val name: String? = null
)
