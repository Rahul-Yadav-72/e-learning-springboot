package com.elearn.controller;

import com.elearn.model.Course;
import com.elearn.model.User;
import com.elearn.model.enums.Role;
import com.elearn.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')")
@RequiredArgsConstructor
@Slf4j
public class AdminController {

    private final UserService userService;
    private final CourseService courseService;
    private final PaymentService paymentService;
    private final EnrollmentService enrollmentService;
    private final CategoryService categoryService;

    // ── Admin Dashboard ──
    @GetMapping("/dashboard")
    public String dashboard(@AuthenticationPrincipal UserDetails ud, Model model) {
        log.info("Admin {} accessing dashboard", ud.getUsername());

        model.addAttribute("totalStudents", userService.countByRole(Role.STUDENT));
        model.addAttribute("totalTeachers", userService.countByRole(Role.TEACHER));
        model.addAttribute("totalCourses", courseService.getAllPublishedCourses().size());
        model.addAttribute("pendingCourses", courseService.getPendingApprovalCourses().size());
        
        model.addAttribute("totalRevenue", paymentService.getTotalRevenue());
        model.addAttribute("recentPayments", paymentService.getAllPayments()
                .stream().limit(10).toList());

        return "admin/dashboard";
    }

    // ── Manage Users ──
    @GetMapping("/users")
    public String manageUsers(
            @RequestParam(required = false) String role,
            @RequestParam(required = false) String keyword,
            Model model) {

        List<User> users;
        if (role != null && !role.isBlank()) {
            users = userService.getUsersByRole(Role.valueOf(role.toUpperCase()));
            model.addAttribute("selectedRole", role);
        } else if (keyword != null && !keyword.isBlank()) {
            // Humne UserRepository mein search keyword method banaya tha
            // users = userService.searchUsers(keyword); 
            users = userService.getAllUsers(); // Fallback
        } else {
            users = userService.getAllUsers();
        }

        model.addAttribute("users", users);
        return "admin/manage-users";
    }

    @PostMapping("/users/{userId}/toggle-status")
    public String toggleUserStatus(@PathVariable Long userId, RedirectAttributes ra) {
        userService.toggleUserStatus(userId);
        ra.addFlashAttribute("successMsg", "User status updated successfully!");
        return "redirect:/admin/users";
    }

    @PostMapping("/users/{userId}/delete")
    public String deleteUser(@PathVariable Long userId, RedirectAttributes ra) {
        userService.deleteUser(userId);
        ra.addFlashAttribute("successMsg", "User has been removed from the platform.");
        return "redirect:/admin/users";
    }

    // ── Course Management ──
    @GetMapping("/courses")
    public String manageCourses(@RequestParam(required = false) String filter, Model model) {
        List<Course> courses = "pending".equals(filter) 
                ? courseService.getPendingApprovalCourses() 
                : courseService.getAllPublishedCourses();

        model.addAttribute("courses", courses);
        model.addAttribute("filter", filter);
        return "admin/manage-courses";
    }

    @PostMapping("/courses/{courseId}/approve")
    public String approveCourse(@PathVariable Long courseId, RedirectAttributes ra) {
        courseService.approveCourse(courseId);
        ra.addFlashAttribute("successMsg", "Course has been approved and is now live!");
        return "redirect:/admin/courses?filter=pending";
    }

    // ── Category Management ──
    @GetMapping("/categories")
    public String manageCategories(Model model) {
        model.addAttribute("categories", categoryService.getAllCategories());
        // FIX: Redirecting to the correct view name
        return "admin/manage-categories"; 
    }

    @PostMapping("/categories/add")
    public String addCategory(
            @RequestParam String name,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) String iconClass,
            RedirectAttributes ra) {

        try {
            categoryService.createCategory(name, description, iconClass);
            ra.addFlashAttribute("successMsg", "New category added successfully!");
        } catch (RuntimeException e) {
            ra.addFlashAttribute("errorMsg", "Failed to add category: " + e.getMessage());
        }
        return "redirect:/admin/categories";
    }

    // ── Analytics & Revenue ──
    @GetMapping("/analytics")
    public String analytics(Model model) {
        int currentYear = java.time.LocalDate.now().getYear();

        model.addAttribute("monthlyRevenue", paymentService.getMonthlyRevenue(currentYear));
        model.addAttribute("totalStudents", userService.countByRole(Role.STUDENT));
        model.addAttribute("totalTeachers", userService.countByRole(Role.TEACHER));
        model.addAttribute("totalRevenue", paymentService.getTotalRevenue());
        model.addAttribute("categories", categoryService.getAllCategories());

        return "admin/analytics";
    }
}