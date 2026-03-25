package com.elearn.repository;

import com.elearn.model.Course;
import com.elearn.model.Enrollment;
import com.elearn.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EnrollmentRepository extends JpaRepository<Enrollment, Long> {

    // Student ka specific course mein enrollment
    Optional<Enrollment> findByStudentAndCourse(User student, Course course);

    // Student enrolled hai ya nahi check karo
    boolean existsByStudentAndCourse(User student, Course course);

    // Student ke saare enrolled courses
    List<Enrollment> findByStudent(User student);

    // Course ke saare enrolled students
    List<Enrollment> findByCourse(Course course);

    // Completed enrollments
    List<Enrollment> findByStudentAndCompletedTrue(User student);

    // Course ki total enrollments count
    long countByCourse(Course course);

    // Teacher ke saare courses mein total enrollments
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.course.instructor.id = :teacherId")
    long countByTeacherId(@Param("teacherId") Long teacherId);

    // Student ID aur Course ID se dhundho (shortcut)
    Optional<Enrollment> findByStudentIdAndCourseId(Long studentId, Long courseId);
    
 // Teacher ke basis par enrollments find karne ke liye magic method
    // Iska matlab hai: Enrollment -> Course -> Instructor (User)
    List<Enrollment> findByCourse_Instructor(User instructor);
 // Direct SQL query jo ek baar mein count nikal degi
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.course.instructor.id = :teacherId")
    long countTotalStudentsByTeacherId(@Param("teacherId") Long teacherId);
}