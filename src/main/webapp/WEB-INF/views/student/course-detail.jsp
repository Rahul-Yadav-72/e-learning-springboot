<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="${course.title}"/>
<%@ include file="../common/header.jsp" %>

<div class="row g-4">

    <div class="col-lg-8">

        <nav class="mb-3">
            <span style="color:rgba(255,255,255,0.4); font-size:0.85rem;">
                <a href="${pageContext.request.contextPath}/courses" style="color:rgba(255,255,255,0.4);">Courses</a>
                &nbsp;/&nbsp;
                <c:if test="${course.category != null}">
                    ${course.category.name} &nbsp;/&nbsp;
                </c:if>
                <span style="color:white; font-weight:600;">${course.title}</span>
            </span>
        </nav>

        <div class="glass-card mb-4 overflow-hidden">
            <div style="height:280px; background:linear-gradient(135deg,#0f3460,#1a1a2e); display:flex; align-items:center; justify-content:center; position:relative;">
                <c:choose>
                    <c:when test="${not empty course.thumbnailUrl}">
                        <img src="${course.thumbnailUrl}" alt="Course Preview" style="width:100%; height:100%; object-fit:cover; opacity:0.6;">
                    </c:when>
                    <c:otherwise>
                         <i class="fa-solid fa-play-circle" style="font-size:5rem; color:rgba(255,255,255,0.15);"></i>
                    </c:otherwise>
                </c:choose>
                <div style="position:absolute; top:20px; left:20px; display:flex; gap:10px;">
                    <span class="badge-glow badge-primary">${course.level}</span>
                    <span class="badge-glow badge-gray">${course.language}</span>
                </div>
            </div>

            <div class="glass-card-body">
                <h1 style="color:white; font-weight:800; font-size:1.8rem; margin-bottom:12px;">${course.title}</h1>

                <div class="d-flex align-items-center gap-4 flex-wrap mb-4">
                    <div class="d-flex align-items-center gap-2">
                        <i class="fa-solid fa-star text-warning"></i>
                        <span class="fw-bold text-white"><fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/></span>
                        <span class="text-muted small">(${reviews.size()} student reviews)</span>
                    </div>
                    <div class="text-muted small">
                        <i class="fa-solid fa-user-check me-1"></i> ${course.totalEnrollments} students enrolled
                    </div>
                </div>

                <div style="display:flex; align-items:center; gap:12px; padding:15px; background:rgba(255,255,255,0.03); border:1px solid var(--border); border-radius:12px;">
                    <div style="width:45px; height:45px; border-radius:50%; background:linear-gradient(135deg,#4e73df,#224abe); display:flex; align-items:center; justify-content:center; font-weight:800; color:white;">
                        ${course.instructor.fullName.substring(0,1)}
                    </div>
                    <div>
                        <div class="text-muted small">Published by Expert Instructor</div>
                        <div class="text-white fw-bold">${course.instructor.fullName}</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="glass-card mb-4">
            <div class="glass-card-header">
                <h5><i class="fa-solid fa-align-left me-2 text-primary"></i>About this Course</h5>
            </div>
            <div class="glass-card-body">
                <p class="text-muted" style="line-height:1.8;">${course.description}</p>
                <c:if test="${not empty course.whatYoullLearn}">
                    <div class="mt-4 p-3 rounded-3" style="background:rgba(78,115,223,0.05); border:1px solid rgba(78,115,223,0.15);">
                        <h6 class="text-primary fw-bold mb-3 small text-uppercase">What You'll Master</h6>
                        <div class="text-muted small" style="line-height:1.8;">${course.whatYoullLearn}</div>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="glass-card mb-4">
            <div class="glass-card-header">
                <h5><i class="fa-solid fa-layer-group me-2 text-primary"></i>Curriculum Overview</h5>
                <span class="text-muted small">${course.modules.size()} Learning Modules</span>
            </div>
            <div class="glass-card-body p-0">
                <c:forEach var="cmod" items="${course.modules}">
                    <div class="border-bottom border-white-50 opacity-75">
                        <div class="p-3 d-flex justify-content-between align-items-center cursor-pointer hover-bg" onclick="toggleModule('mod-${cmod.id}', this)" style="background:rgba(255,255,255,0.01);">
                            <div class="d-flex align-items-center gap-3">
                                <i class="fa-solid fa-chevron-right text-muted small transition-rotate"></i>
                                <span class="text-white fw-bold small">${cmod.title}</span>
                            </div>
                            <span class="text-muted small">${cmod.lessons.size()} lessons</span>
                        </div>

                        <div id="mod-${cmod.id}" style="display:none;">
                            <c:forEach var="lesson" items="${cmod.lessons}">
                                <div class="py-2 px-4 d-flex justify-content-between align-items-center border-top border-white-50">
                                    <div class="d-flex align-items-center gap-3">
                                        <c:choose>
                                            <c:when test="${lesson.freePreview or isEnrolled}">
                                                <i class="fa-solid fa-circle-play text-primary small"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa-solid fa-lock text-muted small"></i>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="text-muted small">${lesson.title}</span>
                                        <c:if test="${lesson.freePreview}">
                                            <span class="badge-glow badge-success py-0 px-2" style="font-size:0.6rem;">Preview Available</span>
                                        </c:if>
                                    </div>
                                    <span class="text-muted small" style="font-size:0.7rem;">${lesson.durationMinutes} min</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="glass-card">
            <div class="glass-card-header">
                <h5><i class="fa-solid fa-comments me-2 text-warning"></i>Global Reviews</h5>
                <div class="d-flex align-items-center gap-2">
                    <span class="h4 text-white mb-0"><fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/></span>
                    <span class="text-muted">/ 5.0</span>
                </div>
            </div>
            <div class="glass-card-body">
                <c:choose>
                    <c:when test="${not empty reviews}">
                        <c:forEach var="rev" items="${reviews}">
                            <div class="mb-4 pb-3 border-bottom border-white-50">
                                <div class="d-flex align-items-center gap-3 mb-2">
                                    <div class="reviewer-avatar" style="width:35px; height:35px; border-radius:50%; background:var(--glass-b); display:flex; align-items:center; justify-content:center; color:white; font-size:0.8rem;">
                                        ${rev.user.fullName.substring(0,1)}
                                    </div>
                                    <div>
                                        <div class="text-white small fw-bold">${rev.user.fullName}</div>
                                        <div class="text-warning small" style="font-size:0.7rem;">
                                            <c:forEach begin="1" end="${rev.rating}">★</c:forEach>
                                        </div>
                                    </div>
                                </div>
                                <p class="text-muted small mb-0">${rev.comment}</p>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-4 text-muted small">No reviews submitted for this course yet.</div>
                    </c:otherwise>
                </c:choose>

                <c:if test="${isEnrolled}">
                    <div class="mt-4 pt-3 border-top border-white-50">
                        <h6 class="text-white mb-3">Share Your Feedback</h6>
                        <form action="${pageContext.request.contextPath}/student/review/add" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="courseId" value="${course.id}"/>
                            <div class="mb-3">
                                <label class="small text-muted fw-bold mb-2">Rate your experience</label>
                                <div id="starRating" class="d-flex gap-2">
                                    <c:forEach begin="1" end="5" var="s">
                                        <span class="star-item cursor-pointer h4 mb-0 text-white-50">★</span>
                                    </c:forEach>
                                </div>
                                <input type="hidden" name="rating" id="ratingValue"/>
                            </div>
                            <div class="mb-3">
                                <textarea name="comment" class="form-control-dark" rows="3" placeholder="Write your thoughts about the course content..."></textarea>
                            </div>
                            <button type="submit" class="btn-glow btn-primary-glow btn-sm-glow">Submit Review</button>
                        </form>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="glass-card sticky-top" style="top:90px; z-index:100;">
            <div style="height:180px; background:linear-gradient(135deg,#224abe,#0f3460); display:flex; align-items:center; justify-content:center;">
                <i class="fa-solid fa-graduation-cap text-white opacity-25" style="font-size:4rem;"></i>
            </div>
            <div class="glass-card-body">
                <div class="mb-4">
                    <c:choose>
                        <c:when test="${course.discountPrice != null}">
                            <div class="h3 text-white fw-900 mb-0">&#8377;${course.discountPrice}</div>
                            <span class="text-muted text-decoration-line-through small">&#8377;${course.price}</span>
                            <span class="badge bg-danger ms-2 small">SALE</span>
                        </c:when>
                        <c:when test="${course.price == 0}">
                            <div class="h3 text-success fw-900 mb-0">FREE</div>
                        </c:when>
                        <c:otherwise>
                            <div class="h3 text-white fw-900 mb-0">&#8377;${course.price}</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:choose>
                    <c:when test="${isEnrolled}">
                        <a href="${pageContext.request.contextPath}/student/learn/${course.id}" class="btn-glow btn-success-glow w-100 py-3 justify-content-center">
                            <i class="fa-solid fa-play-circle me-2"></i> Resume Learning
                        </a>
                    </c:when>
                    <c:when test="${course.price == 0}">
                        <form action="${pageContext.request.contextPath}/student/enroll/free/${course.id}" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button type="submit" class="btn-glow btn-success-glow w-100 py-3">Enroll Now for Free</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/student/payment/${course.id}" class="btn-glow btn-primary-glow w-100 py-3 justify-content-center">
                            Buy this Course
                        </a>
                    </c:otherwise>
                </c:choose>

                <div class="mt-4 pt-4 border-top border-white-50">
                    <p class="small fw-bold text-muted text-uppercase mb-3">This program includes:</p>
                    <div class="d-flex flex-column gap-3">
                        <div class="small text-muted"><i class="fa-solid fa-video text-primary me-2"></i> High-definition video modules</div>
                        <div class="small text-muted"><i class="fa-solid fa-infinity text-primary me-2"></i> Full lifetime access</div>
                        <div class="small text-muted"><i class="fa-solid fa-certificate text-primary me-2"></i> Professional certificate</div>
                        <div class="small text-muted"><i class="fa-solid fa-desktop text-primary me-2"></i> Access on mobile and TV</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function toggleModule(id, header) {
    const el = document.getElementById(id);
    const icon = header.querySelector('.transition-rotate');
    if (el.style.display === 'none') {
        el.style.display = 'block';
        icon.style.transform = 'rotate(90deg)';
    } else {
        el.style.display = 'none';
        icon.style.transform = 'rotate(0deg)';
    }
}

const starItems = document.querySelectorAll('.star-item');
let selected = 0;
starItems.forEach((star, i) => {
    star.addEventListener('mouseover', () => highlight(i + 1));
    star.addEventListener('mouseout', () => highlight(selected));
    star.addEventListener('click', () => {
        selected = i + 1;
        document.getElementById('ratingValue').value = selected;
        highlight(selected);
    });
});

function highlight(n) {
    starItems.forEach((s, i) => s.style.color = i < n ? '#f6c23e' : 'rgba(255,255,255,0.2)');
}
</script>

<%@ include file="../common/footer.jsp" %>