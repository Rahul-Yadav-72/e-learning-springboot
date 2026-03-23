<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Student Dashboard"/>
<%@ include file="../common/header.jsp" %>

<div class="row g-4">

    <%@ include file="../common/sidebar.jsp" %>

    <div class="col-lg-9 col-md-8">

        <div class="welcome-banner student mb-4 position-relative overflow-hidden">
            <div class="banner-content d-flex align-items-center gap-4">
                <div class="banner-icon-l">
                    <i class="fa-solid fa-graduation-cap"></i>
                </div>
                <div>
                    <h3 class="text-white fw-900 mb-1">Welcome Back, ${student.fullName}! 👋</h3>
                    <p class="text-white-50 mb-0">You're doing great! You have completed <strong>${enrollment.progressPercent}%</strong> of your current goal.</p>
                </div>
            </div>
            <div class="banner-circle"></div>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-6 col-lg-3">
                <div class="stat-card-v2 blue">
                    <div class="d-flex justify-content-between">
                        <span class="label">Enrolled</span>
                        <i class="fa-solid fa-book-bookmark"></i>
                    </div>
                    <div class="value">${totalEnrolled}</div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="stat-card-v2 green">
                    <div class="d-flex justify-content-between">
                        <span class="label">Completed</span>
                        <i class="fa-solid fa-check-double"></i>
                    </div>
                    <div class="value">${completedCourses}</div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="stat-card-v2 gold">
                    <div class="d-flex justify-content-between">
                        <span class="label">Certificates</span>
                        <i class="fa-solid fa-award"></i>
                    </div>
                    <div class="value">${certificates.size()}</div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="stat-card-v2 red">
                    <div class="d-flex justify-content-between">
                        <span class="label">Quiz Avg</span>
                        <i class="fa-solid fa-chart-pie"></i>
                    </div>
                    <div class="value">
                        <c:if test="${not empty quizResults}">
                            <fmt:formatNumber value="${quizResults[0].percentage}" maxFractionDigits="0"/>%
                        </c:if>
                        <c:if test="${empty quizResults}">0%</c:if>
                    </div>
                </div>
            </div>
        </div>

        <div class="glass-card mb-4">
            <div class="glass-card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0 text-white fw-bold">
                    <i class="fa-solid fa-person-running me-2 text-primary"></i>
                    Pick Up Where You Left Off
                </h5>
                <a href="${pageContext.request.contextPath}/student/my-courses" class="text-primary text-decoration-none small fw-bold">View Library →</a>
            </div>
            <div class="glass-card-body p-0">
                <c:choose>
                    <c:when test="${not empty enrollments}">
                        <c:forEach var="e" items="${enrollments}" varStatus="s">
                            <c:if test="${s.index < 3}">
                                <div class="learning-row p-3 border-bottom border-white-50">
                                    <div class="row align-items-center">
                                        <div class="col-lg-6 mb-3 mb-lg-0">
                                            <h6 class="text-white mb-1 fw-bold">${e.course.title}</h6>
                                            <span class="text-muted small">By ${e.course.instructor.fullName}</span>
                                        </div>
                                        <div class="col-lg-4 mb-3 mb-lg-0">
                                            <div class="d-flex justify-content-between mb-1">
                                                <span class="text-muted" style="font-size: 0.7rem;">Course Progress</span>
                                                <span class="text-primary fw-bold" style="font-size: 0.7rem;">${e.progressPercent}%</span>
                                            </div>
                                            <div class="progress-dark" style="height: 6px;">
                                                <div class="bar bar-blue" style="width:${e.progressPercent}%"></div>
                                            </div>
                                        </div>
                                        <div class="col-lg-2 text-lg-end">
                                            <a href="${pageContext.request.contextPath}/student/learn/${e.course.id}" class="btn-glow btn-primary-glow btn-sm-glow w-100">Resume</a>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="p-5 text-center">
                            <img src="https://cdn-icons-png.flaticon.com/512/7486/7486744.png" width="80" class="opacity-25 mb-3" alt="Empty">
                            <h6 class="text-white-50">Ready to start your journey?</h6>
                            <a href="${pageContext.request.contextPath}/courses" class="btn-glow btn-primary-glow mt-2">Explore All Courses</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-6">
                <div class="glass-card h-100">
                    <div class="glass-card-header">
                        <h6 class="text-white fw-bold mb-0"><i class="fa-solid fa-medal me-2 text-warning"></i>Earned Credentials</h6>
                    </div>
                    <div class="glass-card-body">
                        <c:choose>
                            <c:when test="${not empty certificates}">
                                <div class="d-flex flex-column gap-3">
                                    <c:forEach var="cert" items="${certificates}" varStatus="s">
                                        <c:if test="${s.index < 3}">
                                            <div class="p-3 rounded-4 d-flex align-items-center gap-3" style="background: rgba(255,255,255,0.03); border: 1px solid var(--border);">
                                                <div class="cert-icon-mini"><i class="fa-solid fa-award"></i></div>
                                                <div class="flex-grow-1 overflow-hidden">
                                                    <div class="text-white fw-bold text-truncate small">${cert.course.title}</div>
                                                    <div class="text-muted" style="font-size: 0.65rem;">ID: ${cert.certificateNumber}</div>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/student/certificates" class="btn-icon-link"><i class="fa-solid fa-download"></i></a>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4 text-muted small">No certificates earned yet. Finish a course to get one!</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="glass-card h-100">
                    <div class="glass-card-header">
                        <h6 class="text-white fw-bold mb-0"><i class="fa-solid fa-chart-column me-2 text-danger"></i>Latest Quiz Scores</h6>
                    </div>
                    <div class="glass-card-body p-0">
                        <table class="table table-dark table-borderless mb-0 small">
                            <tbody>
                                <c:forEach var="qr" items="${quizResults}" varStatus="s">
                                    <c:if test="${s.index < 4}">
                                        <tr class="border-bottom border-white-50">
                                            <td class="ps-3 py-3 text-white-50">${qr.quiz.title}</td>
                                            <td class="text-end fw-bold text-primary">${qr.percentage}%</td>
                                            <td class="pe-3 text-end">
                                                <span class="badge ${qr.passed ? 'bg-success' : 'bg-danger'} rounded-pill" style="font-size: 0.6rem;">
                                                    ${qr.passed ? 'PASS' : 'FAIL'}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                        <c:if test="${empty quizResults}">
                            <div class="text-center py-5 text-muted small">No assessment data available.</div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<style>
