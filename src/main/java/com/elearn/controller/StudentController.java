package com.elearn.controller;

import com.elearn.dto.PaymentDto;
import com.elearn.dto.ReviewDto;
import com.elearn.model.*;
import com.elearn.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/student")
@PreAuthorize("hasRole('STUDENT')")
@RequiredArgsConstructor
public class StudentController {

    private final UserService userService;
    private final CourseService courseService;
    private final EnrollmentService enrollmentService;
    private final ProgressService progressService;
    private final PaymentService paymentService;
    private final QuizService quizService;
    private final ReviewService reviewService;
    private final CertificateService certificateService;
    private final AssignmentService assignmentService;

    // ── Helper: Current User ──
    private User getCurrentUser(UserDetails ud) {
        return userService.getUserByEmail(ud.getUsername());
    }

    // ── Student Dashboard ──
    @GetMapping("/dashboard")
    public String dashboard(@AuthenticationPrincipal UserDetails ud, Model model) {
        User student = getCurrentUser(ud);
        List<Enrollment> enrollments = enrollmentService.getStudentEnrollments(student);

        long completedCount = enrollments.stream().filter(Enrollment::isCompleted).count();

        model.addAttribute("student", student);
        model.addAttribute("enrollments", enrollments);
        model.addAttribute("totalEnrolled", enrollments.size());
        model.addAttribute("completedCourses", completedCount);
        model.addAttribute("certificates", certificateService.getCertificatesByUser(student));
        
        // Purana quizResults hata diya gaya hai kyunki ab sab kuch Assignment Submissions mein aayega

        return "student/dashboard";
    }

    // ── My Courses ──
    @GetMapping("/my-courses")
    public String myCourses(@AuthenticationPrincipal UserDetails ud, Model model) {
        User student = getCurrentUser(ud);
        List<Enrollment> enrollments = enrollmentService.getStudentEnrollments(student);
        model.addAttribute("enrollments", enrollments);
        return "student/my-courses";
    }

    // ── Course Detail ──
    @GetMapping("/courses/{courseId}")
    public String courseDetail(@PathVariable Long courseId, @AuthenticationPrincipal UserDetails ud, Model model) {
        User student = getCurrentUser(ud);
        Course course = courseService.getCourseById(courseId);

        boolean enrolled = enrollmentService.isEnrolled(student, course);
        model.addAttribute("course", course);
        model.addAttribute("isEnrolled", enrolled);
        model.addAttribute("student", student);

        return "student/course-detail";
    }

    // ── Payment Page ──
    @GetMapping("/payment/{courseId}")
    public String paymentPage(@PathVariable Long courseId, @AuthenticationPrincipal UserDetails ud, Model model) {
        User student = getCurrentUser(ud);
        Course course = courseService.getCourseById(courseId);

        if (enrollmentService.isEnrolled(student, course)) {
            return "redirect:/student/learn/" + courseId;
        }

        model.addAttribute("course", course);
        model.addAttribute("student", student);
        return "student/payment";
    }

    // ── Process Payment ──
    @PostMapping("/payment/process")
    public String processPayment(@ModelAttribute PaymentDto dto, @AuthenticationPrincipal UserDetails ud, RedirectAttributes redirectAttrs) {
        User student = getCurrentUser(ud);
        try {
            paymentService.processPayment(student, dto);
            redirectAttrs.addFlashAttribute("successMsg", "Payment successful! Course mein enrolled ho gaye.");
            return "redirect:/student/learn/" + dto.getCourseId();
        } catch (RuntimeException e) {
            redirectAttrs.addFlashAttribute("errorMsg", e.getMessage());
            return "redirect:/student/payment/" + dto.getCourseId();
        }
    }

