package com.elearn.test.AuthController;

import com.elearn.model.User;
import com.elearn.service.UserService;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserService userService;

    // ✅ Test 1: Login Page Loading (Bilkul Sahi Hai)
    @Test
    public void testShowLoginPage() throws Exception {
        mockMvc.perform(get("/auth/login"))
                .andExpect(status().isOk())
                .andExpect(view().name("auth/login"));
    }

    // ✅ Test 2: User Registration Success (Fixed URL and Redirect)

    @Test
    public void testUserRegistrationSuccess() throws Exception {
        User mockUser = new User();
        mockUser.setEmail("rahul@test.com");
        Mockito.when(userService.registerUser(Mockito.any())).thenReturn(mockUser);

        mockMvc.perform(post("/auth/register").with(csrf())
                .param("fullName", "Rahul Yadav")
                .param("email", "rahul@test.com")
                .param("password", "123456")
                .param("confirmPassword", "123456") // Ye line add karein
                .param("role", "STUDENT"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/verify-otp?email=rahul@test.com"));
    }

    // ✅ Test 3: Login Failure (Security Mapping)
    @Test
    public void testLoginFailure() throws Exception {
        mockMvc.perform(post("/login").with(csrf()) // '/auth/login' ko '/login' karein
                .param("username", "wrong@user.com")
                .param("password", "wrongpass"))
                .andExpect(status().is3xxRedirection());
    }
}