/* New Premium Styles for dashboard.jsp */
.welcome-banner { background: linear-gradient(135deg, #4e73df 0%, #224abe 100%); border-radius: 20px; padding: 30px; border: none; }
.banner-circle { position: absolute; right: -50px; top: -50px; width: 200px; height: 200px; background: rgba(255,255,255,0.1); border-radius: 50%; }
.banner-icon-l { width: 60px; height: 60px; background: rgba(255,255,255,0.2); border-radius: 15px; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; color: white; }

.stat-card-v2 { background: var(--dark-2); padding: 20px; border-radius: 18px; border: 1px solid var(--border); transition: 0.3s; }
.stat-card-v2:hover { transform: translateY(-5px); border-color: var(--primary); }
.stat-card-v2 .label { font-size: 0.75rem; color: var(--muted); font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
.stat-card-v2 i { color: var(--primary); opacity: 0.5; font-size: 1.1rem; }
.stat-card-v2 .value { font-size: 1.6rem; font-weight: 800; color: white; margin-top: 10px; }

.cert-icon-mini { width: 35px; height: 35px; background: rgba(246,194,62,0.1); color: #f6c23e; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 0.9rem; flex-shrink: 0; }
.btn-icon-link { color: var(--muted); transition: 0.2s; }
.btn-icon-link:hover { color: white; }
.learning-row:last-child { border-bottom: none !important; }
</style>

<%@ include file="../common/footer.jsp" %>