    // ── Free Enroll ──
    @PostMapping("/enroll/free/{courseId}")
    public String enrollFree(@PathVariable Long courseId, @AuthenticationPrincipal UserDetails ud, RedirectAttributes redirectAttrs) {
        User student = getCurrentUser(ud);
        try {
            enrollmentService.enrollStudent(student.getId(), courseId);
            redirectAttrs.addFlashAttribute("successMsg", "Successfully enrolled!");
            return "redirect:/student/learn/" + courseId;
        } catch (RuntimeException e) {
            redirectAttrs.addFlashAttribute("errorMsg", e.getMessage());
            return "redirect:/courses/" + courseId;
        }
    }

    // ── Learn Page ──
    @GetMapping("/learn/{courseId}")
    public String learnPage(@PathVariable Long courseId, @RequestParam(required = false) Long lessonId, @AuthenticationPrincipal UserDetails ud, Model model) {
        User student = getCurrentUser(ud);
        Course course = courseService.getCourseById(courseId);

        if (!enrollmentService.isEnrolled(student, course)) {
            return "redirect:/courses/" + courseId;
        }

        Enrollment enrollment = enrollmentService.getEnrollment(student, course);
        List<CourseModule> modules = course.getModules();

        Lesson currentLesson = null;
        if (lessonId != null) {
            currentLesson = modules.stream()
                .flatMap(m -> m.getLessons().stream())
                .filter(l -> l.getId().equals(lessonId))
                .findFirst()
                .orElse(null);
        }
        if (currentLesson == null && !modules.isEmpty() && !modules.get(0).getLessons().isEmpty()) {
            currentLesson = modules.get(0).getLessons().get(0);
        }

        List<Progress> progressList = progressService.getProgressForEnrollment(enrollment);

        model.addAttribute("course", course);
        model.addAttribute("modules", modules);
        model.addAttribute("currentLesson", currentLesson);
        model.addAttribute("enrollment", enrollment);
        model.addAttribute("progressList", progressList);
        model.addAttribute("student", student);

        return "student/learn";
    }

    // ── Mark Lesson Complete ──
    @PostMapping("/lesson/complete")
    public String markComplete(@RequestParam Long lessonId, @RequestParam Long courseId, @AuthenticationPrincipal UserDetails ud, RedirectAttributes redirectAttrs) {
        User student = getCurrentUser(ud);
        progressService.markLessonComplete(student, lessonId);
        redirectAttrs.addFlashAttribute("successMsg", "Lesson complete mark ho gaya!");
        return "redirect:/student/learn/" + courseId + "?lessonId=" + lessonId;
    }

    // ==========================================
    // ── NEW QUIZ LOGIC (UPDATED ARCHITECTURE) ──
    // ==========================================

    @GetMapping("/quiz/{assignmentId}")
    public String quizPage(@PathVariable Long assignmentId, @AuthenticationPrincipal UserDetails ud, Model model) {
        User student = getCurrentUser(ud);
        Assignment assignment = assignmentService.getAssignmentById(assignmentId);
        List<QuizQuestion> questions = quizService.getQuestionsByAssignment(assignmentId);

        model.addAttribute("assignment", assignment);
        model.addAttribute("questions", questions);
        model.addAttribute("student", student);
        
        return "student/quiz"; 
    }

    @PostMapping("/quiz/submit")
    public String submitQuiz(@RequestParam Long assignmentId, @RequestParam Map<String, String> answers, @AuthenticationPrincipal UserDetails ud, RedirectAttributes redirectAttrs) {
        User student = getCurrentUser(ud);
        try {
            List<QuizQuestion> questions = quizService.getQuestionsByAssignment(assignmentId);
            int totalMarks = 0;
            int obtainedMarks = 0;

            // Auto-Grader Logic
            for (QuizQuestion q : questions) {
                totalMarks += q.getMarks();
                String studentAnswer = answers.get("q_" + q.getId()); // Form se answer aayega
                if (studentAnswer != null && studentAnswer.equals(q.getCorrectOption())) {
                    obtainedMarks += q.getMarks();
                }
            }

            // Save as Assignment Submission
            String submissionText = "Auto-Graded Quiz Score: " + obtainedMarks + " / " + totalMarks;
            assignmentService.submitAssignment(student, assignmentId, submissionText);

            redirectAttrs.addFlashAttribute("successMsg", "Quiz submitted successfully! You scored: " + obtainedMarks + " out of " + totalMarks);
        } catch (RuntimeException e) {
            redirectAttrs.addFlashAttribute("errorMsg", "Failed to submit quiz: " + e.getMessage());
        }
        return "redirect:/student/dashboard";
    }

