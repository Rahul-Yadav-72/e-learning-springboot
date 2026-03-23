<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="cp" value="${pageContext.request.contextPath}"/>

<div class="col-lg-3 col-md-4 mb-4">
    <div class="sidebar-sticky-wrapper">

        <sec:authorize access="hasRole('STUDENT')">
            <div class="sidebar-panel">
                <div class="sidebar-header student-header">
                    <div class="sidebar-header-icon student-icon">
                        <i class="fa-solid fa-user-graduate"></i>
                    </div>
                    <div>
                        <div class="sidebar-title">Student Portal</div>
                        <div class="sidebar-sub student-sub">Learning Journey</div>
                    </div>
                </div>

                <div class="sidebar-menu">
                    <a href="${cp}/student/dashboard" class="sb-item student ${pageTitle == 'Dashboard' ? 'active' : ''}">
                        <span class="sb-icon student-icon-sm"><i class="fa-solid fa-gauge-high"></i></span>
                        Overview
                    </a>
                    <a href="${cp}/student/my-courses" class="sb-item student ${pageTitle == 'My Courses' ? 'active' : ''}">
                        <span class="sb-icon student-icon-sm"><i class="fa-solid fa-play-circle"></i></span>
                        My Courses
                    </a>
                    <a href="${cp}/courses" class="sb-item student">
                        <span class="sb-icon student-icon-sm"><i class="fa-solid fa-magnifying-glass"></i></span>
                        Explore New
                    </a>
                    <a href="${cp}/student/certificates" class="sb-item student">
                        <span class="sb-icon student-icon-sm"><i class="fa-solid fa-award"></i></span>
                        Certificates
                    </a>
                    <a href="${cp}/student/assignments" class="sb-item student">
                        <span class="sb-icon student-icon-sm"><i class="fa-solid fa-tasks"></i></span>
                        Assignments
                    </a>

                    <div class="sb-divider"></div>
                    <form action="${cp}/auth/logout" method="post" id="logoutFormStudent">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="sb-logout">
                            <span class="sb-icon logout-icon"><i class="fa-solid fa-power-off"></i></span>
                            Sign Out
                        </button>
                    </form>
                </div>
            </div>
        </sec:authorize>

        <sec:authorize access="hasRole('TEACHER')">
            <div class="sidebar-panel">
                <div class="sidebar-header teacher-header">
                    <div class="sidebar-header-icon teacher-icon">
                        <i class="fa-solid fa-chalkboard-user"></i>
                    </div>
                    <div>
                        <div class="sidebar-title">Instructor Hub</div>
                        <div class="sidebar-sub teacher-sub">Course Management</div>
                    </div>
                </div>

                <div class="sidebar-menu">
                    <a href="${cp}/teacher/dashboard" class="sb-item teacher">
                        <span class="sb-icon teacher-icon-sm"><i class="fa-solid fa-chart-pie"></i></span>
                        Analytics
                    </a>
                    <a href="${cp}/teacher/courses" class="sb-item teacher">
                        <span class="sb-icon teacher-icon-sm"><i class="fa-solid fa-folder-open"></i></span>
                        My Content
                    </a>
                    <a href="${cp}/teacher/courses/add" class="sb-item teacher">
                        <span class="sb-icon teacher-icon-sm"><i class="fa-solid fa-circle-plus"></i></span>
                        Create Course
                    </a>
                    <a href="${cp}/teacher/earnings" class="sb-item teacher">
                        <span class="sb-icon teacher-icon-sm"><i class="fa-solid fa-wallet"></i></span>
                        Revenue
                    </a>

                    <div class="sb-divider"></div>
                    <form action="${cp}/auth/logout" method="post" id="logoutFormTeacher">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="sb-logout">
                            <span class="sb-icon logout-icon"><i class="fa-solid fa-power-off"></i></span>
                            Logout
                        </button>
                    </form>
                </div>
            </div>
        </sec:authorize>

        <sec:authorize access="hasRole('ADMIN')">
            <div class="sidebar-panel">
                <div class="sidebar-header admin-header">
                    <div class="sidebar-header-icon admin-icon">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    <div>
                        <div class="sidebar-title">Administrator</div>
                        <div class="sidebar-sub admin-sub">System Control</div>
                    </div>
                </div>

                <div class="sidebar-menu">
                    <a href="${cp}/admin/dashboard" class="sb-item admin">
                        <span class="sb-icon admin-icon-sm"><i class="fa-solid fa-grip"></i></span>
                        Main Panel
                    </a>
                    <a href="${cp}/admin/users" class="sb-item admin">
                        <span class="sb-icon admin-icon-sm"><i class="fa-solid fa-user-gear"></i></span>
                        Manage Users
                    </a>
                    <a href="${cp}/admin/courses" class="sb-item admin">
                        <span class="sb-icon admin-icon-sm"><i class="fa-solid fa-layer-group"></i></span>
                        Course Catalog
                    </a>
                    <a href="${cp}/admin/courses?filter=pending" class="sb-item admin">
                        <span class="sb-icon admin-icon-sm"><i class="fa-solid fa-circle-check"></i></span>
                        Approvals
                    </a>
                    <a href="${cp}/admin/payments" class="sb-item admin">
                        <span class="sb-icon admin-icon-sm"><i class="fa-solid fa-credit-card"></i></span>
                        Transactions
                    </a>
                    <a href="${cp}/admin/categories" class="sb-item admin">
                        <span class="sb-icon admin-icon-sm"><i class="fa-solid fa-tags"></i></span>
                        Categories
                    </a>

                    <div class="sb-divider"></div>
                    <form action="${cp}/auth/logout" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="sb-logout">
                            <span class="sb-icon logout-icon"><i class="fa-solid fa-power-off"></i></span>
                            Sign Out
                        </button>
                    </form>
                </div>
            </div>
        </sec:authorize>
    </div>
