<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Explore Courses"/>
<%@ include file="../common/header.jsp" %>

<div class="glass-card mb-5">
    <div class="glass-card-body p-4">
        <form action="${pageContext.request.contextPath}/courses" method="get">
            <div class="row g-4 align-items-end">

                <div class="col-lg-5 col-md-12">
                    <label class="form-label-dark">Search for Courses</label>
                    <div class="input-group-dark">
                        <i class="fa-solid fa-magnifying-glass ig-icon"></i>
                        <input type="text" name="keyword" class="form-control-dark" 
                               placeholder="What do you want to learn today?" value="${keyword}"/>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <label class="form-label-dark">Category</label>
                    <select name="categoryId" class="form-control-dark">
                        <option value="">All Categories</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.id}" ${selectedCategoryId == cat.id ? 'selected' : ''}>
                                ${cat.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-lg-2 col-md-6">
                    <label class="form-label-dark">Difficulty Level</label>
                    <select name="level" class="form-control-dark">
                        <option value="">All Levels</option>
                        <option value="BEGINNER" ${param.level == 'BEGINNER' ? 'selected' : ''}>Beginner</option>
                        <option value="INTERMEDIATE" ${param.level == 'INTERMEDIATE' ? 'selected' : ''}>Intermediate</option>
                        <option value="ADVANCED" ${param.level == 'ADVANCED' ? 'selected' : ''}>Advanced</option>
                    </select>
                </div>

                <div class="col-lg-2">
                    <button type="submit" class="btn-glow btn-primary-glow w-100 py-2">
                        <i class="fa-solid fa-filter me-2"></i> Apply Filters
                    </button>
                </div>

            </div>
        </form>
    </div>
</div>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="mb-0 text-white" style="font-weight: 800;">
            <c:choose>
                <c:when test="${not empty keyword}">
                    Results for "<c:out value="${keyword}"/>"
                </c:when>
                <c:otherwise>Discover All Courses</c:otherwise>
            </c:choose>
        </h4>
        <p class="text-muted small mb-0 mt-1">${courses.size()} premium programs found</p>
    </div>
</div>

<c:choose>
    <c:when test="${not empty courses}">
        <div class="row g-4">
            <c:forEach var="course" items="${courses}">
                <div class="col-md-6 col-lg-4">
                    <div class="course-card-dark" onclick="window.location='${pageContext.request.contextPath}/courses/${course.id}'">

                        <div class="course-thumb-dark">
                            <c:choose>
                                <c:when test="${not empty course.thumbnailUrl}">
                                    <img src="${course.thumbnailUrl}" alt="${course.title}" style="width:100%; height:100%; object-fit:cover;">
                                </c:when>
                                <c:otherwise>
                                    <div class="thumb-overlay">
                                        <i class="fa-solid fa-laptop-code"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div class="play-btn">
                                <i class="fa-solid fa-play"></i>
                            </div>
                        </div>

                        <div class="course-body-dark">
                            <div class="d-flex gap-2 mb-3">
                                <span class="badge-glow badge-primary">${course.level}</span>
                                <c:if test="${course.category != null}">
                                    <span class="badge-glow badge-gray">${course.category.name}</span>
                                </c:if>
                            </div>

                            <h6 class="course-title-dark mb-3">${course.title}</h6>

                            <div class="course-instructor-dark mb-2">
                                <i class="fa-solid fa-user-tie me-2"></i> ${course.instructor.fullName}
                            </div>

                            <div class="course-rating-dark mb-4">
                                <i class="fa-solid fa-star text-warning me-1"></i>
                                <fmt:formatNumber value="${course.averageRating}" maxFractionDigits="1"/>
                                <span class="ms-2">(${course.totalEnrollments} learners)</span>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mt-auto">
                                <div class="price-section">
                                    <c:choose>
                                        <c:when test="${course.discountPrice != null}">
                                            <span class="course-price-dark">&#8377;${course.discountPrice}</span>
                                            <span class="text-muted small text-decoration-line-through ms-2">&#8377;${course.price}</span>
                                        </c:when>
                                        <c:when test="${course.price == 0}">
                                            <span class="course-price-dark text-success">Free Access</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="course-price-dark">&#8377;${course.price}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <button class="btn-glow btn-primary-glow btn-sm-glow">
                                    Enrol Now
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <div class="empty-dark py-5">
            <div class="empty-icon mb-3">
                <i class="fa-solid fa-magnifying-glass-chart"></i>
            </div>
            <h5 class="text-white">No courses matching your criteria</h5>
            <p class="text-muted">Try adjusting your keywords or browse all categories to find what you're looking for.</p>
            <a href="${pageContext.request.contextPath}/courses" class="btn-glow btn-primary-glow px-4 mt-3">
                Clear All Filters
            </a>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="../common/footer.jsp" %>