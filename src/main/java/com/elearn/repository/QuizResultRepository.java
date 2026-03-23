package com.elearn.repository;

import com.elearn.model.QuizResult;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface QuizResultRepository extends JpaRepository<QuizResult, Long> {

    // Student ka quiz result
    Optional<QuizResult> findByQuizIdAndStudentId(Long quizId, Long studentId);

    // Student ne quiz attempt kiya hai ya nahi
    boolean existsByQuizIdAndStudentId(Long quizId, Long studentId);

    // Student ke saare quiz results
    List<QuizResult> findByStudentId(Long studentId);

    // Quiz ke saare results (Teacher analytics)
    List<QuizResult> findByQuizId(Long quizId);

    // Average score for a quiz
    @Query("SELECT AVG(qr.percentage) FROM QuizResult qr WHERE qr.quiz.id = :quizId")
    Double findAverageScoreByQuizId(@Param("quizId") Long quizId);
}