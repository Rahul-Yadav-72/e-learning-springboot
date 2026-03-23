package com.elearn.repository;

import com.elearn.model.Assignment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AssignmentRepository extends JpaRepository<Assignment, Long> {

    List<Assignment> findByModuleId(Long moduleId);

    // Module ke through course ke saare assignments
    List<Assignment> findByModuleCourseId(Long courseId);
}