package com.elearn.service;

import com.elearn.model.*;
import com.elearn.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class AssignmentService {

    private final AssignmentRepository assignmentRepository;
    private final AssignmentSubmissionRepository submissionRepository;
    private final ModuleRepository moduleRepository;
    private final UserRepository userRepository;

    /** ── 1. Create New Assignment ── */
    /** ── 1. Create New Assignment ── */
    public Assignment createAssignment(String title, String description, LocalDate dueDate,
                                     Integer maxMarks, Long moduleId, String type) { // <-- 1. Yahan 'String type' add kiya
        
        CourseModule module = moduleRepository.findById(moduleId)
                .orElseThrow(() -> new RuntimeException("Module not found"));

        Assignment assignment = Assignment.builder()
                .title(title)
                .description(description)
                .dueDate(dueDate)
                .maxMarks(maxMarks)
                .module(module)
                .type(type) // <-- 2. Ab ye 'type' upar wale parameter se data lega
                .build();

        return assignmentRepository.save(assignment);
    }
    
    public AssignmentSubmission submitAssignment(User student, Long assignmentId, String text) {
        // Ye method asli method ko call karega aur file ko 'null' bhej dega
        return submitAssignment(assignmentId, student.getEmail(), text, null);
    }
 // Assignment id se fetch karne ke liye method
    public Assignment getAssignmentById(Long id) {
        return assignmentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Assignment not found with id: " + id));
    }
 // Assignment delete karne ka logic
    public void deleteAssignment(Long assignmentId) {
        // Pehle check karte hain ki assignment exist karta hai ya nahi
        if (assignmentRepository.existsById(assignmentId)) {
            assignmentRepository.deleteById(assignmentId);
            System.out.println("✅ Assignment ID " + assignmentId + " deleted successfully.");
        } else {
            throw new RuntimeException("Assignment not found with ID: " + assignmentId);
        }
    }

    /** ── 2. Submit Assignment (PDF to DB BLOB) ── */
    public AssignmentSubmission submitAssignment(Long assignmentId, String studentEmail, 
                                                String text, MultipartFile file) {

        Assignment assignment = assignmentRepository.findById(assignmentId)
                .orElseThrow(() -> new RuntimeException("Assignment not found"));
        
        User student = userRepository.findByEmail(studentEmail)
                .orElseThrow(() -> new RuntimeException("Student not found"));

        // Check duplicate submission
        if (submissionRepository.existsByAssignmentAndStudent(assignment, student)) {
            throw new RuntimeException("Assignment already submitted!");
        }

        AssignmentSubmission sub = AssignmentSubmission.builder()
                .assignment(assignment)
                .student(student)
                .submissionText(text)
                .graded(false)
                .build();

        // Convert PDF file to byte array for Database storage
        if (file != null && !file.isEmpty()) {
            try {
                sub.setFileData(file.getBytes()); // Yahan bytes direct save ho rahe hain
                sub.setFileName(file.getOriginalFilename());
            } catch (IOException e) {
                throw new RuntimeException("Failed to process PDF file: " + e.getMessage());
            }
        }

        return submissionRepository.save(sub);
    }

    /** ── 3. Teacher: Grade Submission ── */
    public void gradeSubmission(Long submissionId, int marks, String feedback) {
        AssignmentSubmission sub = submissionRepository.findById(submissionId)
                .orElseThrow(() -> new RuntimeException("Submission not found"));
        
        if (marks > sub.getAssignment().getMaxMarks()) {
            throw new RuntimeException("Marks cannot exceed " + sub.getAssignment().getMaxMarks());
        }

        sub.setMarksObtained(marks);
        sub.setFeedback(feedback);
        sub.setGraded(true);
        submissionRepository.save(sub);
    }
    
    

    /** ── 4. Queries for Teacher ── */
    @Transactional(readOnly = true)
    public List<AssignmentSubmission> getSubmissionsByTeacher(User teacher) {
        return submissionRepository.findByAssignment_Module_Course_Instructor(teacher);
    }

    @Transactional(readOnly = true)
    public List<Assignment> getAssignmentsByTeacher(User teacher) {
        return assignmentRepository.findByModule_Course_Instructor(teacher);
    }

    @Transactional(readOnly = true)
    public AssignmentSubmission findById(Long id) {
        return submissionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Submission not found"));
    }
}