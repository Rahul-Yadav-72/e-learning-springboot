package com.elearn.service;

import com.elearn.model.*;
import com.elearn.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class CertificateService {

    private final CertificateRepository certificateRepository;
    private final UserRepository userRepository;
    private final CourseRepository courseRepository;
    private final EmailService emailService;

    @Value("${app.base-url}")
    private String baseUrl;

    public Certificate generateCertificate(Long userId, Long courseId) {
        // 1. Check if certificate already exists
        if (certificateRepository.existsByUserIdAndCourseId(userId, courseId)) {
            return certificateRepository
                    .findByUserIdAndCourseId(userId, courseId)
                    .orElseThrow(() -> new RuntimeException("Certificate not found even after exist check"));
        }

        // 2. Fetch User and Course
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Course not found"));

        // 3. Generate unique certificate number
        String certNumber = generateCertificateNumber();

        // 4. Create and Save Certificate
        Certificate cert = new Certificate();
        cert.setUser(user);
        cert.setCourse(course);
        cert.setCertificateNumber(certNumber);
        cert.setIssuedAt(LocalDateTime.now());

        certificateRepository.save(cert);

        // 5. Send Professional Email with Full URL
        String fullCertificateUrl = baseUrl + "/certificates/" + certNumber;
        
        // FIX: Removed the trailing comma after fullCertificateUrl
        emailService.sendCertificateEmail(
                user.getEmail(),
                user.getFullName(),
                course.getTitle(),
                fullCertificateUrl
        );

        return cert;
    }

    @Transactional(readOnly = true)
    public List<Certificate> getCertificatesByUser(User user) {
        return certificateRepository.findByUserId(user.getId());
    }

    @Transactional(readOnly = true)
    public List<Certificate> getUserCertificates(Long userId) {
        return certificateRepository.findByUserId(userId);
    }

    @Transactional(readOnly = true)
    public Optional<Certificate> verifyCertificate(String certNumber) {
        return certificateRepository.findByCertificateNumber(certNumber);
    }

    private String generateCertificateNumber() {
        String year = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy"));
        // Using last few digits of current time for uniqueness
        String unique = String.valueOf(System.currentTimeMillis()).substring(8);
        return "CERT-" + year + "-" + unique;
    }
}