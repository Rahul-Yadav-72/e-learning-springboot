package com.elearn.service;

import com.elearn.model.Assignment;
import com.elearn.model.QuizQuestion;
import com.elearn.repository.AssignmentRepository;
import com.elearn.repository.QuizQuestionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class QuizService {

    @Autowired
    private QuizQuestionRepository quizRepo;

    @Autowired
    private AssignmentRepository assignmentRepo;

    // 1. Assignment id se saare questions nikalne ke liye
    public List<QuizQuestion> getQuestionsByAssignment(Long assignmentId) {
        return quizRepo.findByAssignmentId(assignmentId);
    }

    public QuizQuestion getQuestionById(Long questionId) {
        return quizRepo.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Question not found"));
    }

    // 2. Naya question directly database mein save karne ke liye
    public void addQuestion(Long assignmentId, String text, String a, String b, String c, String d, String correct, Integer marks) {
        Assignment assignment = assignmentRepo.findById(assignmentId)
                .orElseThrow(() -> new RuntimeException("Assignment not found"));
        
        QuizQuestion q = QuizQuestion.builder()
                .assignment(assignment)
                .questionText(text)
                .optionA(a)
                .optionB(b)
                .optionC(c)
                .optionD(d)
                .correctOption(correct)
                .marks(marks)
                .build();
        
        quizRepo.save(q);
    }

    // 3. Question delete karne ke liye
    public void deleteQuestion(Long questionId) {
        quizRepo.deleteById(questionId);
    }

    public void updateQuestion(Long questionId, String text, String a, String b, String c, String d, String correct, Integer marks) {
        QuizQuestion q = getQuestionById(questionId);
        q.setQuestionText(text);
        q.setOptionA(a);
        q.setOptionB(b);
        q.setOptionC(c);
        q.setOptionD(d);
        q.setCorrectOption(correct);
        q.setMarks(marks);
        quizRepo.save(q);
    }
}
