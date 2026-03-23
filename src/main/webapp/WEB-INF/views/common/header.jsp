<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>${pageTitle != null ? pageTitle : 'Home'} | E-Learn Platform</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    
    <style>
        :root {
            --dark-1      : #0d0d1a;
            --primary     : #4e73df;
            --primary-d   : #224abe;
            --warning     : #f6c23e;
            --text-main   : #e8e8f0;
            --text-muted  : rgba(255,255,255,0.5);
            --border      : rgba(255,255,255,0.08);
            --glass       : rgba(255,255,255,0.05);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--dark-1);
            color: var(--text-main);
            margin: 0; padding: 0;
            min-height: 100vh;
        }

        /* Animated Background Glow */
        body::before {
            content: ''; position: fixed; inset: 0;
            background: radial-gradient(circle at 15% 15%, rgba(78,115,223,0.1) 0%, transparent 50%),
                        radial-gradient(circle at 85% 85%, rgba(28,200,138,0.05) 0%, transparent 50%);
            z-index: -1; pointer-events: none;
        }

        /* Navbar Styling */
        .elearn-navbar {
            background: rgba(13,13,26,0.85) !important;
            backdrop-filter: blur(15px);
            border-bottom: 1px solid var(--border);
            height: 70px;
            position: sticky; top: 0; z-index: 1000;
        }

        .nav-brand-icon {
            width: 40px; height: 40px; border-radius: 12px;
            background: linear-gradient(135deg, var(--primary), var(--primary-d));
            display: flex; align-items: center; justify-content: center;
            color: white; box-shadow: 0 5px 15px rgba(78,115,223,0.3);
        }

        .nav-search input {
            background: var(--glass); border: 1px solid var(--border);
            border-radius: 50px; padding: 8px 20px; color: white; width: 280px; transition: 0.3s;
        }
        .nav-search input:focus { width: 320px; background: rgba(255,255,255,0.1); outline: none; border-color: var(--primary); }

        .nav-link-item { color: var(--text-muted); font-weight: 500; font-size: 0.9rem; padding: 8px 15px; border-radius: 8px; transition: 0.2s; text-decoration: none;}
        .nav-link-item:hover { color: white; background: var(--glass); }

        /* Avatar */
        .nav-avatar {
            width: 38px; height: 38px; border-radius: 50%;
            background: linear-gradient(135deg, var(--warning), #d4910a);
            display: flex; align-items: center; justify-content: center;
            font-weight: 800; color: #1a1a2e; cursor: pointer; border: 2px solid rgba(255,255,255,0.2);
        }

        .page-wrapper { min-height: calc(100vh - 70px); }
        .container-main { max-width: 1300px; margin: 0 auto; padding: 20px; }

        /* Mobile Adjustments */
        @media (max-width: 991px) {
            .nav-search { display: none; }
        }
    </style>
</head>
<body>

<nav class="elearn-navbar d-flex align-items-center">
    <div class="container-fluid d-flex align-items-center justify-content-between px-4">
        
        <div class="d-flex align-items-center gap-4">
            <a href="${pageContext.request.contextPath}/" class="text-decoration-none d-flex align-items-center gap-2">
                <div class="nav-brand-icon"><i class="fa-solid fa-graduation-cap"></i></div>
                <span class="fw-bold fs-5 text-white">E-<span style="color: var(--warning)">Learn</span></span>
            </a>

            <form class="nav-search d-none d-lg-block" action="${pageContext.request.contextPath}/courses" method="get">
                <div class="position-relative">
                    <input type="text" name="keyword" placeholder="Search for courses..." value="${param.keyword}"/>
                    <i class="fa-solid fa-magnifying-glass position-absolute top-50 end-0 translate-middle-y me-3 text-white-50"></i>
                </div>
            </form>
        </div>

        <div class="d-flex align-items-center gap-2">
            <a href="${pageContext.request.contextPath}/courses" class="nav-link-item d-none d-md-block">
                <i class="fa-solid fa-compass me-1"></i> Explore
            </a>

            <sec:authorize access="isAnonymous()">
                <a href="${pageContext.request.contextPath}/auth/login" class="nav-link-item px-3">Login</a>
                <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-sm btn-primary px-4 rounded-pill shadow-sm fw-bold">Join Free</a>
            </sec:authorize>

            <sec:authorize access="isAuthenticated()">
                <div class="nav-bell position-relative cursor-pointer text-white-50 fs-5 mx-2 px-2">
                    <i class="fa-solid fa-bell"></i>
                    <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-dark rounded-circle"></span>
                </div>

                <div class="dropdown">
                    <div class="nav-avatar" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                        <sec:authentication property="principal.username" var="username"/>
                        ${username.substring(0,1).toUpperCase()}
                    </div>
                    <ul class="dropdown-menu dropdown-menu-end dropdown-menu-dark p-2 shadow-lg border-0 mt-2" style="background: #1a1a2e; border-radius: 12px; width: 220px;">
                        <li class="px-3 py-2 border-bottom border-secondary mb-2">
                            <div class="fw-bold small text-white">${username}</div>
                            <div class="text-white-50" style="font-size: 0.7rem">
                                <sec:authorize access="hasRole('STUDENT')">Student Portal</sec:authorize>
                                <sec:authorize access="hasRole('TEACHER')">Instructor Dashboard</sec:authorize>
                                <sec:authorize access="hasRole('ADMIN')">Administrator</sec:authorize>
                            </div>
                        </li>
                        <li><a class="dropdown-item rounded-2 small py-2" href="${pageContext.request.contextPath}/student/profile"><i class="fa-solid fa-user me-2"></i> My Profile</a></li>
                        <sec:authorize access="hasRole('STUDENT')">
                            <li><a class="dropdown-item rounded-2 small py-2" href="${pageContext.request.contextPath}/student/dashboard"><i class="fa-solid fa-gauge me-2"></i> Dashboard</a></li>
                        </sec:authorize>
                        <li class="dropdown-divider border-secondary"></li>
                        <li>
                            <form action="${pageContext.request.contextPath}/auth/logout" method="post">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button type="submit" class="dropdown-item rounded-2 small py-2 text-danger fw-bold"><i class="fa-solid fa-power-off me-2"></i> Logout</button>
                            </form>
                        </li>
                    </ul>
                </div>
            </sec:authorize>
        </div>
    </div>
</nav>

<div class="container-main mt-3">
    <c:if test="${not empty successMsg}">
        <div class="alert alert-success flash-msg alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> ${successMsg}
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger flash-msg alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-exmark me-2"></i> ${errorMsg}
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
</div>

<div class="page-wrapper">
    <div class="container-main">
    <%-- Ye Divs footer.jsp mein close honge ek hi baar --%>