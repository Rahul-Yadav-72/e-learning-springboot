package com.elearn.controller;

import com.elearn.dto.UserRegistrationDto;
import com.elearn.model.User;
import com.elearn.service.UserService;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/auth")
public class AuthController {

    private final UserService userService;

    // Manual Constructor to solve Syntax/Lombok errors
    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/login")
    public String loginPage(@RequestParam(required = false) String error,
                            @RequestParam(required = false) String logout,
                            Model model) {
        if (error != null) model.addAttribute("errorMsg", "Invalid email or password!");
        if (logout != null) model.addAttribute("successMsg", "Logged out successfully!");
        return "auth/login";
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("user", new UserRegistrationDto());
        return "auth/register";
    }

    @PostMapping("/register")
    public String registerSubmit(@Valid @ModelAttribute("user") UserRegistrationDto dto,
                                 BindingResult result, RedirectAttributes ra, Model model) {
        if (result.hasErrors()) return "auth/register";
        try {
            User user = userService.registerUser(dto);
            return "redirect:/auth/verify-otp?email=" + user.getEmail();
        } catch (Exception e) {
            model.addAttribute("errorMsg", e.getMessage());
            return "auth/register";
        }
    }

    @GetMapping("/verify-otp")
    public String showVerifyOtpPage(@RequestParam String email, Model model) {
        model.addAttribute("email", email);
        return "auth/verify-otp";
    }

    @PostMapping("/verify-otp")
    public String verifyOtp(@RequestParam String email, @RequestParam String otp, RedirectAttributes ra) {
        try {
            userService.verifyOtp(email, otp);
            ra.addFlashAttribute("successMsg", "Verified! Please login.");
            return "redirect:/auth/login";
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", e.getMessage());
            return "redirect:/auth/verify-otp?email=" + email;
        }
    }
}