package com.open_inc.SchoolBack.config

import com.open_inc.SchoolBack.models.QuestionType
import com.open_inc.SchoolBack.repositories.QuestionTypeRepository
import org.springframework.boot.CommandLineRunner
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class DataInitializer {

    @Bean
    fun initializeData(questionTypeRepository: QuestionTypeRepository) = CommandLineRunner {
        val questionTypes = listOf(
            QuestionType(type = "checkbox"),
            QuestionType(type = "radio"),
            QuestionType(type = "text"),
            QuestionType(type = "multitext")
        )

        questionTypeRepository.saveAll(questionTypes)
    }
}
