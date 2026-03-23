<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Learning: ${course.title}"/>
<%@ include file="../common/header.jsp" %>

<style>
/* ── Layout Overrides ── */
.learn-layout {
    display: grid;
    grid-template-columns: 1fr 340px;
    gap: 24px;
    align-items: start;
}
@media (max-width: 1100px) {
    .learn-layout { grid-template-columns: 1fr; }
    .lesson-sidebar { order: 2; }
}

/* ── Video Player ── */
.video-container {
    background: #000;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 20px 50px rgba(0,0,0,0.5);
    aspect-ratio: 16/9;
    position: relative;
    border: 1px solid rgba(255,255,255,0.05);
}
.video-container iframe { width: 100%; height: 100%; border: none; }

/* ── Sidebar Styling ── */
.lesson-list-scroll {
    max-height: 70vh;
    overflow-y: auto;
    padding-right: 4px;
}
.lesson-list-scroll::-webkit-scrollbar { width: 4px; }
.lesson-list-scroll::-webkit-scrollbar-thumb { background: var(--primary); border-radius: 10px; }

.module-group-header {
    padding: 14px 16px;
    background: rgba(255,255,255,0.03);
    border-bottom: 1px solid rgba(255,255,255,0.06);
    cursor: pointer;
    display: flex; align-items: center; gap: 10px;
    transition: 0.2s;
}
.module-group-header:hover { background: rgba(255,255,255,0.06); }

.lesson-nav-item {
    padding: 12px 16px 12px 35px;
    display: flex; align-items: center; gap: 12px;
    color: rgba(255,255,255,0.5);
    text-decoration: none;
    border-bottom: 1px solid rgba(255,255,255,0.03);
    font-size: 0.85rem;
    transition: 0.3s;
}
.lesson-nav-item:hover { background: rgba(78,115,223,0.08); color: white; }
.lesson-nav-item.active {
    background: rgba(78,115,223,0.12);
    border-left: 4px solid var(--primary);
    color: white; font-weight: 600;
}
</style>

<div class="learn-layout">

    <div class="main-player-area">
        
        <div class="video-container mb-4">
            <c:choose>
                <c:when test="${not empty currentLesson and not empty currentLesson.videoUrl}">
                    <iframe src="${currentLesson.videoUrl}" allowfullscreen></iframe>
                </c:when>
                <c:otherwise>
                    <div class="d-flex flex-column align-items-center justify-content-center h-100 text-center p-4">
                        <i class="fa-solid fa-play-circle mb-3 opacity-25" style="font-size: 4rem;"></i>
                        <h5 class="text-white-50">Select a lesson from the sidebar to begin</h5>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${not empty currentLesson}">
            <div class="glass-card mb-4">
                <div class="glass-card-body">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-3">
                        <div>
                            <span class="badge-glow badge-primary mb-2">Current Lesson</span>
                            <h3 class="text-white fw-bold mb-1">${currentLesson.title}</h3>
                            <p class="text-muted small mb-0"><i class="fa-solid fa-graduation-cap me-1"></i> ${course.title}</p>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/student/lesson/complete" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="lessonId" value="${currentLesson.id}"/>
                            <input type="hidden" name="courseId" value="${course.id}"/>
                            <button type="submit" class="btn-glow btn-success-glow">
                                <i class="fa-solid fa-circle-check me-2"></i> Mark as Completed
                            </button>
                        </form>
                    </div>

                    <c:if test="${not empty currentLesson.content}">
                        <div class="mt-4 pt-4 border-top border-white-50">
                            <h6 class="text-white fw-bold mb-3"><i class="fa-solid fa-file-lines me-2 text-primary"></i>Lesson Resources & Notes</h6>
                            <div class="text-muted" style="line-height: 1.8; font-size: 0.95rem;">
                                ${currentLesson.content}
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>

        <div class="glass-card">
            <div class="glass-card-body">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-white fw-bold small">Your Learning Progress</span>
                    <span class="text-primary fw-800">${enrollment.progressPercent}%</span>
                </div>
                <div class="progress-dark" style="height: 10px;">
                    <div class="bar bar-blue" style="width:${enrollment.progressPercent}%"></div>
                </div>
                
                <c:if test="${enrollment.completed}">
                    <div class="alert alert-success border-0 rounded-4 mt-4 d-flex align-items-center gap-3" style="background: rgba(28,200,138,0.1); color: #4dffc5;">
                        <i class="fa-solid fa-trophy fs-4"></i>
                        <div>
                            <div class="fw-bold">Course Completed!</div>
                            <div class="small">Congratulations on finishing this program. 
                                <a href="${pageContext.request.contextPath}/student/certificates" class="text-decoration-none fw-bold text-success ms-2">Download Certificate →</a>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <div class="lesson-sidebar">
        <div class="glass-card overflow-hidden">
            <div class="glass-card-header">
                <h6 class="text-white fw-bold mb-0"><i class="fa-solid fa-list-check me-2"></i>Course Content</h6>
            </div>

            <div class="lesson-list-scroll">
                <c:forEach var="cmod" items="${modules}">
                    <div class="module-group-header" onclick="toggleSidebarModule('sm-${cmod.id}', this)">
                        <i class="fa-solid fa-chevron-down text-white-50 small transition-rotate"></i>
                        <span class="text-white fw-bold small flex-grow-1">${cmod.title}</span>
                        <span class="badge bg-dark text-white-50 border border-secondary" style="font-size: 0.65rem;">${cmod.lessons.size()}</span>
                    </div>

                    <div id="sm-${cmod.id}">
                        <c:forEach var="lesson" items="${cmod.lessons}">
                            <a href="${pageContext.request.contextPath}/student/learn/${course.id}?lessonId=${lesson.id}" 
                               class="lesson-nav-item ${currentLesson != null and currentLesson.id == lesson.id ? 'active' : ''}">
                                
                                <div class="d-flex align-items-center gap-3 w-100">
                                    <c:choose>
                                        <c:when test="${currentLesson != null and currentLesson.id == lesson.id}">
                                            <i class="fa-solid fa-circle-play text-primary"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fa-solid fa-circle-play opacity-25"></i>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="flex-grow-1 text-truncate">${lesson.title}</span>
                                    <c:if test="${lesson.durationMinutes != null}">
                                        <span class="opacity-50" style="font-size: 0.7rem;">${lesson.durationMinutes}m</span>
                                    </c:if>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script>
function toggleSidebarModule(id, header) {
    const el = document.getElementById(id);
    const icon = header.querySelector('.transition-rotate');
    if (el.style.display === 'none') {
        el.style.display = 'block';
        icon.style.transform = 'rotate(0deg)';
    } else {
        el.style.display = 'none';
        icon.style.transform = 'rotate(-90deg)';
    }
}

// Auto-expand current module on load
document.addEventListener('DOMContentLoaded', function() {
    const activeLesson = document.querySelector('.lesson-nav-item.active');
    if (activeLesson) {
        activeLesson.parentElement.style.display = 'block';
    }
});
</script>

<%@ include file="../common/footer.jsp" %>