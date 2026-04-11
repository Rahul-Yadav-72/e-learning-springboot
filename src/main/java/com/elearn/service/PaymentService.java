package com.elearn.service;

import com.elearn.dto.PaymentDto;
import com.elearn.model.*;
import com.elearn.model.enums.PaymentStatus;
import com.elearn.model.enums.PayoutStatus;
import com.elearn.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final CourseRepository courseRepository;
    private final UserRepository userRepository;
    private final EnrollmentService enrollmentService;
    private final PayoutRequestRepository payoutRepository;

    /**
     * Student ke liye payment process initiate karna (Checkout ke waqt)
     */
    public Payment initiatePayment(Long courseId, String userEmail) {
        log.info("Initiating payment for User: {} and Course: {}", userEmail, courseId);
        
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Course not found"));

        BigDecimal amount = course.getDiscountPrice() != null 
                ? course.getDiscountPrice() : course.getPrice();

        Payment payment = new Payment();
        payment.setUser(user);
        payment.setCourse(course);
        payment.setAmount(amount);
        payment.setStatus(PaymentStatus.PENDING);

        return paymentRepository.save(payment);
    }

    /**
     * Razorpay se confirmation milne par payment aur payout process karna
     */
    public Payment confirmPayment(PaymentDto dto, String userEmail) {
        log.info("Confirming payment from Razorpay for User: {}", userEmail);
        
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Course course = courseRepository.findById(dto.getCourseId())
                .orElseThrow(() -> new RuntimeException("Course not found"));

        // 1. Payment record fetch karna ya naya banana
        Payment payment = paymentRepository
                .findByUserAndCourseIdAndStatus(user, dto.getCourseId(), PaymentStatus.PENDING)
                .orElseGet(() -> {
                    Payment p = new Payment();
                    p.setUser(user);
                    p.setCourse(course);
                    p.setAmount(dto.getAmount());
                    return p;
                });

        // 2. Payment status success mark karna
        payment.setTransactionId(dto.getRazorpayPaymentId());
        payment.setPaymentMethod("RAZORPAY");
        payment.setStatus(PaymentStatus.COMPLETED);
        paymentRepository.save(payment);

        // 3. ✅ TEACHER PAYOUT LOGIC: (Mapped to 'instructor' as per User Model)

        BigDecimal totalAmount = payment.getAmount();
        BigDecimal teacherShare = totalAmount.multiply(new BigDecimal("0.8")); 

        PayoutRequest payout = new PayoutRequest();
        payout.setTeacher(course.getInstructor()); // Model: coursesTaught mapped by instructor
        payout.setAmount(teacherShare);
        payout.setStatus(PayoutStatus.PENDING); 
        
        // Agar PayoutRequest model update ho gaya hai, toh ye line ab chalegi:
        payout.setCourse(course); 
        
        payoutRepository.save(payout);

        // 4. Student enrollment process
        enrollmentService.enrollStudent(user.getId(), dto.getCourseId());
        log.info("User {} successfully enrolled in Course {}", userEmail, course.getTitle());

        return payment;
    }
 // PaymentService.java ke andar ye method add karein
    public Payment processPayment(User user, PaymentDto dto) {
        return confirmPayment(dto, user.getEmail());
    }

    /**
     * Free course ke liye direct enrollment
     */
    public void enrollFree(Long courseId, String userEmail) {
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Course not found"));
                
        if (course.getPrice().compareTo(BigDecimal.ZERO) != 0) {
            throw new RuntimeException("This course is not free!");
        }
        
        enrollmentService.enrollStudent(user.getId(), courseId);
    }

    // --- Analytics & Admin Methods ---

    @Transactional(readOnly = true)
    public List<Payment> getTeacherPayments(User teacher) {
        return paymentRepository.findByTeacherId(teacher.getId());
    }

    @Transactional(readOnly = true)
    public BigDecimal getTeacherEarnings(User teacher) {
        BigDecimal earnings = paymentRepository.calculateRevenueByTeacher(teacher.getId());
        return earnings != null ? earnings : BigDecimal.ZERO;
    }

    @Transactional(readOnly = true)
    public List<Payment> getAllPayments() {
        return paymentRepository.findAll();
    }

    @Transactional(readOnly = true)
    public BigDecimal getTotalPlatformRevenue() {
        BigDecimal revenue = paymentRepository.calculateTotalRevenue();
        return revenue != null ? revenue : BigDecimal.ZERO;
    }

    @Transactional(readOnly = true)
    public List<Object[]> getMonthlyRevenue(int year) {
        return paymentRepository.getMonthlyRevenue(year);
    }
}