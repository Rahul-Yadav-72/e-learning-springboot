<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="My Learning"/>
<%@ include file="../common/header.jsp" %>

<div class="row g-4">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="col-lg-9 col-md-8">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h4 class="text-white fw-800 mb-0">My Learning</h4>
                <p class="text-muted small mb-0">${enrollments.size()} active programs in your library</p>
            </div>
            <a href="${pageContext.request.contextPath}/courses" class="btn-glow btn-primary-glow">
                <i class="fa-solid fa-magnifying-glass me-2"></i> Explore Catalog
            </a>
        </div>

        <div class="d-flex gap-2 mb-4 flex-wrap">
            <button onclick="filterCourses('all')" id="tab-all" class="filter-tab active-tab">
                All Courses (${enrollments.size()})
            </button>
            <button onclick="filterCourses('progress')" id="tab-progress" class="filter-tab">
                In Progress
            </button>
            <button onclick="filterCourses('completed')" id="tab-completed" class="filter-tab">
                Completed
            </button>
        </div>

        <c:choose>
            <c:when test="${not empty enrollments}">
                <div class="row g-4" id="courseGrid">
                    <c:forEach var="e" items="${enrollments}">
                        <div class="col-md-6 course-item ${e.completed ? 'completed-item' : 'progress-item'}">
                            <div class="glass-card h-100 border-0 shadow-lg" style="overflow:hidden; cursor:default; background: rgba(255,255,255,0.03);">

                                <div style="height:160px; background:linear-gradient(135deg, #0f3460, #1a1a2e); display:flex; align-items:center; justify-content:center; position:relative;">
                                    <c:choose>
                                        <c:when test="${not empty e.course.thumbnailUrl}">
                                            <img src="${e.course.thumbnailUrl}" alt="${e.course.title}" style="width:100%; height:100%; object-fit:cover; opacity: 0.6;">
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fa-solid fa-circle-play text-white opacity-25" style="font-size:3rem;"></i>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <c:if test="${e.completed}">
                                        <div class="position-absolute top-0 end-0 m-3 badge bg-success shadow-sm">
                                            <i class="fa-solid fa-check-double me-1"></i> Completed
                                        </div>
                                    </c:if>
                                    <div class="position-absolute bottom-0 start-0 m-3 badge bg-dark text-white-50 border border-secondary" style="font-size: 0.65rem;">
                                        ${e.course.level}
                                    </div>
                                </div>

                                <div class="glass-card-body p-4">
                                    <c:if test="${e.course.category != null}">
                                        <span class="badge-glow badge-primary mb-2" style="font-size: 0.65rem;">
                                            ${e.course.category.name}
                                        </span>
                                    </c:if>

                                    <h6 class="text-white fw-bold mb-2" style="line-height: 1.5; min-height: 2.8rem; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;">
                                        ${e.course.title}
                                    </h6>

                                    <div class="text-white-50 small mb-3">
                                        <i class="fa-solid fa-chalkboard-user me-2"></i> ${e.course.instructor.fullName}
                                    </div>

                                    <div class="mb-4">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span class="text-muted small">Course Progress</span>
                                            <span class="text-primary fw-bold small">${e.progressPercent}%</span>
                                        </div>
                                        <div class="progress-dark" style="height: 6px;">
                                            <div class="bar ${e.completed ? 'bar-green' : 'bar-blue'}" style="width:${e.progressPercent}%"></div>
                                        </div>
                                    </div>

                                    <div class="d-flex gap-2 mt-auto">
                                        <a href="${pageContext.request.contextPath}/student/learn/${e.course.id}" class="btn-glow btn-primary-glow flex-grow-1 justify-content-center">
                                            <i class="fa-solid ${e.completed ? 'fa-arrow-rotate-left' : 'fa-play'} me-2"></i>
                                            ${e.completed ? 'Review Content' : 'Resume Learning'}
                                        </a>
                                        <a href="${pageContext.request.contextPath}/courses/${e.course.id}" class="btn-glow btn-ghost px-3" title="View Details">
                                            <i class="fa-solid fa-circle-info"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-dark py-5 text-center">
                    <div class="empty-icon mb-3" style="font-size: 4rem; opacity: 0.2;">
                        <i class="fa-solid fa-book-bookmark"></i>
                    </div>
                    <h5 class="text-white">Your library is empty</h5>
                    <p class="text-muted mx-auto" style="max-width: 300px;">
                        You haven't enrolled in any courses yet. Start exploring our premium catalog to begin learning.
                    </p>
                    <a href="${pageContext.request.contextPath}/courses" class="btn-glow btn-primary-glow px-4 mt-3">
                        <i class="fa-solid fa-compass me-2"></i> Browse Courses
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</div>

<style>
.filter-tab {
    background: rgba(255,255,255,0.03);
    border: 1px solid var(--border);
    border-radius: 12px;
    padding: 10px 20px;
    color: var(--text-dim);
    font-size: 0.85rem;
    font-weight: 600;
    cursor: pointer;
    transition: 0.3s;
}
.filter-tab:hover {
    background: rgba(255,255,255,0.08);
    color: white;
}
.active-tab {
    background: rgba(78,115,223,0.15) !important;
    border-color: var(--primary) !important;
    color: #7b9ef0 !important;
}
.course-item { transition: transform 0.3s ease; }
</style>

<script>
function filterCourses(type) {
    document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active-tab'));
    document.getElementById('tab-' + type).classList.add('active-tab');

    document.querySelectorAll('.course-item').forEach(item => {
        if (type === 'all') {
            item.style.display = 'block';
        } else if (type === 'completed') {
            item.style.display = item.classList.contains('completed-item') ? 'block' : 'none';
        } else if (type === 'progress') {
            item.style.display = item.classList.contains('progress-item') ? 'block' : 'none';
        }
    });
}
</script>

<%@ include file="../common/footer.jsp" %>