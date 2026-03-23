<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Home"/>


<section class="hero-section">
    <div class="hero-orb hero-orb-1"></div>
    <div class="hero-orb hero-orb-2"></div>

    <div class="container-fluid px-4">
        <div class="row align-items-center g-5 py-2">

            <div class="col-lg-6">

                <div class="hero-badge mb-3">
                    <span class="hero-badge-dot"></span>
                    India's #1 Digital Learning Platform
                </div>

                <h1 class="hero-heading mb-3">
                    Master New Skills,<br/>
                    <span class="hero-heading-gradient">Build Your Future</span>
                    <span class="hero-heading-dot">.</span>
                </h1>

                <p class="hero-desc mb-4">
                    Learn from industry-leading instructors through high-quality video courses. 
                    Accelerate your career with live projects and industry-recognized certifications.
                </p>

                <div class="d-flex gap-3 flex-wrap mb-5">
                    <a href="${pageContext.request.contextPath}/courses"
                       class="btn-hero-primary">
                        <i class="fa-solid fa-compass"></i>
                        Explore Courses
                    </a>
                    <a href="${pageContext.request.contextPath}/auth/register"
                       class="btn-hero-ghost">
                        <i class="fa-solid fa-bolt"></i>
                        Join for Free
                    </a>
                </div>

                <div class="hero-stats">
                    <div class="hero-stat-item">
                        <div class="hero-stat-num">50K+</div>
                        <div class="hero-stat-lbl">Active Students</div>
                    </div>
                    <div class="hero-stat-divider"></div>
                    <div class="hero-stat-item">
                        <div class="hero-stat-num">1.2K+</div>
                        <div class="hero-stat-lbl">Total Courses</div>
                    </div>
                    <div class="hero-stat-divider"></div>
                    <div class="hero-stat-item">
                        <div class="hero-stat-num">250+</div>
                        <div class="hero-stat-lbl">Expert Mentors</div>
                    </div>
                    <div class="hero-stat-divider"></div>
                    <div class="hero-stat-item">
                        <div class="hero-stat-num text-warning">4.9★</div>
                        <div class="hero-stat-lbl">Avg Rating</div>
                    </div>
                </div>
            </div>

            <div class="col-lg-6 d-none d-lg-flex
                        justify-content-center">
                <div class="hero-cards-wrap">

                    <div class="hero-card hero-card-progress">
                        <div class="d-flex align-items-center gap-3 mb-3">
                            <div class="hero-card-icon">
                                <i class="fa-solid fa-laptop-code"></i>
                            </div>
                            <div>
                                <div class="hero-card-title">
                                    Full-Stack Development
                                </div>
                                <div class="hero-card-sub">
                                    by Rahul Yadav
                                </div>
                            </div>
                        </div>
                        <div class="hero-progress-bar mb-1">
                            <div class="hero-progress-fill"
                                 style="width:72%"></div>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span class="hero-card-sub">72% complete</span>
                            <span class="hero-card-sub">36 of 50 lessons</span>
                        </div>
                    </div>

                    <div class="row g-3 mt-0">
                        <div class="col-6">
                            <div class="hero-card hero-card-green">
                                <div class="hero-mini-num text-success-light">
                                    12
                                </div>
                                <div class="hero-mini-label">
                                    Courses<br/>Completed
                                </div>
                                <i class="fa-solid fa-circle-check
                                          hero-mini-icon text-success-light">
                                </i>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="hero-card hero-card-gold">
                                <div class="hero-mini-num text-warning">
                                    5
                                </div>
                                <div class="hero-mini-label">
                                    Certificates<br/>Earned
                                </div>
                                <i class="fa-solid fa-award
                                          hero-mini-icon text-warning">
                                </i>
                            </div>
                        </div>
                    </div>

                    <div class="hero-trending-badge">
                        🔥 Trending Now
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="section-gap">
    <div class="container-fluid px-4">

        <div class="row align-items-center mb-4">
            <div class="col">
                <h2 class="section-title mb-1">Top Categories</h2>
                <p class="section-sub mb-0">
                    Explore courses tailored to your career goals
                </p>
            </div>
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/courses"
                   class="see-all-link">
                    View All
                    <i class="fa-solid fa-arrow-right ms-1"></i>
                </a>
            </div>
        </div>

        <div class="row g-3">
            <c:choose>
                <c:when test="${not empty categories}">
                    <c:forEach var="cat" items="${categories}">
                        <div class="col-6 col-md-4 col-lg-2">
                            <a href="${pageContext.request.contextPath}/courses?categoryId=${cat.id}"
                               class="cat-card-link">
                                <div class="cat-card">
                                    <div class="cat-icon">
                                        <i class="fa-solid ${not empty cat.iconClass ? cat.iconClass : 'fa-layer-group'}"></i>
                                    </div>
                                    <div class="cat-name">${cat.name}</div>
                                    <div class="cat-count">
                                        ${categoryCourseCount[cat.id]} Courses
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <c:forEach begin="1" end="6">
                        <div class="col-6 col-md-4 col-lg-2">
                            <div class="cat-card skeleton-card">
                                <div class="skeleton-icon"></div>
                                <div class="skeleton-text"></div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<section class="section-gap">
    <div class="container-fluid px-4">

        <div class="row align-items-center mb-4">
            <div class="col">
                <h2 class="section-title mb-1">
                    <i class="fa-solid fa-star me-2"
                       style="color:#f6c23e;font-size:1.1rem;"></i>
                    Highly Recommended
                </h2>
                <p class="section-sub mb-0">
                    Our top-performing courses rated by students
                </p>
            </div>
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/courses"
                   class="see-all-link">
                    View All
                    <i class="fa-solid fa-arrow-right ms-1"></i>
                </a>
            </div>
        </div>

        <div class="row g-4">
            <c:choose>
                <c:when test="${not empty topCourses}">
                    <c:forEach var="course" items="${topCourses}">
                        <div class="col-md-6 col-lg-4">
                            <div class="course-card"
                                 onclick="window.location='${pageContext.request.contextPath}/courses/detail/${course.id}'">

                                <div class="course-thumb">
                                    <c:choose>
                                        <c:when test="${not empty course.thumbnailUrl}">
                                            <img src="${course.thumbnailUrl}"
                                                 alt="${course.title}"
                                                 class="course-thumb-img"/>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="course-thumb-default">
                                                <i class="fa-solid fa-play-circle"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="course-level-badge">
                                        ${course.level}
                                    </span>
                                </div>

                                <div class="course-body">
                                    <span class="course-cat-tag">
                                        ${course.category.name}
                                    </span>

                                    <h6 class="course-title">
                                        ${course.title}
                                    </h6>

                                    <div class="course-instructor">
                                        <div class="course-inst-avatar">
                                            ${course.instructor.fullName.substring(0,1)}
                                        </div>
                                        <span class="course-inst-name">
                                            ${course.instructor.fullName}
                                        </span>
                                    </div>

                                    <div class="course-meta">
                                        <div class="course-rating">
                                            <i class="fa-solid fa-star rating-star"></i>
                                            <span class="rating-num">4.9</span>
                                            <span class="rating-count">
                                                (Enrollments)
                                            </span>
                                        </div>
                                        <div class="course-duration">
                                            <i class="fa-solid fa-clock me-1"></i>
                                            Self-paced
                                        </div>
                                    </div>

                                    <div class="course-footer">
                                        <div>
                                            <span class="course-price">
                                                &#8377;${course.discountPrice != null ? course.discountPrice : course.price}
                                            </span>
                                        </div>
                                        <button class="btn-enroll">
                                            Enroll Now
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <c:forEach begin="1" end="3">
                        <div class="col-md-6 col-lg-4">
                            <div class="course-card skeleton-card">
                                <div class="skeleton-thumb"></div>
                                <div class="course-body">
                                    <div class="skeleton-line w-100 mb-2"></div>
                                    <div class="skeleton-line w-60"></div>
                                </div>
                            </div>
                        </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<section class="section-gap">
    <div class="container-fluid px-4">

        <div class="row align-items-center mb-4">
            <div class="col">
                <h2 class="section-title mb-1">
                    <i class="fa-solid fa-fire me-2"
                       style="color:#e74a3b;font-size:1.1rem;"></i>
                    Trending Programs
                </h2>
                <p class="section-sub mb-0">
                    Most enrolled courses by our global community
                </p>
            </div>
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/courses"
                   class="see-all-link">
                    View All
                    <i class="fa-solid fa-arrow-right ms-1"></i>
                </a>
            </div>
        </div>

        <div class="row g-3">
            <c:forEach var="course" items="${popularCourses}"
                       varStatus="s">
                <c:if test="${s.index < 6}">
                    <div class="col-md-6">
                        <div class="list-card"
                             onclick="window.location='${pageContext.request.contextPath}/courses/detail/${course.id}'">

                            <div class="list-rank">
                                <span class="${s.index < 3 ? 'rank-gold' : 'rank-normal'}">
                                    #${s.index + 1}
                                </span>
                            </div>

                            <div class="list-thumb">
                                <i class="fa-solid fa-play-circle
                                          list-thumb-icon"></i>
                            </div>

                            <div class="list-info">
                                <h6 class="list-title">
                                    ${course.title}
                                </h6>
                                <div class="list-instructor">
                                    ${course.instructor.fullName}
                                </div>
                            </div>

                            <div class="list-price">
                                <span class="price-paid">
                                    &#8377;${course.price}
                                </span>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>
