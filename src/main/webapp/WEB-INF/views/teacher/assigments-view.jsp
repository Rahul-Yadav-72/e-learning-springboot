<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assessment View | E-Learn Instructor</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-dark: #090e1a;
            --surface: #111827;
            --primary: #4e73df;
            --border: rgba(255,255,255,0.08);
            --text-dim: #94a3b8;
        }

        body { background: var(--bg-dark); color: white; font-family: 'Plus Jakarta Sans', sans-serif; margin: 0; }
        .portal-nav { background: rgba(9, 14, 26, 0.8); backdrop-filter: blur(10px); padding: 15px 40px; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 1000; }
        .page-shell { padding: 32px; }
        .panel { background: var(--surface); border: 1px solid var(--border); border-radius: 24px; padding: 28px; }
        .meta-pill { display: inline-flex; align-items: center; gap: 8px; padding: 8px 14px; border-radius: 999px; background: rgba(78,115,223,0.12); color: #9db6ff; font-weight: 700; font-size: 0.8rem; }
        .question-card, .submission-card { background: rgba(255,255,255,0.03); border: 1px solid var(--border); border-radius: 18px; padding: 18px; }
        .opt-badge { background: rgba(255,255,255,0.05); padding: 8px 12px; border-radius: 10px; border: 1px solid var(--border); font-size: 0.85rem; }
        .opt-badge.correct { border-color: rgba(16,185,129,0.45); color: #6ee7b7; background: rgba(16,185,129,0.1); }
    </style>
</head>
<body>
<nav class="portal-nav d-flex justify-content-between align-items-center">
    <div class="d-flex align-items-center gap-2" onclick="location.href='${pageContext.request.contextPath}/go-home'" style="cursor:pointer;">
        <div class="bg-primary p-2 rounded-3 text-white"><i class="fa-solid fa-graduation-cap"></i></div>
        <h4 class="m-0 fw-bold">E-Learn</h4>
    </div>
</nav>

<div class="page-shell">
    <div class="panel mb-4">
        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
            <div>
                <div class="meta-pill mb-3">
                    <i class="fa-solid ${assignment.type == 'QUIZ' ? 'fa-bolt' : 'fa-file-signature'}"></i>
                    <span><c:out value="${assignment.type}"/></span>
                </div>
                <h2 class="fw-bold mb-2"><c:out value="${assignment.title}"/></h2>
                <p class="text-secondary-emphasis mb-2" style="color: var(--text-dim) !important;"><c:out value="${assignment.module.course.title}"/> / <c:out value="${assignment.module.title}"/></p>
                <p class="mb-0" style="color: var(--text-dim);"><c:out value="${assignment.description}" default="No description added."/></p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/teacher/courses/${assignment.module.course.id}/modules" class="btn btn-outline-light rounded-pill px-4">
                    <i class="fa-solid fa-arrow-left me-2"></i>Back to Course
                </a>
                <a href="${pageContext.request.contextPath}/teacher/assignments/${assignment.id}/review" class="btn btn-outline-warning rounded-pill px-4">
                    <i class="fa-solid fa-clipboard-check me-2"></i>Review Submissions
                </a>
                <c:if test="${assignment.type == 'QUIZ'}">
                    <a href="${pageContext.request.contextPath}/teacher/assignments/${assignment.id}/questions" class="btn btn-primary rounded-pill px-4">
                        <i class="fa-solid fa-list-check me-2"></i>Manage Questions
                    </a>
                </c:if>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-7">
            <div class="panel">
                <h4 class="fw-bold mb-4">${assignment.type == 'QUIZ' ? 'Questions' : 'Assessment Details'}</h4>

                <c:choose>
                    <c:when test="${assignment.type == 'QUIZ' && not empty questions}">
                        <div class="d-flex flex-column gap-3">
                            <c:forEach var="q" items="${questions}" varStatus="loop">
                                <div class="question-card">
                                    <div class="fw-bold mb-3">Q${loop.index + 1}. <c:out value="${q.questionText}"/></div>
                                    <div class="row g-2">
                                        <div class="col-md-6"><div class="opt-badge ${q.correctOption == 'A' ? 'correct' : ''}">A. <c:out value="${q.optionA}"/></div></div>
                                        <div class="col-md-6"><div class="opt-badge ${q.correctOption == 'B' ? 'correct' : ''}">B. <c:out value="${q.optionB}"/></div></div>
                                        <div class="col-md-6"><div class="opt-badge ${q.correctOption == 'C' ? 'correct' : ''}">C. <c:out value="${q.optionC}"/></div></div>
                                        <div class="col-md-6"><div class="opt-badge ${q.correctOption == 'D' ? 'correct' : ''}">D. <c:out value="${q.optionD}"/></div></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:when test="${assignment.type == 'QUIZ'}">
                        <div class="text-center py-5" style="color: var(--text-dim);">No questions added yet.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="question-card">
                            <div class="mb-2"><strong>Due Date:</strong> <c:out value="${assignment.dueDate}"/></div>
                            <div class="mb-2"><strong>Maximum Marks:</strong> <c:out value="${assignment.maxMarks}"/></div>
                            <div><strong>Questions:</strong> <c:out value="${assignment.description}" default="No questions added."/></div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="panel">
                <h4 class="fw-bold mb-4">Submissions (<c:out value="${submissions.size()}" default="0"/>)</h4>
                <c:choose>
                    <c:when test="${not empty submissions}">
                        <div class="d-flex flex-column gap-3">
                            <c:forEach var="sub" items="${submissions}">
                                <div class="submission-card">
                                    <div class="fw-bold"><c:out value="${sub.student.fullName}" default="Student"/></div>
                                    <div style="color: var(--text-dim); font-size: 0.9rem;">
                                        <c:choose>
                                            <c:when test="${sub.graded}">
                                                Graded: <c:out value="${sub.marksObtained}"/> / <c:out value="${sub.assignment.maxMarks}"/>
                                            </c:when>
                                            <c:otherwise>Pending review</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5" style="color: var(--text-dim);">No submissions yet.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
