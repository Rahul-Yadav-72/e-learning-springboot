package com.elearn.service;

import com.elearn.dto.CourseCreateDto;
import com.elearn.model.Category;
import com.elearn.model.Course;
import com.elearn.model.User;
import com.elearn.model.enums.CourseLevel;
import com.elearn.repository.CategoryRepository;
import com.elearn.repository.CourseRepository;
import com.elearn.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.*;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional
public class CourseService {

    private final CourseRepository courseRepository;
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;

    // ── Create Course ──
    public Course createCourse(CourseCreateDto dto, String instructorEmail) {
        User instructor = userRepository.findByEmail(instructorEmail)
                .orElseThrow(() ->
                        new RuntimeException("Instructor not found"));

        Category category = categoryRepository
                .findById(dto.getCategoryId())
                .orElseThrow(() ->
                        new RuntimeException("Category not found"));

        String thumbnailUrl = null;
        if (dto.getThumbnailFile() != null
                && !dto.getThumbnailFile().isEmpty()) {
            thumbnailUrl = saveFile(dto.getThumbnailFile(), "thumbnails/");
        }

        // new + setters use karo — builder() Lombok issue ke liye
        Course course = new Course();
        course.setTitle(dto.getTitle());
        course.setDescription(dto.getDescription());
        course.setWhatYoullLearn(dto.getWhatYoullLearn());
        course.setPrice(dto.getPrice());
        course.setDiscountPrice(dto.getDiscountPrice());
        course.setLevel(dto.getLevel());
        course.setLanguage(dto.getLanguage());
        course.setThumbnailUrl(thumbnailUrl);
        course.setPreviewVideoUrl(dto.getPreviewVideoUrl());
        course.setInstructor(instructor);
        course.setCategory(category);
        course.setPublished(false);
        course.setApproved(false);

        return courseRepository.save(course);
    }

    // ── Update Course ──
    public Course updateCourse(Long courseId, CourseCreateDto dto) {
        Course course = getCourseById(courseId);

        Category category = categoryRepository
                .findById(dto.getCategoryId())
                .orElseThrow(() ->
                        new RuntimeException("Category not found"));

        if (dto.getThumbnailFile() != null
                && !dto.getThumbnailFile().isEmpty()) {
            course.setThumbnailUrl(
                    saveFile(dto.getThumbnailFile(), "thumbnails/"));
        }

        course.setTitle(dto.getTitle());
        course.setDescription(dto.getDescription());
        course.setWhatYoullLearn(dto.getWhatYoullLearn());
        course.setPrice(dto.getPrice());
        course.setDiscountPrice(dto.getDiscountPrice());
        course.setLevel(dto.getLevel());
        course.setLanguage(dto.getLanguage());
        course.setCategory(category);

        return courseRepository.save(course);
    }

    // ── Toggle Publish ──
    public void togglePublish(Long courseId) {
        Course course = getCourseById(courseId);
        course.setPublished(!course.isPublished());
        courseRepository.save(course);
    }

    // ← TeacherController deleteCourse(Long, User) call karta tha
    public void deleteCourse(Long courseId, User currentUser) {
        Course course = getCourseById(courseId);
        // Sirf apna course delete kar sake teacher
        if (!course.getInstructor().getId()
                .equals(currentUser.getId())) {
            throw new RuntimeException(
                    "Aap sirf apna course delete kar sakte hain");
        }
        courseRepository.deleteById(courseId);
    }

    public void deleteCourse(Long courseId) {
        courseRepository.deleteById(courseId);
    }

    // ← TeacherController getCoursesByTeacher(User) call karta tha
    public List<Course> getCoursesByTeacher(User teacher) {
        return courseRepository.findByInstructor(teacher);
    }

    public List<Course> getCoursesByInstructor(String email) {
        User instructor = userRepository.findByEmail(email)
                .orElseThrow(() ->
                        new RuntimeException("Instructor not found"));
        return courseRepository.findByInstructor(instructor);
    }

    // ── Admin: Approve ──
    public void approveCourse(Long courseId) {
        Course course = getCourseById(courseId);
        course.setApproved(true);
        courseRepository.save(course);
    }

    // ── Read ──
    @Transactional(readOnly = true)
    public Course getCourseById(Long id) {
        return courseRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Course not found: " + id));
    }

    @Transactional(readOnly = true)
    public List<Course> getAllPublishedCourses() {
        return courseRepository.findByPublishedTrueAndApprovedTrue();
    }

    // ← Simple search (Controllers se String only aa raha hai)
    @Transactional(readOnly = true)
    public List<Course> searchCourses(String keyword) {
        return courseRepository.searchCourses(keyword);
    }

    @Transactional(readOnly = true)
    public List<Course> getCoursesByCategory(Long categoryId) {
        return courseRepository
                .findByCategoryIdAndPublishedTrueAndApprovedTrue(categoryId);
    }

    @Transactional(readOnly = true)
    public List<Course> getCoursesByLevel(CourseLevel level) {
        return courseRepository
                .findByLevelAndPublishedTrueAndApprovedTrue(level);
    }

    @Transactional(readOnly = true)
    public List<Course> getTopRatedCourses() {
        return courseRepository.findTopRatedCourses();
    }

    @Transactional(readOnly = true)
    public List<Course> getPendingApprovalCourses() {
        return courseRepository.findByApprovedFalse();
    }
 // CourseService.java mein yeh method add karo
 // updateCourse(Long, CourseCreateDto, User) — teacher check ke saath

 public Course updateCourse(Long courseId,
                             CourseCreateDto dto,
                             User currentUser) {
     Course course = getCourseById(courseId);

     // Sirf apna course edit kar sake
     if (!course.getInstructor().getId()
             .equals(currentUser.getId())) {
         throw new RuntimeException(
             "Aap sirf apna course edit kar sakte hain");
     }

     return updateCourse(courseId, dto); // existing method call
 }

    private String saveFile(MultipartFile file, String subDir) {
        try {
            String uploadDir = "uploads/" + subDir;
            String fileName = UUID.randomUUID()
                    + "_" + file.getOriginalFilename();
            Path filePath = Paths.get(uploadDir + fileName);
            Files.createDirectories(filePath.getParent());
            Files.copy(file.getInputStream(), filePath,
                    StandardCopyOption.REPLACE_EXISTING);
            return "/" + uploadDir + fileName;
        } catch (IOException e) {
            throw new RuntimeException(
                    "File save nahi ho saka: " + e.getMessage());
        }
    }
}