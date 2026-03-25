package com.elearn.repository;

import com.elearn.model.Assignment;
import com.elearn.model.User;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AssignmentRepository extends JpaRepository<Assignment, Long> {

    List<Assignment> findByModuleId(Long moduleId);

    // Module ke through course ke saare assignments
    List<Assignment> findByModuleCourseId(Long courseId);

     // JPA Magic: Assignment -> Module -> Course -> Instructor
     List<Assignment> findByModule_Course_Instructor(User instructor);
    
}