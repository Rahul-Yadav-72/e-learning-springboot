package com.elearn.service;   // ← FIXED: repository tha, service kiya

import com.elearn.dto.ModuleDto;
import com.elearn.model.Course;
import com.elearn.model.CourseModule;
import com.elearn.repository.CourseRepository;
import com.elearn.repository.ModuleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ModuleService {

    private final ModuleRepository moduleRepository;
    private final CourseRepository courseRepository;

    public CourseModule createModule(ModuleDto dto) {
        Course course = courseRepository.findById(dto.getCourseId())
                .orElseThrow(() -> new RuntimeException(
                        "Course not found: " + dto.getCourseId()));

        CourseModule module = new CourseModule();
        module.setTitle(dto.getTitle());
        module.setDescription(dto.getDescription());
        module.setOrderIndex(dto.getOrderIndex() != null
                ? dto.getOrderIndex() : 0);
        module.setCourse(course);

        return moduleRepository.save(module);
    }

    // ← TeacherController addModule(String, Course) call karta tha
    public CourseModule addModule(String title, Course course) {
        CourseModule module = new CourseModule();
        module.setTitle(title);
        module.setOrderIndex(
            (int) moduleRepository.countByCourseId(course.getId()));
        module.setCourse(course);
        return moduleRepository.save(module);
    }

    public CourseModule updateModule(Long id, ModuleDto dto) {
        CourseModule module = getModuleById(id);
        module.setTitle(dto.getTitle());
        module.setDescription(dto.getDescription());
        if (dto.getOrderIndex() != null) {
            module.setOrderIndex(dto.getOrderIndex());
        }
        return moduleRepository.save(module);
    }

    public void deleteModule(Long id) {
        moduleRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public CourseModule getModuleById(Long id) {
        return moduleRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Module not found: " + id));
    }

    @Transactional(readOnly = true)
    public List<CourseModule> getModulesByCourse(Long courseId) {
        return moduleRepository
                .findByCourseIdOrderByOrderIndexAsc(courseId);
    }
}