    // ── Submit Assignment (Writing Task) ──
    @PostMapping("/assignment/submit")
    public String submitAssignment(@RequestParam Long assignmentId, @RequestParam String submissionText, @AuthenticationPrincipal UserDetails ud, RedirectAttributes redirectAttrs) {
        User student = getCurrentUser(ud);
        try {
            assignmentService.submitAssignment(student, assignmentId, submissionText);
            redirectAttrs.addFlashAttribute("successMsg", "Assignment submitted!");
        } catch (RuntimeException e) {
            redirectAttrs.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/student/dashboard";
    }

    // ── Add Review ──
    @PostMapping("/review/add")
    public String addReview(@ModelAttribute ReviewDto dto, @AuthenticationPrincipal UserDetails ud, RedirectAttributes redirectAttrs) {
        User student = getCurrentUser(ud);
        try {
            reviewService.addReview(student, dto);
            redirectAttrs.addFlashAttribute("successMsg", "Review submit ho gaya!");
        } catch (RuntimeException e) {
            redirectAttrs.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/courses/" + dto.getCourseId();
    }

    // ── My Certificates ──
    @GetMapping("/certificates")
    public String myCertificates(@AuthenticationPrincipal UserDetails ud, Model model) {
        User student = getCurrentUser(ud);
        model.addAttribute("certificates", certificateService.getCertificatesByUser(student));
        return "student/certificates";
    }

    // ── Certificate Verify (Public) ──
    @GetMapping("/certificate/verify/{certNumber}")
    public String verifyCertificate(@PathVariable String certNumber, Model model) {
        certificateService.verifyCertificate(certNumber).ifPresentOrElse(
            cert -> {
                model.addAttribute("certificate", cert);
                model.addAttribute("valid", true);
            },
            () -> model.addAttribute("valid", false)
        );
        return "student/certificate-verify";
    }

    // ── Profile Page ──
    @GetMapping("/profile")
    public String profilePage(@AuthenticationPrincipal UserDetails ud, Model model) {
        User student = getCurrentUser(ud);
        model.addAttribute("student", student);
        model.addAttribute("totalEnrolled", enrollmentService.getStudentEnrollments(student).size());
        model.addAttribute("completedCourses", enrollmentService.getStudentEnrollments(student).stream().filter(Enrollment::isCompleted).count());
        model.addAttribute("certificates", certificateService.getCertificatesByUser(student));
        return "student/profile";
    }

    // ── Update Profile ──
    @PostMapping("/profile/update")
    public String updateProfile(@AuthenticationPrincipal UserDetails ud, @RequestParam String fullName, @RequestParam(required = false) String phone, @RequestParam(required = false) String bio, RedirectAttributes ra) {
        try {
            User student = getCurrentUser(ud);
            userService.updateProfile(student.getId(), fullName, phone, bio, null);
            ra.addFlashAttribute("successMsg", "Profile successfully updated!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Update failed: " + e.getMessage());
        }
        return "redirect:/student/profile";
    }

    // ── Change Password ──
    @PostMapping("/profile/change-password")
    public String changePassword(@AuthenticationPrincipal UserDetails ud, @RequestParam String currentPassword, @RequestParam String newPassword, @RequestParam String confirmPassword, RedirectAttributes ra) {
        try {
            if (!newPassword.equals(confirmPassword)) {
                ra.addFlashAttribute("errorMsg", "New passwords match nahi kar rahe!");
                return "redirect:/student/profile";
            }
            User student = getCurrentUser(ud);
            userService.changePassword(student.getId(), currentPassword, newPassword);
            ra.addFlashAttribute("successMsg", "Password successfully changed!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/student/profile";
    }
}