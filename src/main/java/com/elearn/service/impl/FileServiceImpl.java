package com.elearn.service.impl;
import com.elearn.service.FileService;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class FileServiceImpl implements FileService {
    private final String UPLOAD_DIR = "src/main/resources/static/uploads/";

    @Override
    public String uploadFile(MultipartFile file) {
        try {
            File folder = new File(UPLOAD_DIR);
            if (!folder.exists()) folder.mkdirs();

            String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
            Files.copy(file.getInputStream(), Paths.get(UPLOAD_DIR + fileName));
            return "/uploads/" + fileName;
        } catch (Exception e) {
            throw new RuntimeException("Upload failed", e);
        }
    }
}