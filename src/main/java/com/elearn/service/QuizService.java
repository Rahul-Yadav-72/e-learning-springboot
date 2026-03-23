package com.elearn.service;

import com.elearn.dto.QuizDto;
import com.elearn.dto.QuizSubmitDto;
import com.elearn.model.*;
import com.elearn.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional
public class QuizService {

    private final QuizRepository quizRepository;
    private final QuizQuestionRepository questionRepository;
    private final QuizResultRepository quizResultRepository;
    private final ModuleRepository moduleRepository;
    private final UserRepository userRepository;

    public Quiz createQuiz(QuizDto dto) {
        CourseModule module = moduleRepository
                .findById(dto.getModuleId())
                .orElseThrow(() ->
                        new RuntimeException("Module not found"));

        Quiz quiz = new Quiz();
        quiz.setTitle(dto.getTitle());
        quiz.setPassingScore(dto.getPassingScore());
        quiz.setModule(module);
        quizRepository.save(quiz);

        for (QuizDto.QuestionDto qDto : dto.getQuestions()) {
            QuizQuestion q = new QuizQuestion();
            q.setQuestionText(qDto.getQuestionText());
            q.setOptionA(qDto.getOptionA());
            q.setOptionB(qDto.getOptionB());
            q.setOptionC(qDto.getOptionC());
            q.setOptionD(qDto.getOptionD());
            q.setCorrectAnswer(qDto.getCorrectAnswer());
            q.setMarks(qDto.getMarks());
            q.setQuiz(quiz);
            quiz.getQuestions().add(q);
        }

        return quizRepository.save(quiz);
    }

    // ← TeacherController createQuiz(Long, String, int) call karta tha
    public Quiz createQuiz(Long moduleId, String title,
                           int passingScore) {
        CourseModule module = moduleRepository.findById(moduleId)
                .orElseThrow(() ->
                        new RuntimeException("Module not found"));
        Quiz quiz = new Quiz();
        quiz.setTitle(title);
        quiz.setPassingScore(passingScore);
        quiz.setModule(module);
        return quizRepository.save(quiz);
    }

    // ← TeacherController addQuestion(Long, QuizQuestion) call karta tha
    public QuizQuestion addQuestion(Long quizId,
                                    QuizQuestion question) {
        Quiz quiz = getQuizById(quizId);
        question.setQuiz(quiz);
        return questionRepository.save(question);
    }

    // ← StudentController submitQuiz(User, QuizSubmitDto) call karta tha
    public QuizResult submitQuiz(User student, QuizSubmitDto dto) {
        return submitQuiz(dto, student.getEmail());
    }

    public QuizResult submitQuiz(QuizSubmitDto dto,
                                  String studentEmail) {
        Quiz quiz = quizRepository.findById(dto.getQuizId())
                .orElseThrow(() ->
                        new RuntimeException("Quiz not found"));
        User student = userRepository.findByEmail(studentEmail)
                .orElseThrow(() ->
                        new RuntimeException("Student not found"));

        if (quizResultRepository.existsByQuizIdAndStudentId(
                quiz.getId(), student.getId())) {
            throw new RuntimeException(
                    "Quiz already attempt kar chuke hain");
        }

        List<QuizQuestion> questions = quiz.getQuestions();
        Map<Long, String> answers = dto.getAnswers();

        int score = 0, totalMarks = 0;
        for (QuizQuestion q : questions) {
            totalMarks += q.getMarks();
            String submitted = answers.get(q.getId());
            if (submitted != null
                    && submitted.equalsIgnoreCase(
                            q.getCorrectAnswer())) {
                score += q.getMarks();
            }
        }

        int percentage = totalMarks > 0
                ? (score * 100) / totalMarks : 0;

        QuizResult result = new QuizResult();
        result.setQuiz(quiz);
        result.setStudent(student);
        result.setScore(score);
        result.setTotalMarks(totalMarks);
        result.setPercentage(percentage);
        result.setPassed(percentage >= quiz.getPassingScore());

        return quizResultRepository.save(result);
    }

    // ← StudentController getStudentResults(User) call karta tha
    public List<QuizResult> getStudentResults(User student) {
        return quizResultRepository.findByStudentId(student.getId());
    }

    // ← TeacherController getQuizByModule(CourseModule) call karta tha
    public List<Quiz> getQuizByModule(CourseModule module) {
        return quizRepository.findByModuleId(module.getId());
    }

    @Transactional(readOnly = true)
    public Quiz getQuizById(Long id) {
        return quizRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Quiz not found"));
    }

    @Transactional(readOnly = true)
    public List<Quiz> getQuizzesByModule(Long moduleId) {
        return quizRepository.findByModuleId(moduleId);
    }
}