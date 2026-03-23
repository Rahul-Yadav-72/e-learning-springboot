package com.elearn.repository;

import com.elearn.model.AssignmentSubmission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AssignmentSubmissionRepository extends JpaRepository<AssignmentSubmission, Long> {

    // Student ka specific assignment submission
    Optional<AssignmentSubmission> findByAssignmentIdAndStudentId(
            Long assignmentId, Long studentId);

    // Student ne submit kiya hai ya nahi
    boolean existsByAssignmentIdAndStudentId(Long assignmentId, Long studentId);

    // Assignment ke saare submissions (Teacher grading ke liye)
    List<AssignmentSubmission> findByAssignmentId(Long assignmentId);

    // Student ke saare submissions
    List<AssignmentSubmission> findByStudentId(Long studentId);

    // Ungraded submissions (Teacher ko alert)
    List<AssignmentSubmission> findByAssignmentIdAndGradedFalse(Long assignmentId);
}