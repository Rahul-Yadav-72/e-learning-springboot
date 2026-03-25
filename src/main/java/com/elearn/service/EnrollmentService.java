package com.elearn.service;

import com.elearn.model.Course;
import com.elearn.model.Enrollment;
import com.elearn.model.User;
import com.elearn.repository.CourseRepository;
import com.elearn.repository.EnrollmentRepository;
import com.elearn.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class EnrollmentService {

    private final EnrollmentRepository enrollmentRepository;
    private final CourseRepository courseRepository;
    private final UserRepository userRepository;
    private final EmailService emailService;

    public Enrollment enrollStudent(Long studentId, Long courseId) {
        User student = userRepository.findById(studentId)
                .orElseThrow(() ->
                        new RuntimeException("Student not found"));
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() ->
                        new RuntimeException("Course not found"));

        if (enrollmentRepository.existsByStudentAndCourse(
                student, course)) {
            throw new RuntimeException(
                    "Aap already enrolled hain");
        }

        Enrollment enrollment = new Enrollment();
        enrollment.setStudent(student);
        enrollment.setCourse(course);
        enrollment.setProgressPercent(0);
        enrollment.setCompleted(false);

        enrollmentRepository.save(enrollment);

        emailService.sendEnrollmentEmail(
                student.getEmail(),
                student.getFullName(),
                course.getTitle());

        return enrollment;
    }

    // ← Controllers User + Course pass karte hain
    public boolean isEnrolled(User student, Course course) {
        return enrollmentRepository
                .existsByStudentAndCourse(student, course);
    }

    // ← Controllers Long, Long bhi pass karte hain
    public boolean isEnrolled(Long studentId, Long courseId) {
        User student = userRepository.findById(studentId)
                .orElseThrow(() ->
                        new RuntimeException("Student not found"));
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() ->
                        new RuntimeException("Course not found"));
        return enrollmentRepository
                .existsByStudentAndCourse(student, course);
    }

    // ← StudentController User pass karta tha
    public List<Enrollment> getStudentEnrollments(User student) {
        return enrollmentRepository.findByStudent(student);
    }

    public List<Enrollment> getStudentEnrollments(Long studentId) {
        User student = userRepository.findById(studentId)
                .orElseThrow(() ->
                        new RuntimeException("Student not found"));
        return enrollmentRepository.findByStudent(student);
    }

    // ← TeacherController Course object pass karta tha
    public List<Enrollment> getCourseEnrollments(Course course) {
        return enrollmentRepository.findByCourse(course);
    }

    public List<Enrollment> getCourseEnrollments(Long courseId) {
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() ->
                        new RuntimeException("Course not found"));
        return enrollmentRepository.findByCourse(course);
    }

    // ← StudentController User + Course pass karta tha
    public Enrollment getEnrollment(User student, Course course) {
        return enrollmentRepository
                .findByStudentAndCourse(student, course)
                .orElseThrow(() ->
                        new RuntimeException("Enrollment not found"));
    }

    public Enrollment getEnrollment(Long studentId, Long courseId) {
        return enrollmentRepository
                .findByStudentIdAndCourseId(studentId, courseId)
                .orElseThrow(() ->
                        new RuntimeException("Enrollment not found"));
    }
    public long getTotalStudentsForTeacher(Long teacherId) {
        return enrollmentRepository.countTotalStudentsByTeacherId(teacherId);
    }

    public List<Enrollment> getEnrollmentsByTeacher(User teacher) {
        return enrollmentRepository.findByCourse_Instructor(teacher);
    }
}