package com.elearn.service;

import com.elearn.dto.PaymentDto;
import com.elearn.model.*;
import com.elearn.model.enums.PaymentStatus;
import com.elearn.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final CourseRepository courseRepository;
    private final UserRepository userRepository;
    private final EnrollmentService enrollmentService;

    public Payment initiatePayment(Long courseId, String userEmail) {
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() ->
                        new RuntimeException("User not found"));
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() ->
                        new RuntimeException("Course not found"));

        BigDecimal amount = course.getDiscountPrice() != null
                ? course.getDiscountPrice() : course.getPrice();

        Payment payment = new Payment();
        payment.setUser(user);
        payment.setCourse(course);
        payment.setAmount(amount);
        payment.setStatus(PaymentStatus.PENDING);

        return paymentRepository.save(payment);
    }

    // ← StudentController processPayment(User, PaymentDto) call karta tha
    public Payment processPayment(User user, PaymentDto dto) {
        return confirmPayment(dto, user.getEmail());
    }

    public Payment confirmPayment(PaymentDto dto, String userEmail) {
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() ->
                        new RuntimeException("User not found"));
        Course course = courseRepository
                .findById(dto.getCourseId())
                .orElseThrow(() ->
                        new RuntimeException("Course not found"));

        Payment payment = paymentRepository
                .findByUserAndCourseIdAndStatus(
                        user, dto.getCourseId(),
                        PaymentStatus.PENDING)
                .orElseGet(() -> {
                    Payment p = new Payment();
                    p.setUser(user);
                    p.setCourse(course);
                    p.setAmount(dto.getAmount());
                    return p;
                });

        payment.setTransactionId(dto.getRazorpayPaymentId());
        payment.setPaymentMethod("RAZORPAY");
        payment.setStatus(PaymentStatus.COMPLETED);
        paymentRepository.save(payment);

        enrollmentService.enrollStudent(
                user.getId(), dto.getCourseId());

        return payment;
    }

    public void enrollFree(Long courseId, String userEmail) {
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() ->
                        new RuntimeException("User not found"));
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() ->
                        new RuntimeException("Course not found"));
        if (course.getPrice().compareTo(BigDecimal.ZERO) != 0) {
            throw new RuntimeException("Yeh course free nahi hai");
        }
        enrollmentService.enrollStudent(user.getId(), courseId);
    }

    // ← TeacherController getTeacherPayments(User) call karta tha
    public List<Payment> getTeacherPayments(User teacher) {
        return paymentRepository.findByTeacherId(teacher.getId());
    }

    // ← TeacherController getTeacherEarnings(User) call karta tha
    public BigDecimal getTeacherEarnings(User teacher) {
        BigDecimal earnings = paymentRepository
                .calculateRevenueByTeacher(teacher.getId());
        return earnings != null ? earnings : BigDecimal.ZERO;
    }

    @Transactional(readOnly = true)
    public List<Payment> getAllPayments() {
        return paymentRepository.findAll();
    }

    @Transactional(readOnly = true)
    public BigDecimal getTotalRevenue() {
        BigDecimal revenue = paymentRepository.calculateTotalRevenue();
        return revenue != null ? revenue : BigDecimal.ZERO;
    }

    @Transactional(readOnly = true)
    public List<Object[]> getMonthlyRevenue(int year) {
        return paymentRepository.getMonthlyRevenue(year);
    }
}