</section>

<section class="section-gap">
    <div class="container-fluid px-4 text-center">
        <h2 class="section-title mb-2">Why Learn With Us?</h2>
        <p class="section-sub mb-5">Features that make us unique</p>

        <div class="row g-4">
            <div class="col-sm-6 col-lg-3">
                <div class="feat-card">
                    <div class="feat-icon feat-blue"><i class="fa-solid fa-video"></i></div>
                    <h6 class="feat-title">4K Video Content</h6>
                    <p class="feat-desc">High-quality lectures available offline.</p>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="feat-card">
                    <div class="feat-icon feat-green"><i class="fa-solid fa-certificate"></i></div>
                    <h6 class="feat-title">Verified Certificates</h6>
                    <p class="feat-desc">Shareable certificates for your resume.</p>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="feat-card">
                    <div class="feat-icon feat-gold"><i class="fa-solid fa-users"></i></div>
                    <h6 class="feat-title">Expert Mentors</h6>
                    <p class="feat-desc">Learn from top industry professionals.</p>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="feat-card">
                    <div class="feat-icon feat-red"><i class="fa-solid fa-infinity"></i></div>
                    <h6 class="feat-title">Lifetime Access</h6>
                    <p class="feat-desc">Enroll once, learn forever with free updates.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="section-gap">
    <div class="container-fluid px-4 text-center">
        <h2 class="section-title mb-2">What Our Students Say</h2>
        <p class="section-sub mb-5">Success stories from 50,000+ graduates</p>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="testi-card">
                    <div class="testi-stars">★★★★★</div>
                    <p class="testi-text">"The Spring Boot course transformed my career. I landed a job at a top tech company within 6 months!"</p>
                    <div class="testi-author">
                        <div class="testi-avatar testi-blue">A</div>
                        <div class="text-start">
                            <div class="testi-name">Arjun Sharma</div>
                            <div class="testi-role">Backend Developer</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="testi-card testi-featured">
                    <div class="testi-stars">★★★★★</div>
                    <p class="testi-text">"Expertly designed curriculum. Learning Data Science was never this easy and engaging."</p>
                    <div class="testi-author">
                        <div class="testi-avatar testi-green">P</div>
                        <div class="text-start">
                            <div class="testi-name">Priya Patel</div>
                            <div class="testi-role">Data Scientist</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="testi-card">
                    <div class="testi-stars">★★★★★</div>
                    <p class="testi-text">"High-quality content and great mentor support. Highly recommended for beginners!"</p>
                    <div class="testi-author">
                        <div class="testi-avatar testi-gold">R</div>
                        <div class="text-start">
                            <div class="testi-name">Rahul Gupta</div>
                            <div class="testi-role">Freelance Developer</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="section-gap mb-5">
    <div class="container-fluid px-4">
        <div class="cta-banner">
            <h2 class="cta-heading mb-3">Start Your Learning Journey — <span class="text-warning">For Free!</span></h2>
            <p class="cta-desc mb-4">Register now and get 7 days of premium access. No credit card required.</p>
            <div class="d-flex gap-3 justify-content-center">
                <a href="${pageContext.request.contextPath}/auth/register" class="btn-cta-primary">Create Free Account</a>
                <a href="${pageContext.request.contextPath}/courses" class="btn-cta-ghost">Browse Courses</a>
            </div>
        </div>
    </div>
