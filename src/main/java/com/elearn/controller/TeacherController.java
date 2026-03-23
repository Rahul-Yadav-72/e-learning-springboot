package com.elearn.controller;

import com.elearn.dto.CourseCreateDto;
import com.elearn.dto.ModuleDto;
import com.elearn.dto.QuizDto;
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

import java.math.BigDecimal;
import java.util.List;

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

    // ── Helper ──
    private User getCurrentUser(UserDetails ud) {
        return userService.getUserByEmail(ud.getUsername());
    }

    // ── Teacher Dashboard ──
    @GetMapping("/dashboard")
    public String dashboard(
            @AuthenticationPrincipal UserDetails ud,
            Model model) {

        User teacher = getCurrentUser(ud);
        List<Course> courses =
            courseService.getCoursesByTeacher(teacher);

        long totalStudents = courses.stream()
            .mapToLong(c -> c.getTotalEnrollments())
            .sum();

        BigDecimal earnings =
            paymentService.getTeacherEarnings(teacher);

        model.addAttribute("teacher", teacher);
        model.addAttribute("courses", courses);
        model.addAttribute("totalCourses", courses.size());
        model.addAttribute("totalStudents", totalStudents);
        model.addAttribute("earnings", earnings);

        return "teacher/dashboard";
    }

    // ── Manage Courses ──
    @GetMapping("/courses")
    public String manageCourses(
            @AuthenticationPrincipal UserDetails ud,
            Model model) {

        User teacher = getCurrentUser(ud);
        model.addAttribute("courses",
            courseService.getCoursesByTeacher(teacher));
        return "teacher/manage-courses";
    }

    // ── Add Course Page ──
    @GetMapping("/courses/add")
    public String addCoursePage(Model model) {
        model.addAttribute("courseDto", new CourseCreateDto());
        model.addAttribute("categories",
            categoryService.getAllCategories());
        return "teacher/add-course";
    }

    // ── Add Course Submit ──
    @PostMapping("/courses/add")
    public String addCourseSubmit(
            @ModelAttribute CourseCreateDto dto,
            @AuthenticationPrincipal UserDetails ud,
            RedirectAttributes redirectAttrs) {

        try {
            Course course = courseService
                .createCourse(dto, ud.getUsername());
            redirectAttrs.addFlashAttribute("successMsg",
                "Course create ho gaya! Modules add karein.");
            return "redirect:/teacher/courses/"
                + course.getId() + "/modules";
        } catch (RuntimeException e) {
            redirectAttrs.addFlashAttribute("errorMsg",
                e.getMessage());
            return "redirect:/teacher/courses/add";
        }
    }

    // ── Edit Course Page ──
    @GetMapping("/courses/{courseId}/edit")
    public String editCoursePage(
            @PathVariable Long courseId,
            @AuthenticationPrincipal UserDetails ud,
            Model model) {

        User teacher = getCurrentUser(ud);
        Course course = courseService.getCourseById(courseId);

        // Apna course hi edit kar sake
        if (!course.getInstructor().getId()
                .equals(teacher.getId())) {
            return "redirect:/teacher/courses";
        }

        model.addAttribute("course", course);
        model.addAttribute("categories",
            categoryService.getAllCategories());
        return "teacher/add-course";
    }

    // ── Edit Course Submit ──
    @PostMapping("/courses/{courseId}/edit")
    public String editCourseSubmit(
            @PathVariable Long courseId,
            @ModelAttribute CourseCreateDto dto,
            @AuthenticationPrincipal UserDetails ud,
            RedirectAttributes redirectAttrs) {

        User teacher = getCurrentUser(ud);
        try {
            courseService.updateCourse(courseId, dto, teacher);
            redirectAttrs.addFlashAttribute("successMsg",
                "Course update ho gaya!");
        } catch (RuntimeException e) {
            redirectAttrs.addFlashAttribute("errorMsg",
                e.getMessage());
        }
        return "redirect:/teacher/courses";
    }

    // ── Toggle Publish ──
    @PostMapping("/courses/{courseId}/toggle-publish")
    public String togglePublish(
            @PathVariable Long courseId,
            RedirectAttributes redirectAttrs) {

        courseService.togglePublish(courseId);
        redirectAttrs.addFlashAttribute("successMsg",
            "Course status update ho gaya!");
        return "redirect:/teacher/courses";
    }

    // ── Delete Course ──
    @PostMapping("/courses/{courseId}/delete")
    public String deleteCourse(
            @PathVariable Long courseId,
            @AuthenticationPrincipal UserDetails ud,
            RedirectAttributes redirectAttrs) {

        User teacher = getCurrentUser(ud);
        try {
            courseService.deleteCourse(courseId, teacher);
            redirectAttrs.addFlashAttribute("successMsg",
                "Course delete ho gaya!");
        } catch (RuntimeException e) {
            redirectAttrs.addFlashAttribute("errorMsg",
                e.getMessage());
        }
        return "redirect:/teacher/courses";
    }

    // ── Modules Page ──
    @GetMapping("/courses/{courseId}/modules")
    public String modulesPage(
            @PathVariable Long courseId,
            Model model) {

        Course course = courseService.getCourseById(courseId);
        List<CourseModule> modules =
            moduleService.getModulesByCourse(courseId);

        model.addAttribute("course", course);
        model.addAttribute("modules", modules);
        return "teacher/add-module-lesson";
    }

    // ── Add Module ──
    @PostMapping("/courses/{courseId}/modules/add")
    public String addModule(
            @PathVariable Long courseId,
            @RequestParam String title,
            RedirectAttributes redirectAttrs) {

        try {
            Course course = courseService.getCourseById(courseId);
            moduleService.addModule(title, course);
            redirectAttrs.addFlashAttribute("successMsg",
                "Module add ho gaya!");
        } catch (RuntimeException e) {
            redirectAttrs.addFlashAttribute("errorMsg",
                e.getMessage());
        }
        return "redirect:/teacher/courses/"
            + courseId + "/modules";
    }

    // ── Add Lesson ──
    @PostMapping("/modules/{moduleId}/lessons/add")
    public String addLesson(
            @PathVariable Long moduleId,
            @RequestParam String title,
            @RequestParam(required = false) String content,
            @RequestParam(required = false) String videoUrl,
            @RequestParam(defaultValue = "0") int orderIndex,
            RedirectAttributes redirectAttrs) {

        CourseModule module =
            moduleService.getModuleById(moduleId);
        try {
            lessonService.addLesson(
                title, content, videoUrl,
                orderIndex, module);
            redirectAttrs.addFlashAttribute("successMsg",
                "Lesson add ho gaya!");
        } catch (RuntimeException e) {
            redirectAttrs.addFlashAttribute("errorMsg",
                e.getMessage());
        }
        return "redirect:/teacher/courses/"
            + module.getCourse().getId() + "/modules";
    }

    // ── Quiz & Assignment Page ──
    @GetMapping("/courses/{courseId}/quiz-assignment")
    public String quizAssignmentPage(
            @PathVariable Long courseId,
            Model model) {

        Course course = courseService.getCourseById(courseId);
        List<CourseModule> modules =
            moduleService.getModulesByCourse(courseId);

        model.addAttribute("course", course);
        model.addAttribute("modules", modules);
        return "teacher/add-quiz-assignment";
    }

    // ── Create Quiz ──
    @PostMapping("/modules/{moduleId}/quiz/add")
    public String createQuiz(
            @PathVariable Long moduleId,
            @RequestParam String title,
            @RequestParam(defaultValue = "60") int passingScore,
            RedirectAttributes redirectAttrs) {

        try {
            Quiz quiz = quizService.createQuiz(
                moduleId, title, passingScore);
            redirectAttrs.addFlashAttribute("successMsg",
                "Quiz create ho gaya! Questions add karein.");
            redirectAttrs.addFlashAttribute("newQuizId",
                quiz.getId());
        } catch (RuntimeException e) {
            redirectAttrs.addFlashAttribute("errorMsg",
                e.getMessage());
        }

        CourseModule module =
            moduleService.getModuleById(moduleId);
        return "redirect:/teacher/courses/"
            + module.getCourse().getId() + "/quiz-assignment";
    }

    // ── Add Quiz Question ──
    @PostMapping("/quiz/{quizId}/question/add")
    public String addQuestion(
            @PathVariable Long quizId,
            @RequestParam String questionText,
            @RequestParam String optionA,
            @RequestParam String optionB,
            @RequestParam(required = false) String optionC,
            @RequestParam(required = false) String optionD,
            @RequestParam String correctAnswer,
            @RequestParam(defaultValue = "1") int marks,
            RedirectAttributes redirectAttrs) {

        try {
            QuizQuestion question = new QuizQuestion();
            question.setQuestionText(questionText);
            question.setOptionA(optionA);
            question.setOptionB(optionB);
            question.setOptionC(optionC);
            question.setOptionD(optionD);
            question.setCorrectAnswer(correctAnswer);
            question.setMarks(marks);

            quizService.addQuestion(quizId, question);
            redirectAttrs.addFlashAttribute("successMsg",
                "Question add ho gaya!");
        } catch (RuntimeException e) {
            redirectAttrs.addFlashAttribute("errorMsg",
                e.getMessage());
        }
        return "redirect:/teacher/quiz/" + quizId + "/questions";
    }

    // ── Quiz Questions Page ──
    @GetMapping("/quiz/{quizId}/questions")
    public String quizQuestionsPage(
            @PathVariable Long quizId,
            Model model) {

        Quiz quiz = quizService.getQuizById(quizId);
        model.addAttribute("quiz", quiz);
        model.addAttribute("questions", quiz.getQuestions());
        return "teacher/add-quiz-assignment";
    }

    // ── Enrolled Students ──
    @GetMapping("/courses/{courseId}/students")
    public String enrolledStudents(
            @PathVariable Long courseId,
            Model model) {

        Course course = courseService.getCourseById(courseId);
        List<Enrollment> enrollments =
            enrollmentService.getCourseEnrollments(course);

        model.addAttribute("course", course);
        model.addAttribute("enrollments", enrollments);
        return "teacher/enrolled-students";
    }

    // ── Earnings Page ──
    @GetMapping("/earnings")
    public String earningsPage(
            @AuthenticationPrincipal UserDetails ud,
            Model model) {

        User teacher = getCurrentUser(ud);
        model.addAttribute("payments",
            paymentService.getTeacherPayments(teacher));
        model.addAttribute("totalEarnings",
            paymentService.getTeacherEarnings(teacher));
        return "teacher/dashboard";
    }
}