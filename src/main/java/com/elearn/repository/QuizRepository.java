package com.elearn.repository;

import com.elearn.model.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuizRepository extends JpaRepository<Quiz, Long> {

    // Module ke saare quizzes
    List<Quiz> findByModuleId(Long moduleId);

    long countByModuleId(Long moduleId);
}