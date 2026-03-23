package com.elearn.repository;

import com.elearn.model.Certificate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CertificateRepository extends JpaRepository<Certificate, Long> {

    List<Certificate> findByUserId(Long userId);         // ← findByUser fix

    Optional<Certificate> findByUserIdAndCourseId(
            Long userId, Long courseId);                  // ← findByUserAndCourse fix

    Optional<Certificate> findByCertificateNumber(String certificateNumber);

    boolean existsByUserIdAndCourseId(
            Long userId, Long courseId);                  // ← existsByUserAndCourse fix
}