</section>



<!-- ══════════════════════════
     PAGE CSS
══════════════════════════ -->
<style>

/* ── Hero ── */
.hero-section {
    margin: -28px -20px 0;
    padding: 80px 20px 70px;
    background: linear-gradient(135deg,
        rgba(15,52,96,0.6) 0%,
        rgba(22,33,62,0.8) 50%,
        rgba(13,13,26,0.9) 100%);
    position: relative;
    overflow: hidden;
    border-bottom: 1px solid rgba(255,255,255,0.06);
}
.hero-orb {
    position: absolute;
    border-radius: 50%;
    pointer-events: none;
}
.hero-orb-1 {
    width: 400px; height: 400px;
    top: -100px; right: -100px;
    background: radial-gradient(circle,
        rgba(78,115,223,0.15) 0%, transparent 70%);
}
.hero-orb-2 {
    width: 350px; height: 350px;
    bottom: -80px; left: -80px;
    background: radial-gradient(circle,
        rgba(28,200,138,0.1) 0%, transparent 70%);
}
.hero-badge {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: rgba(78,115,223,0.12);
    border: 1px solid rgba(78,115,223,0.25);
    border-radius: 50px;
    padding: 6px 14px;
    font-size: 0.75rem;
    font-weight: 700;
    color: #7b9ef0;
}
.hero-badge-dot {
    width: 7px; height: 7px;
    border-radius: 50%;
    background: #4e73df;
    box-shadow: 0 0 8px rgba(78,115,223,0.8);
    animation: blink 2s ease-in-out infinite;
    flex-shrink: 0;
}
@keyframes blink {
    0%,100% { opacity:1; } 50% { opacity:0.4; }
}
.hero-heading {
    font-size: clamp(2rem,4vw,3rem);
    font-weight: 800;
    color: white;
    line-height: 1.15;
}
.hero-heading-gradient {
    background: linear-gradient(135deg,#4e73df,#7b9ef0);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}
.hero-heading-dot { color: #f6c23e; }
.hero-desc {
    font-size: 1rem;
    color: rgba(255,255,255,0.6);
    line-height: 1.75;
    max-width: 480px;
}
.btn-hero-primary {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: linear-gradient(135deg,#4e73df,#224abe);
    color: white;
    font-weight: 700;
    font-size: 0.9rem;
    padding: 13px 24px;
    border-radius: 10px;
    text-decoration: none;
    box-shadow: 0 6px 25px rgba(78,115,223,0.45);
    transition: all 0.25s ease;
}
.btn-hero-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 35px rgba(78,115,223,0.6);
    color: white;
}
.btn-hero-ghost {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(255,255,255,0.15);
    color: white;
    font-weight: 600;
    font-size: 0.9rem;
    padding: 13px 24px;
    border-radius: 10px;
    text-decoration: none;
    transition: all 0.25s ease;
}
.btn-hero-ghost:hover {
    background: rgba(255,255,255,0.1);
    border-color: rgba(255,255,255,0.25);
    color: white;
}
.hero-stats {
    display: flex;
    align-items: center;
    gap: 20px;
    flex-wrap: wrap;
}
.hero-stat-item { text-align: center; }
.hero-stat-num {
    font-size: 1.6rem;
    font-weight: 800;
    color: white;
    line-height: 1;
}
.hero-stat-lbl {
    font-size: 0.72rem;
    color: rgba(255,255,255,0.45);
    margin-top: 2px;
}
.hero-stat-divider {
    width: 1px;
    background: rgba(255,255,255,0.1);
    align-self: stretch;
    height: 40px;
}
.text-success-light { color: #4dffc5 !important; }

/* Hero Cards */
.hero-cards-wrap {
    position: relative;
    max-width: 420px;
    width: 100%;
}
.hero-card {
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(255,255,255,0.1);
    border-radius: 14px;
    padding: 20px;
}
.hero-card-progress {
    background: rgba(78,115,223,0.12);
    border-color: rgba(78,115,223,0.25);
    margin-bottom: 14px;
}
.hero-card-green {
    background: rgba(28,200,138,0.1);
    border-color: rgba(28,200,138,0.2);
}
.hero-card-gold {
    background: rgba(246,194,62,0.1);
    border-color: rgba(246,194,62,0.2);
}
.hero-card-icon {
    width: 38px; height: 38px;
    border-radius: 10px;
    background: linear-gradient(135deg,#4e73df,#224abe);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.95rem;
    color: white;
    box-shadow: 0 4px 15px rgba(78,115,223,0.4);
    flex-shrink: 0;
}
.hero-card-title {
    font-size: 0.88rem;
    font-weight: 700;
    color: white;
}
.hero-card-sub {
    font-size: 0.72rem;
    color: rgba(255,255,255,0.45);
}
.hero-progress-bar {
    background: rgba(255,255,255,0.06);
    border-radius: 6px;
    height: 6px;
    overflow: hidden;
}
.hero-progress-fill {
    height: 100%;
    background: linear-gradient(90deg,#4e73df,#7b9ef0);
    border-radius: 6px;
}
.hero-mini-num {
    font-size: 1.6rem;
    font-weight: 800;
    margin-bottom: 4px;
}
.hero-mini-label {
    font-size: 0.78rem;
    font-weight: 600;
    color: rgba(255,255,255,0.6);
}
.hero-mini-icon {
    font-size: 1.4rem;
    opacity: 0.6;
    margin-top: 8px;
    display: block;
}
.hero-trending-badge {
    position: absolute;
    top: -18px; right: -18px;
    background: linear-gradient(135deg,#f6c23e,#e0a800);
    border-radius: 12px;
    padding: 10px 14px;
    box-shadow: 0 8px 25px rgba(246,194,62,0.35);
    font-size: 0.7rem;
    font-weight: 800;
    color: #1a1a2e;
    white-space: nowrap;
}

/* ── Sections ── */
.section-gap { margin-top: 60px; }
.section-title {
    font-size: 1.45rem;
    font-weight: 800;
    color: white;
    margin: 0;
}
.section-sub {
    font-size: 0.83rem;
    color: rgba(255,255,255,0.45);
}
.see-all-link {
    font-size: 0.8rem;
    font-weight: 700;
    color: #7b9ef0;
    text-decoration: none;
    display: flex;
    align-items: center;
    white-space: nowrap;
    transition: color 0.2s;
}
.see-all-link:hover { color: white; }

/* ── Category Card ── */
.cat-card-link { text-decoration: none; display: block; }
.cat-card {
    background: rgba(255,255,255,0.03);
    border: 1px solid rgba(255,255,255,0.07);
    border-radius: 14px;
    padding: 20px 12px;
    text-align: center;
    transition: all 0.25s ease;
    cursor: pointer;
}
.cat-card:hover {
    background: rgba(78,115,223,0.1);
    border-color: rgba(78,115,223,0.3);
    transform: translateY(-4px);
    box-shadow: 0 8px 30px rgba(0,0,0,0.3);
}
.cat-icon {
    width: 46px; height: 46px;
    border-radius: 12px;
    background: rgba(78,115,223,0.15);
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 10px;
    font-size: 1.2rem;
    color: #7b9ef0;
    transition: all 0.25s ease;
}
.cat-card:hover .cat-icon {
    background: rgba(78,115,223,0.3);
}
.cat-name {
    font-size: 0.8rem;
    font-weight: 700;
    color: rgba(255,255,255,0.8);
    margin-bottom: 3px;
}
.cat-count {
    font-size: 0.68rem;
    color: rgba(255,255,255,0.35);
}

/* ── Course Card ── */
.course-card {
    background: rgba(255,255,255,0.03);
    border: 1px solid rgba(255,255,255,0.07);
    border-radius: 14px;
    overflow: hidden;
    cursor: pointer;
    transition: all 0.25s ease;
    height: 100%;
    display: flex;
    flex-direction: column;
}
.course-card:hover {
    transform: translateY(-5px);
    border-color: rgba(78,115,223,0.3);
    box-shadow: 0 12px 40px rgba(0,0,0,0.4);
}
.course-thumb {
    height: 165px;
    position: relative;
    overflow: hidden;
    flex-shrink: 0;
}
.course-thumb-img {
    width: 100%; height: 100%;
    object-fit: cover;
}
.course-thumb-default {
    width: 100%; height: 100%;
    background: linear-gradient(135deg,#0f3460,#16213e);
    display: flex;
    align-items: center;
    justify-content: center;
}
.course-thumb-default i {
    font-size: 2.5rem;
    color: rgba(255,255,255,0.2);
}
.course-level-badge {
    position: absolute;
    top: 10px; left: 10px;
    background: rgba(13,13,26,0.85);
    border: 1px solid rgba(255,255,255,0.12);
    border-radius: 6px;
    padding: 3px 9px;
    font-size: 0.68rem;
    font-weight: 700;
    color: rgba(255,255,255,0.7);
    backdrop-filter: blur(4px);
}
.course-body {
    padding: 16px;
    flex: 1;
    display: flex;
    flex-direction: column;
}
.course-cat-tag {
    display: inline-block;
    font-size: 0.68rem;
    font-weight: 700;
    color: #7b9ef0;
    background: rgba(78,115,223,0.1);
    border-radius: 4px;
    padding: 2px 8px;
    margin-bottom: 8px;
}
.course-title {
    font-size: 0.88rem;
    font-weight: 700;
    color: white;
    margin-bottom: 8px;
    line-height: 1.4;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    flex: 1;
}
.course-instructor {
    display: flex;
    align-items: center;
    gap: 7px;
    margin-bottom: 8px;
}
.course-inst-avatar {
    width: 22px; height: 22px;
    border-radius: 50%;
    background: linear-gradient(135deg,#4e73df,#224abe);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.6rem;
    font-weight: 800;
    color: white;
    flex-shrink: 0;
}
.course-inst-name {
    font-size: 0.75rem;
    color: rgba(255,255,255,0.5);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.course-meta {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
}
.course-rating {
    display: flex;
    align-items: center;
    gap: 3px;
}
.rating-star {
    color: #f6c23e;
    font-size: 0.75rem;
}
.rating-num {
    font-size: 0.78rem;
    font-weight: 700;
    color: white;
}
.rating-count {
    font-size: 0.7rem;
    color: rgba(255,255,255,0.35);
}
.course-duration {
    font-size: 0.72rem;
    color: rgba(255,255,255,0.35);
}
.course-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-top: 1px solid rgba(255,255,255,0.06);
    padding-top: 12px;
    margin-top: auto;
}
.course-price {
    font-size: 1.1rem;
    font-weight: 800;
    color: #7b9ef0;
}
.course-price.free { color: #4dffc5; }
.course-old-price {
    font-size: 0.78rem;
    color: rgba(255,255,255,0.3);
    text-decoration: line-through;
    margin-left: 6px;
}
.btn-enroll {
    background: linear-gradient(135deg,#4e73df,#224abe);
    border: none;
    border-radius: 7px;
    padding: 6px 14px;
    color: white;
    font-size: 0.75rem;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.2s ease;
    font-family: 'Inter', sans-serif;
}
.btn-enroll:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 15px rgba(78,115,223,0.4);
}

/* ── List Card ── */
.list-card {
    background: rgba(255,255,255,0.03);
    border: 1px solid rgba(255,255,255,0.07);
    border-radius: 12px;
    padding: 14px 16px;
    display: flex;
    align-items: center;
    gap: 14px;
    cursor: pointer;
    transition: all 0.2s ease;
}
.list-card:hover {
    border-color: rgba(78,115,223,0.25);
    background: rgba(78,115,223,0.05);
    transform: translateX(4px);
}
.list-rank {
    font-size: 1rem;
    font-weight: 800;
    min-width: 28px;
    text-align: center;
    flex-shrink: 0;
}
.rank-gold   { color: #f6c23e; }
.rank-silver { color: #adb5bd; }
.rank-bronze { color: #cd7f32; }
.rank-normal { color: rgba(255,255,255,0.3); }
.list-thumb {
    width: 52px; height: 52px;
    border-radius: 10px;
    background: linear-gradient(135deg,#0f3460,#16213e);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}
.list-thumb-icon {
    font-size: 1.4rem;
    color: rgba(255,255,255,0.25);
}
.list-info { flex: 1; min-width: 0; }
.list-title {
    font-size: 0.84rem;
    font-weight: 700;
    color: white;
    margin-bottom: 3px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.list-instructor {
    font-size: 0.73rem;
    color: rgba(255,255,255,0.4);
    margin-bottom: 4px;
}
.list-rating {
    font-size: 0.72rem;
    color: #f6c23e;
}
.list-students {
    font-size: 0.72rem;
    color: rgba(255,255,255,0.35);
}
.list-price { flex-shrink: 0; }
.price-free {
    color: #1cc88a;
    font-weight: 800;
    font-size: 0.88rem;
}
.price-paid {
    color: #7b9ef0;
    font-weight: 800;
    font-size: 0.88rem;
}

/* ── Feature Card ── */
.feat-card {
    background: rgba(255,255,255,0.03);
    border: 1px solid rgba(255,255,255,0.07);
    border-radius: 14px;
    padding: 24px 20px;
    height: 100%;
    transition: all 0.25s ease;
}
.feat-card:hover {
    border-color: rgba(78,115,223,0.25);
    transform: translateY(-4px);
    box-shadow: 0 8px 30px rgba(0,0,0,0.3);
}
.feat-icon {
    width: 48px; height: 48px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.1rem;
    margin-bottom: 14px;
}
.feat-blue  { background:rgba(78,115,223,0.15); color:#7b9ef0; }
.feat-green { background:rgba(28,200,138,0.15); color:#4dffc5; }
.feat-gold  { background:rgba(246,194,62,0.15); color:#ffe082; }
.feat-red   { background:rgba(231,74,59,0.15);  color:#ff8a80; }
.feat-title {
    font-size: 0.92rem;
    font-weight: 700;
    color: white;
    margin-bottom: 8px;
}
.feat-desc {
    font-size: 0.8rem;
    color: rgba(255,255,255,0.45);
    line-height: 1.6;
    margin: 0;
}

/* ── Testimonial Card ── */
.testi-card {
    background: rgba(255,255,255,0.03);
    border: 1px solid rgba(255,255,255,0.07);
    border-radius: 14px;
    padding: 24px;
    height: 100%;
    transition: all 0.25s ease;
}
.testi-card:hover {
    border-color: rgba(78,115,223,0.2);
    transform: translateY(-3px);
}
.testi-featured {
    background: rgba(78,115,223,0.08);
    border-color: rgba(78,115,223,0.2);
}
.testi-stars {
    color: #f6c23e;
    font-size: 0.85rem;
    margin-bottom: 12px;
}
.testi-text {
    font-size: 0.84rem;
    color: rgba(255,255,255,0.6);
    line-height: 1.7;
    margin-bottom: 16px;
    font-style: italic;
}
.testi-author {
    display: flex;
    align-items: center;
    gap: 10px;
}
.testi-avatar {
    width: 38px; height: 38px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.85rem;
    font-weight: 800;
    color: white;
    flex-shrink: 0;
}
.testi-blue  { background:linear-gradient(135deg,#4e73df,#224abe); }
.testi-green { background:linear-gradient(135deg,#1cc88a,#13a66e); }
.testi-gold  { background:linear-gradient(135deg,#f6c23e,#e0a800); }
.testi-name {
    font-size: 0.84rem;
    font-weight: 700;
    color: white;
}
.testi-role {
    font-size: 0.72rem;
    color: rgba(255,255,255,0.4);
}

/* ── CTA Banner ── */
.cta-banner {
    background: linear-gradient(135deg,
        rgba(78,115,223,0.2) 0%,
        rgba(28,200,138,0.1) 100%);
    border: 1px solid rgba(78,115,223,0.25);
    border-radius: 20px;
    padding: 50px 40px;
    text-align: center;
    position: relative;
    overflow: hidden;
}
.cta-orb {
    position: absolute;
    border-radius: 50%;
    pointer-events: none;
}
.cta-orb-1 {
    width: 200px; height: 200px;
    top: -60px; right: -60px;
    background: rgba(78,115,223,0.1);
}
.cta-orb-2 {
    width: 150px; height: 150px;
    bottom: -40px; left: -40px;
    background: rgba(28,200,138,0.08);
}
.cta-badge {
    display: inline-flex;
    align-items: center;
    background: rgba(246,194,62,0.15);
    border: 1px solid rgba(246,194,62,0.25);
    border-radius: 50px;
    padding: 5px 14px;
    font-size: 0.73rem;
    font-weight: 700;
    color: #ffe082;
}
.cta-heading {
    font-size: 1.8rem;
    font-weight: 800;
    color: white;
}
.cta-desc {
    font-size: 0.9rem;
    color: rgba(255,255,255,0.55);
    max-width: 480px;
    margin-left: auto;
    margin-right: auto;
}
.btn-cta-primary {
    display: inline-flex;
    align-items: center;
    background: linear-gradient(135deg,#4e73df,#224abe);
    color: white;
    font-weight: 700;
    font-size: 0.9rem;
    padding: 13px 28px;
    border-radius: 10px;
    text-decoration: none;
    box-shadow: 0 6px 25px rgba(78,115,223,0.45);
    transition: all 0.25s ease;
}
.btn-cta-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 35px rgba(78,115,223,0.6);
    color: white;
}
.btn-cta-ghost {
    display: inline-flex;
    align-items: center;
    background: rgba(255,255,255,0.07);
    border: 1px solid rgba(255,255,255,0.15);
    color: white;
    font-weight: 600;
    font-size: 0.9rem;
    padding: 13px 28px;
    border-radius: 10px;
    text-decoration: none;
    transition: all 0.25s ease;
}
.btn-cta-ghost:hover {
    background: rgba(255,255,255,0.12);
    color: white;
}

/* ── Skeleton ── */
.skeleton-card { cursor: default; }
.skeleton-icon {
    width: 46px; height: 46px;
    border-radius: 12px;
    background: rgba(255,255,255,0.05);
    margin: 0 auto 10px;
    animation: shimmer 1.5s infinite;
}
.skeleton-text {
    height: 12px;
    background: rgba(255,255,255,0.05);
    border-radius: 4px;
    animation: shimmer 1.5s infinite;
}
.skeleton-thumb {
    height: 165px;
    background: rgba(255,255,255,0.04);
    animation: shimmer 1.5s infinite;
}
.skeleton-line {
    height: 12px;
    border-radius: 4px;
    background: rgba(255,255,255,0.05);
    animation: shimmer 1.5s infinite;
    display: block;
}
.w-60 { width: 60%; }
@keyframes shimmer {
    0%   { opacity: 0.5; }
    50%  { opacity: 1;   }
    100% { opacity: 0.5; }
}

/* ── Responsive ── */
@media (max-width: 991px) {
    .hero-section { padding: 50px 20px 50px; }
    .hero-heading { font-size: 2rem; }
    .cta-banner { padding: 36px 24px; }
    .cta-heading { font-size: 1.4rem; }
}
@media (max-width: 767px) {
    .hero-stats { gap: 14px; }
    .hero-stat-num { font-size: 1.2rem; }
    .hero-stat-divider { height: 30px; }
    .section-gap { margin-top: 44px; }
    .section-title { font-size: 1.2rem; }
}
@media (max-width: 575px) {
    .btn-hero-primary,
    .btn-hero-ghost { width: 100%; justify-content: center; }
    .cta-banner { padding: 28px 18px; }
}
</style>

