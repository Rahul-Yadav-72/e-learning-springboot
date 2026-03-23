package com.elearn.service;

import com.elearn.dto.LessonDto;
import com.elearn.model.CourseModule;
import com.elearn.model.Lesson;
import com.elearn.repository.LessonRepository;
import com.elearn.repository.ModuleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.*;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional
public class LessonService {

    private final LessonRepository lessonRepository;
    private final ModuleRepository moduleRepository;

    public Lesson createLesson(LessonDto dto) {
        CourseModule module = moduleRepository
                .findById(dto.getModuleId())
                .orElseThrow(() ->
                        new RuntimeException("Module not found"));

        String resourceUrl = null;
        if (dto.getResourceFile() != null
                && !dto.getResourceFile().isEmpty()) {
            resourceUrl = saveFile(dto.getResourceFile());
        }

        Lesson lesson = new Lesson();
        lesson.setTitle(dto.getTitle());
        lesson.setContent(dto.getContent());
        lesson.setVideoUrl(dto.getVideoUrl());
        lesson.setResourceUrl(resourceUrl);
        lesson.setDurationMinutes(dto.getDurationMinutes());
        lesson.setOrderIndex(dto.getOrderIndex() != null
                ? dto.getOrderIndex() : 0);
        lesson.setFreePreview(dto.isFreePreview());
        lesson.setModule(module);

        return lessonRepository.save(lesson);
    }

    // ← TeacherController addLesson(String, String, String, int, CourseModule)
    public Lesson addLesson(String title, String content,
                             String videoUrl, int orderIndex,
                             CourseModule module) {
        Lesson lesson = new Lesson();
        lesson.setTitle(title);
        lesson.setContent(content);
        lesson.setVideoUrl(videoUrl);
        lesson.setOrderIndex(orderIndex);
        lesson.setModule(module);
        return lessonRepository.save(lesson);
    }

    public void deleteLesson(Long id) {
        lessonRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public Lesson getLessonById(Long id) {
        return lessonRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Lesson not found: " + id));
    }

    @Transactional(readOnly = true)
    public List<Lesson> getLessonsByModule(Long moduleId) {
        return lessonRepository
                .findByModuleIdOrderByOrderIndexAsc(moduleId);
    }

    @Transactional(readOnly = true)
    public List<Lesson> getAllLessonsByCourse(Long courseId) {
        return lessonRepository.findAllByCourseId(courseId);
    }

    private String saveFile(MultipartFile file) {
        try {
            String dir = "uploads/resources/";
            String fileName = UUID.randomUUID()
                    + "_" + file.getOriginalFilename();
            Path path = Paths.get(dir + fileName);
            Files.createDirectories(path.getParent());
            Files.copy(file.getInputStream(), path,
                    StandardCopyOption.REPLACE_EXISTING);
            return "/" + dir + fileName;
        } catch (IOException e) {
            throw new RuntimeException("File save nahi ho saka");
        }
    }
}