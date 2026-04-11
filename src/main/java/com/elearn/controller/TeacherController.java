package com.elearn.controller;

import com.elearn.dto.CourseCreateDto;
import com.elearn.model.*;
import com.elearn.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/teacher")
@PreAuthorize("hasRole('TEACHER')")
@RequiredArgsConstructor
public class TeacherController {

    private final UserService userService;
    private final CourseService courseService;
    private final ModuleService moduleService;
    private final LessonService lessonService;
    private final EnrollmentService enrollmentService;
    private final QuizService quizService;
    private final AssignmentService assignmentService;
    private final PaymentService paymentService;
    private final CategoryService categoryService;

    // ── Helper: Get Current Logged-in Teacher ──
    private User getCurrentUser(UserDetails ud) {
        return userService.getUserByEmail(ud.getUsername());
    }

    // ── 1. Dashboard & Analytics ──
    @GetMapping("/dashboard")
    public String dashboard(@AuthenticationPrincipal UserDetails ud, Model model) {
        User teacher = getCurrentUser(ud);
        List<Course> courses = courseService.getCoursesByTeacher(teacher);
        long totalStudents = enrollmentService.getTotalStudentsForTeacher(teacher.getId());
        BigDecimal earnings = paymentService.getTeacherEarnings(teacher);

        model.addAttribute("teacher", teacher);
        model.addAttribute("courses", courses);
        model.addAttribute("totalCourses", courses.size());
        model.addAttribute("totalStudents", totalStudents);
        model.addAttribute("earnings", (earnings != null) ? earnings : BigDecimal.ZERO);
        model.addAttribute("pageTitle", "Instructor Dashboard");
        
        return "teacher/dashboard";
    }

    // ── 2. Course Management ──
    @GetMapping("/courses")
    public String manageCourses(@AuthenticationPrincipal UserDetails ud, Model model) {
        User teacher = getCurrentUser(ud);
        model.addAttribute("courses", courseService.getCoursesByTeacher(teacher));
        model.addAttribute("pageTitle", "Manage Courses");
        return "teacher/manage-courses";
    }

    @GetMapping("/courses/add")
    public String addCoursePage(Model model) {
        model.addAttribute("courseDto", new CourseCreateDto());
        model.addAttribute("categories", categoryService.getAllCategories());
        model.addAttribute("pageTitle", "Create Course");
        return "teacher/add-course";
    }

    @PostMapping("/courses/save")
    public String saveOrUpdateCourse(@ModelAttribute CourseCreateDto dto, @AuthenticationPrincipal UserDetails ud, RedirectAttributes ra) {
        try {
            Course course = courseService.createCourse(dto, ud.getUsername());
            ra.addFlashAttribute("successMsg", "Course saved! Now build your curriculum.");
            return "redirect:/teacher/courses/" + course.getId() + "/modules";
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Error: " + e.getMessage());
            return "redirect:/teacher/courses/add";
        }
    }

    @GetMapping("/courses/edit/{courseId}")
    public String editCoursePage(@PathVariable Long courseId, Model model) {
        model.addAttribute("course", courseService.getCourseById(courseId));
        model.addAttribute("categories", categoryService.getAllCategories());
        return "teacher/add-course";
    }

    // ── 3. Curriculum (Modules & Lessons) ──
    @GetMapping("/courses/{courseId}/modules")
    public String modulesPage(@PathVariable Long courseId, Model model) {
        model.addAttribute("course", courseService.getCourseById(courseId));
        model.addAttribute("modules", moduleService.getModulesByCourse(courseId));
        return "teacher/add-module-lesson";
    }

