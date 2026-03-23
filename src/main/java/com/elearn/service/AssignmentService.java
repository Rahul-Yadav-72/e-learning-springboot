package com.elearn.service;

import com.elearn.model.*;
import com.elearn.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.*;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional
public class AssignmentService {

    private final AssignmentRepository assignmentRepository;
    private final AssignmentSubmissionRepository submissionRepository;
    private final ModuleRepository moduleRepository;
    private final UserRepository userRepository;

    public Assignment createAssignment(String title,
            String description, LocalDate dueDate,
            Integer maxMarks, Long moduleId) {

        CourseModule module = moduleRepository.findById(moduleId)
                .orElseThrow(() ->
                        new RuntimeException("Module not found"));

        Assignment assignment = new Assignment();
        assignment.setTitle(title);
        assignment.setDescription(description);
        assignment.setDueDate(dueDate);
        assignment.setMaxMarks(maxMarks);
        assignment.setModule(module);

        return assignmentRepository.save(assignment);
    }

    // ← StudentController submitAssignment(User, Long, String) call karta tha
    public AssignmentSubmission submitAssignment(User student,
            Long assignmentId, String text) {
        return submitAssignment(assignmentId,
                student.getEmail(), text, null);
    }

    public AssignmentSubmission submitAssignment(Long assignmentId,
            String studentEmail, String text, MultipartFile file) {

        Assignment assignment = assignmentRepository
                .findById(assignmentId)
                .orElseThrow(() ->
                        new RuntimeException("Assignment not found"));
        User student = userRepository.findByEmail(studentEmail)
                .orElseThrow(() ->
                        new RuntimeException("Student not found"));

        if (submissionRepository.existsByAssignmentIdAndStudentId(
                assignmentId, student.getId())) {
            throw new RuntimeException(
                    "Assignment already submit kar chuke hain");
        }

        String fileUrl = null;
        if (file != null && !file.isEmpty()) {
            fileUrl = saveFile(file);
        }

        AssignmentSubmission sub = new AssignmentSubmission();
        sub.setAssignment(assignment);
        sub.setStudent(student);
        sub.setSubmissionText(text);
        sub.setFileUrl(fileUrl);
        sub.setGraded(false);

        return submissionRepository.save(sub);
    }

    public AssignmentSubmission gradeAssignment(Long submissionId,
            Integer marks, String feedback) {
        AssignmentSubmission sub = submissionRepository
                .findById(submissionId)
                .orElseThrow(() ->
                        new RuntimeException("Submission not found"));
        sub.setMarksObtained(marks);
        sub.setFeedback(feedback);
        sub.setGraded(true);
        return submissionRepository.save(sub);
    }

    @Transactional(readOnly = true)
    public List<AssignmentSubmission> getSubmissions(
            Long assignmentId) {
        return submissionRepository.findByAssignmentId(assignmentId);
    }

    @Transactional(readOnly = true)
    public List<AssignmentSubmission> getUngradedSubmissions(
            Long assignmentId) {
        return submissionRepository
                .findByAssignmentIdAndGradedFalse(assignmentId);
    }

    private String saveFile(MultipartFile file) {
        try {
            String dir = "uploads/assignments/";
            String fileName = UUID.randomUUID()
                    + "_" + file.getOriginalFilename();
            Path path = Paths.get(dir + fileName);
            Files.createDirectories(path.getParent());
            Files.copy(file.getInputStream(), path,
                    StandardCopyOption.REPLACE_EXISTING);
            return "/" + dir + fileName;
        } catch (IOException e) {
            throw new RuntimeException(
                    "File upload fail: " + e.getMessage());
        }
    }
}