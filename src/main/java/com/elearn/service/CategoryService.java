package com.elearn.service;

import com.elearn.model.Category;
import com.elearn.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class CategoryService {

    private final CategoryRepository categoryRepository;

    @Transactional(readOnly = true)
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Category getCategoryById(Long id) {
        return categoryRepository.findById(id)
                .orElseThrow(() ->
                    new RuntimeException("Category not found: " + id));
    }

    public Category createCategory(String name,
                                   String description,
                                   String iconClass) {
        if (categoryRepository.existsByName(name)) {
            throw new RuntimeException("Category already exists: " + name);
        }
        Category cat = Category.builder()
                .name(name)
                .description(description)
                .iconClass(iconClass)
                .build();
        return categoryRepository.save(cat);
    }

    public void deleteCategory(Long id) {
        categoryRepository.deleteById(id);
    }
}