    @PostMapping("/courses/{courseId}/modules/add")
    public String addModule(@PathVariable Long courseId, @RequestParam String title, RedirectAttributes ra) {
        try {
            moduleService.createModule(courseId, title);
            ra.addFlashAttribute("successMsg", "Module added!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/teacher/courses/" + courseId + "/modules";
    }

    @PostMapping("/modules/{moduleId}/lessons/add")
    public String addLesson(@PathVariable Long moduleId, @RequestParam String title, @RequestParam int durationMinutes,
                            @RequestParam(required = false) String videoUrl, @RequestParam(required = false) String content,
                            @RequestParam(required = false) MultipartFile videoFile, @RequestParam(required = false) MultipartFile pdfFile,
                            RedirectAttributes ra) {
        try {
            CourseModule module = moduleService.getModuleById(moduleId);
            lessonService.createLessonWithFiles(moduleId, title, durationMinutes, videoUrl, content, videoFile, pdfFile);
            ra.addFlashAttribute("successMsg", "Lesson added successfully!");
            return "redirect:/teacher/courses/" + module.getCourse().getId() + "/modules";
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Upload Error: " + e.getMessage());
            return "redirect:/teacher/courses/" + moduleId + "/modules";
        }
    }
    
    @PostMapping("/modules/update/{moduleId}")
    public String updateModule(@PathVariable Long moduleId, 
                               @RequestParam String title, 
                               @RequestParam Long courseId, 
                               RedirectAttributes ra) {
        try {
            moduleService.updateModule(moduleId, title);
            ra.addFlashAttribute("successMsg", "Module title updated successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Update failed: " + e.getMessage());
        }
        // Wapas usi course ke modules page par bhejna zaroori hai
        return "redirect:/teacher/courses/" + courseId + "/modules";
    }

    // ── Delete Module (Optional but Recommended) ──
    @PostMapping("/modules/delete/{moduleId}")
    public String deleteModule(@PathVariable Long moduleId, 
                               @RequestParam Long courseId, 
                               RedirectAttributes ra) {
        try {
            moduleService.deleteModule(moduleId);
            ra.addFlashAttribute("successMsg", "Module removed successfully.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Delete failed: " + e.getMessage());
        }
        return "redirect:/teacher/courses/" + courseId + "/modules";
    }

    // ── 4. Assessments & Quiz Builder ──
    @GetMapping("/assignments")
    public String showAssignmentsCenter(@AuthenticationPrincipal UserDetails ud, Model model) {
        User teacher = getCurrentUser(ud);
        List<Assignment> assignments = assignmentService.getAssignmentsByTeacher(teacher);
        model.addAttribute("activeAssignments", assignments);
        model.addAttribute("submissions", assignmentService.getSubmissionsByTeacher(teacher));
        model.addAttribute("pageTitle", "Assessments");
        return "teacher/assignments"; 
    }

    @PostMapping("/assignments/save")
    public String saveAssignment(@RequestParam String title, @RequestParam String type, @RequestParam Long moduleId,
                                 @RequestParam Integer maxMarks, @RequestParam String dueDate,
                                 @RequestParam(required = false) String description, RedirectAttributes ra) {
        try {
            Assignment savedAssignment = assignmentService.createAssignment(title, description, java.time.LocalDate.parse(dueDate), maxMarks, moduleId, type);
            ra.addFlashAttribute("successMsg", "Published successfully!");
            if ("QUIZ".equalsIgnoreCase(type)) return "redirect:/teacher/assignments/" + savedAssignment.getId() + "/questions";
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Failed: " + e.getMessage());
        }
        return "redirect:/teacher/assignments"; 
    }

    @GetMapping("/assignments/{assignmentId}/questions")
    public String showQuizBuilder(@PathVariable Long assignmentId, Model model) {
        model.addAttribute("assignment", assignmentService.getAssignmentById(assignmentId));
        model.addAttribute("questions", quizService.getQuestionsByAssignment(assignmentId));
        return "teacher/quiz-builder"; 
    }

    @PostMapping("/assignments/{assignmentId}/questions/add")
    public String addQuizQuestion(@PathVariable Long assignmentId, @RequestParam String questionText,
                                  @RequestParam String optionA, @RequestParam String optionB, @RequestParam String optionC,
                                  @RequestParam String optionD, @RequestParam String correctOption,
                                  @RequestParam Integer marks, RedirectAttributes ra) {
        try {
            quizService.addQuestion(assignmentId, questionText, optionA, optionB, optionC, optionD, correctOption, marks);
            ra.addFlashAttribute("successMsg", "Question Added!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Error: " + e.getMessage());
        }
        return "redirect:/teacher/assignments/" + assignmentId + "/questions";
    }

    // ── 5. Revenue & Payments ──
    @GetMapping({"/earnings", "/revenue"})   
    public String detailedEarnings(@AuthenticationPrincipal UserDetails ud, Model model) {
        User teacher = getCurrentUser(ud);
        BigDecimal totalEarnings = paymentService.getTeacherEarnings(teacher);
        
        model.addAttribute("transactions", paymentService.getTeacherPayments(teacher));
        model.addAttribute("totalEarnings", (totalEarnings != null) ? totalEarnings : BigDecimal.ZERO);
        model.addAttribute("pageTitle", "Revenue"); 
        
        return "teacher/revenue"; 
    }
// ── 6. Grading & Students ──
    
    /**
     * Shows the list of all students enrolled in the teacher's courses.
     * Maps to: /teacher/courses/students
     */
    @GetMapping("/courses/students")
    public String viewAllStudents(@AuthenticationPrincipal UserDetails ud, Model model) {
        User teacher = getCurrentUser(ud);
        
        // Fetch enrollments for all courses owned by this teacher
        List<Enrollment> enrollments = enrollmentService.getEnrollmentsByTeacher(teacher);
        
        model.addAttribute("enrollments", enrollments);
        model.addAttribute("totalStudents", enrollments.size());
        model.addAttribute("pageTitle", "Manage Students"); // Sidebar active state ke liye
        
        return "teacher/enrolled-students"; // Ensure kijiye ki 'enrolled-students.jsp' file hai
    }
    
    @PostMapping("/assignments/delete/{assignmentId}")
    public String deleteAssignment(@PathVariable Long assignmentId, RedirectAttributes ra) {
        try {
            // Assessment fetch karna taaki courseId mil sake redirect ke liye
            Assignment assignment = assignmentService.getAssignmentById(assignmentId);
            Long courseId = assignment.getModule().getCourse().getId();
            
            // Delete logic
            assignmentService.deleteAssignment(assignmentId);
            
            ra.addFlashAttribute("successMsg", "Assessment deleted successfully.");
            return "redirect:/teacher/courses/" + courseId + "/modules";
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Failed to delete: " + e.getMessage());
            return "redirect:/teacher/assignments";
        }
    }

    @PostMapping("/assignments/grade/{submissionId}")
    public String gradeAssignment(@PathVariable Long submissionId, 
                                 @RequestParam int marks, 
                                 @RequestParam String feedback, 
                                 RedirectAttributes ra) {
        assignmentService.gradeSubmission(submissionId, marks, feedback);
        ra.addFlashAttribute("successMsg", "Student graded successfully!");
        return "redirect:/teacher/assignments";
    }

    // ── 6. Profile Management ──
    @GetMapping("/profile")
    public String profilePage(@AuthenticationPrincipal UserDetails ud, Model model) {
        model.addAttribute("teacher", getCurrentUser(ud));
        model.addAttribute("pageTitle", "Teacher Profile");
        return "teacher/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@AuthenticationPrincipal UserDetails ud, 
                                @RequestParam String fullName,
                                @RequestParam(required = false) String bio, 
                                @RequestParam(required = false) String phone,
                                @RequestParam(required = false) MultipartFile profileImage,
                                RedirectAttributes ra) {
        try {
            User teacher = getCurrentUser(ud);
            userService.updateProfile(teacher.getId(), fullName, bio, phone, profileImage);
            ra.addFlashAttribute("successMsg", "Profile Updated Successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Failed to update profile: " + e.getMessage());
        }
        return "redirect:/teacher/profile";
    }
}