</div>

<style>
.sidebar-sticky-wrapper {
    position: sticky;
    top: 90px;
}
.sidebar-panel {
    background: rgba(255,255,255,0.03);
    border: 1px solid rgba(255,255,255,0.07);
    border-radius: 18px;
    overflow: hidden;
    backdrop-filter: blur(10px);
}
.sidebar-header {
    padding: 22px 20px;
    border-bottom: 1px solid rgba(255,255,255,0.06);
    display: flex;
    align-items: center;
    gap: 14px;
}
.student-header { background: linear-gradient(135deg, rgba(78,115,223,0.15), transparent); }
.teacher-header { background: linear-gradient(135deg, rgba(28,200,138,0.15), transparent); }
.admin-header { background: linear-gradient(135deg, rgba(231,74,59,0.15), transparent); }

.sidebar-header-icon {
    width: 40px; height: 40px;
    border-radius: 12px;
    display: flex; align-items: center; justify-content: center;
    font-size: 1rem; color: white;
}
.student-icon { background: linear-gradient(135deg, #4e73df, #224abe); box-shadow: 0 4px 15px rgba(78,115,223,0.3); }
.teacher-icon { background: linear-gradient(135deg, #1cc88a, #13a66e); box-shadow: 0 4px 15px rgba(28,200,138,0.3); }
.admin-icon { background: linear-gradient(135deg, #e74a3b, #b83228); box-shadow: 0 4px 15px rgba(231,74,59,0.3); }

.sidebar-title { font-weight: 800; font-size: 0.9rem; color: white; letter-spacing: 0.3px; }
.sidebar-sub { font-size: 0.7rem; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; }
.student-sub { color: #7b9ef0; }
.teacher-sub { color: #1cc88a; }
.admin-sub { color: #ff8a80; }

.sidebar-menu { padding: 12px; }

.sb-item {
    display: flex; align-items: center; gap: 12px;
    padding: 11px 14px; border-radius: 12px;
    font-size: 0.85rem; font-weight: 500;
    color: rgba(255,255,255,0.5);
    transition: all 0.25s ease;
    margin-bottom: 4px;
}
.sb-item:hover { transform: translateX(5px); }

/* Active States */
.sb-item.student.active, .sb-item.student:hover { background: rgba(78,115,223,0.1); color: #7b9ef0; }
.sb-item.teacher.active, .sb-item.teacher:hover { background: rgba(28,200,138,0.1); color: #4dffc5; }
.sb-item.admin.active, .sb-item.admin:hover { background: rgba(231,74,59,0.1); color: #ff8a80; }

.sb-icon {
    width: 32px; height: 32px; border-radius: 8px;
    display: flex; align-items: center; justify-content: center;
    font-size: 0.85rem; transition: 0.3s;
}
.student-icon-sm { background: rgba(78,115,223,0.1); color: #7b9ef0; }
.teacher-icon-sm { background: rgba(28,200,138,0.1); color: #4dffc5; }
.admin-icon-sm { background: rgba(231,74,59,0.1); color: #ff8a80; }

.sb-divider { height: 1px; background: rgba(255,255,255,0.06); margin: 12px 10px; }

.sb-logout {
    display: flex; align-items: center; gap: 12px;
    padding: 11px 14px; border-radius: 12px;
    color: #ff6b6b; font-size: 0.85rem; font-weight: 600;
    background: transparent; border: none; width: 100%;
    cursor: pointer; transition: 0.3s;
}
.sb-logout:hover { background: rgba(231,74,59,0.1); color: #ff8a80; transform: translateX(5px); }
.logout-icon { background: rgba(231,74,59,0.1); color: #ff6b6b; }
</style>