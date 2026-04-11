package com.elearn.controller;

import com.elearn.model.*;
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

import java.math.BigDecimal;
import java.security.Principal;
import java.util.Collections;
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
    private final CategoryService categoryService;
    private final ReviewService reviewService;
    private final SupportTicketService supportTicketService;
    private final PayoutService payoutService;

    // ── Global Attributes ──
    @ModelAttribute
    public void addGlobalAttributes(Model model, @AuthenticationPrincipal UserDetails ud) {
        if (ud != null) {
            User admin = userService.getUserByEmail(ud.getUsername());
            model.addAttribute("admin", admin);
        }
    }

    // ── 1. Admin Dashboard ──
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("totalUsers", userService.getAllUsers().size());
        model.addAttribute("totalCourses", courseService.getAllPublishedCourses().size());
        model.addAttribute("platformRevenue", paymentService.getTotalPlatformRevenue());
        model.addAttribute("pendingPayouts", payoutService.getPendingPayoutsCount());

        List<User> allUsers = userService.getAllUsers();
        Collections.reverse(allUsers);
        model.addAttribute("recentUsers", allUsers.stream().limit(5).toList());
        
        model.addAttribute("pageTitle", "Admin Dashboard");
        return "admin/dashboard";
    }

    // ── 2. User Management ──
    @GetMapping("/manage-users") 
    public String manageUsers(@RequestParam(required = false) String role, Model model) {
        List<User> users = (role != null && !role.isBlank()) ? 
                          userService.getUsersByRole(Role.valueOf(role.toUpperCase())) : 
                          userService.getAllUsers();
        model.addAttribute("users", users);
        model.addAttribute("selectedRole", role);
        return "admin/manage-users";
    }

 // ── Fixed User Toggle Status Mapping (Just in case) ──
    @PostMapping("/users/{userId}/toggle-status")
    public String toggleUserStatus(@PathVariable Long userId, RedirectAttributes ra) {
        userService.toggleUserStatus(userId);
        ra.addFlashAttribute("successMsg", "User access updated!");
        return "redirect:/admin/manage-users";
    }
 // ── Fixed User Delete Mapping ──
    // Mapping matches: /admin/users/{userId}/delete
    @PostMapping("/users/{userId}/delete")
    public String deleteUser(@PathVariable Long userId, RedirectAttributes ra) {
        userService.deleteUser(userId);
        ra.addFlashAttribute("successMsg", "User removed from platform.");
        return "redirect:/admin/manage-users";
    }

    // ── 3. Category Management ──
    @GetMapping("/manage-categories") 
    public String manageCategories(Model model) {
        model.addAttribute("categories", categoryService.getAllCategories());
        return "admin/manage-categories"; 
    }

    @PostMapping("/categories/add")
    public String addCategory(@RequestParam String name, @RequestParam String description, RedirectAttributes ra) {
        categoryService.createCategory(name, description, null);
        ra.addFlashAttribute("successMsg", "Category created!");
        return "redirect:/admin/manage-categories";
    }

    @PostMapping("/categories/update/{id}")
    public String updateCategory(@PathVariable Long id, @RequestParam String name, @RequestParam String description, RedirectAttributes ra) {
        categoryService.updateCategory(id, name, description);
        ra.addFlashAttribute("successMsg", "Category updated!");
        return "redirect:/admin/manage-categories";
    }

    @PostMapping("/categories/delete/{id}")
    public String deleteCategory(@PathVariable Long id, RedirectAttributes ra) {
        try {
            categoryService.deleteCategory(id);
            ra.addFlashAttribute("successMsg", "Category deleted!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Conflict: Category linked to courses.");
        }
        return "redirect:/admin/manage-categories";
    }

    // ── 4. Course Control ──
    @GetMapping("/manage-courses")
    public String manageCourses(@RequestParam(required = false) String filter, Model model) {
        List<Course> courses = "pending".equals(filter) ? 
                              courseService.getPendingApprovalCourses() : 
                              courseService.getAllPublishedCourses();
        model.addAttribute("courses", courses);
        model.addAttribute("filter", filter);
        return "admin/manage-courses"; 
    }

 // ── Fixed Course Approve Mapping ──
    
    // Mapping matches: /admin/courses/{courseId}/approve
    @PostMapping("/courses/{courseId}/approve")
    public String approveCourse(@PathVariable Long courseId, RedirectAttributes ra) {
        courseService.approveCourse(courseId);
        ra.addFlashAttribute("successMsg", "Course is now LIVE!");
        return "redirect:/admin/manage-courses?filter=pending";
    }

    @PostMapping("/courses/delete/{courseId}")
    public String deleteCourse(@PathVariable Long courseId, RedirectAttributes ra) {
        courseService.deleteCourse(courseId);
        ra.addFlashAttribute("successMsg", "Course removed.");
        return "redirect:/admin/manage-courses";
    }
    

    // ── 5. Payouts, Reviews & Support ──
//    @GetMapping("/payout-requests")
//    public String payoutRequests(Model model) {
//        model.addAttribute("payoutRequests", payoutService.getAllRequests());
//        return "admin/payout-requests"; // <-- Ye line JSP file dhoondh rahi hai
//    }
    @GetMapping("/payout-requests")
    public String payoutRequests(Model model) {
        List<PayoutRequest> requests = payoutService.getAllRequests();
        
        // Debugging ke liye: Console mein check karein data aa raha hai ya nahi
        System.out.println("Total Payout Requests: " + requests.size());
        
        model.addAttribute("payoutRequests", requests);
        return "admin/payout-requests"; // Match with: /WEB-INF/views/admin/payout-requests.jsp
    }

    @PostMapping("/payouts/{id}/approve") // ID ko beech mein rakhein
    public String approvePayout(@PathVariable Long id, RedirectAttributes ra) {
        payoutService.approvePayout(id);
        ra.addFlashAttribute("successMsg", "Payout marked as PAID.");
        return "redirect:/admin/payout-requests";
    }

    /** ✅ FIX: manage-reviews mapping added to resolve 404 */
    @GetMapping("/manage-reviews")
    public String manageReviews(Model model) {
        model.addAttribute("reviews", reviewService.getAllReviews());
        return "admin/manage-reviews";
    }

    @GetMapping("/support-tickets")
    public String supportTickets(Model model) {
        model.addAttribute("tickets", supportTicketService.getAllTickets());
        return "admin/support-tickets";
    }

    @PostMapping("/support-tickets/resolve/{id}")
    public String resolveTicket(@PathVariable Long id, RedirectAttributes ra) {
        supportTicketService.resolveTicket(id);
        ra.addFlashAttribute("successMsg", "Ticket resolved!");
        return "redirect:/admin/support-tickets";
    }

    // ── 6. Profile, Payments & Settings ──
    @GetMapping("/manage-payments")
    public String managePayments(Model model) {
        model.addAttribute("payments", paymentService.getAllPayments());
        return "admin/manage-payments";
    }

    /** ✅ FIX: settings mapping added to resolve 404 */
    @GetMapping("/settings")
    public String settings(Model model) {
        model.addAttribute("pageTitle", "Platform Settings");
        return "admin/settings";
    }

    @GetMapping("/profile")
    public String showAdminProfile(Model model, Principal principal) {
        User admin = userService.getUserByEmail(principal.getName());
        model.addAttribute("user", admin);
        return "common/profile"; 
    }
    
}