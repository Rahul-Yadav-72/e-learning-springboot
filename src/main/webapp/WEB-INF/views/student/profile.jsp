<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="My Profile"/>
<%@ include file="../common/header.jsp" %>

<div class="container-fluid px-4">
<div class="row g-4">

    <%@ include file="../common/sidebar.jsp" %>

    <!-- Main Content -->
    <div class="col-lg-9 col-md-8">

        <!-- Page Header -->
        <div class="d-flex justify-content-between
                    align-items-center mb-4">
            <div>
                <h4 style="color:white;font-weight:800;margin:0;">
                    My Profile
                </h4>
                <p style="color:rgba(255,255,255,0.45);
                          font-size:0.83rem;margin:4px 0 0;">
                    Apni profile manage karein
                </p>
            </div>
        </div>

        <!-- Flash Messages -->
        <c:if test="${not empty successMsg}">
            <div style="
                background:rgba(28,200,138,0.12);
                color:#4dffc5;
                border-left:3px solid #1cc88a;
                border-radius:10px;
                padding:12px 16px;
                font-size:0.85rem;
                display:flex;align-items:center;gap:8px;
                margin-bottom:20px;">
                <i class="fa-solid fa-circle-check"></i>
                <span>${successMsg}</span>
            </div>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div style="
                background:rgba(231,74,59,0.12);
                color:#ff8a80;
                border-left:3px solid #e74a3b;
                border-radius:10px;
                padding:12px 16px;
                font-size:0.85rem;
                display:flex;align-items:center;gap:8px;
                margin-bottom:20px;">
                <i class="fa-solid fa-circle-xmark"></i>
                <span>${errorMsg}</span>
            </div>
        </c:if>

        <div class="row g-4">

            <!-- Left: Avatar + Info -->
            <div class="col-lg-4">

                <!-- Profile Card -->
                <div style="
                    background:rgba(255,255,255,0.03);
                    border:1px solid rgba(255,255,255,0.07);
                    border-radius:18px;
                    overflow:hidden;
                    margin-bottom:20px;">

                    <!-- Banner -->
                    <div style="
                        height:80px;
                        background:linear-gradient(135deg,
                            #0f3460,#4e73df);
                        position:relative;">
                    </div>

                    <!-- Avatar -->
                    <div style="
                        display:flex;flex-direction:column;
                        align-items:center;
                        padding:0 20px 24px;
                        margin-top:-36px;
                        text-align:center;">

                        <div style="
                            width:72px;height:72px;
                            border-radius:50%;
                            background:linear-gradient(
                                135deg,#4e73df,#224abe);
                            display:flex;align-items:center;
                            justify-content:center;
                            font-size:1.8rem;
                            font-weight:800;color:white;
                            border:3px solid #0a0a18;
                            margin-bottom:12px;
                            flex-shrink:0;">
                            ${student.fullName.substring(0,1)}
                        </div>

                        <h5 style="
                            color:white;font-weight:800;
                            margin:0 0 4px;">
                            ${student.fullName}
                        </h5>
                        <div style="
                            font-size:0.78rem;
                            color:rgba(255,255,255,0.45);
                            margin-bottom:12px;">
                            ${student.email}
                        </div>

                        <!-- Role Badge -->
                        <span style="
                            background:rgba(78,115,223,0.15);
                            color:#7b9ef0;
                            border:1px solid rgba(78,115,223,0.3);
                            border-radius:20px;
                            padding:4px 14px;
                            font-size:0.72rem;
                            font-weight:700;
                            text-transform:uppercase;
                            letter-spacing:0.5px;">
                            <i class="fa-solid fa-user-graduate
                                      me-1"></i>
                            ${student.role}
                        </span>
                    </div>
                </div>

                <!-- Quick Stats -->
                <div style="
                    background:rgba(255,255,255,0.03);
                    border:1px solid rgba(255,255,255,0.07);
                    border-radius:16px;
                    padding:20px;">

                    <div style="
                        font-size:0.75rem;font-weight:700;
                        text-transform:uppercase;
                        letter-spacing:0.6px;
                        color:rgba(255,255,255,0.35);
                        margin-bottom:14px;">
                        Quick Stats
                    </div>

                    <div style="display:flex;flex-direction:column;gap:12px;">

                        <div style="
                            display:flex;justify-content:space-between;
                            align-items:center;
                            padding:10px 14px;
                            background:rgba(78,115,223,0.08);
                            border-radius:10px;
                            border:1px solid rgba(78,115,223,0.15);">
                            <div style="display:flex;
                                align-items:center;gap:8px;">
                                <i class="fa-solid fa-book-open"
                                   style="color:#7b9ef0;
                                          font-size:0.9rem;"></i>
                                <span style="font-size:0.82rem;
                                    color:rgba(255,255,255,0.6);">
                                    Enrolled
                                </span>
                            </div>
                            <span style="color:white;font-weight:800;
                                         font-size:0.9rem;">
                                ${totalEnrolled}
                            </span>
                        </div>

                        <div style="
                            display:flex;justify-content:space-between;
                            align-items:center;
                            padding:10px 14px;
                            background:rgba(28,200,138,0.08);
                            border-radius:10px;
                            border:1px solid rgba(28,200,138,0.15);">
                            <div style="display:flex;
                                align-items:center;gap:8px;">
                                <i class="fa-solid fa-circle-check"
                                   style="color:#4dffc5;
                                          font-size:0.9rem;"></i>
                                <span style="font-size:0.82rem;
                                    color:rgba(255,255,255,0.6);">
                                    Completed
                                </span>
                            </div>
                            <span style="color:white;font-weight:800;
                                         font-size:0.9rem;">
                                ${completedCourses}
                            </span>
                        </div>

                        <div style="
                            display:flex;justify-content:space-between;
                            align-items:center;
                            padding:10px 14px;
                            background:rgba(246,194,62,0.08);
                            border-radius:10px;
                            border:1px solid rgba(246,194,62,0.15);">
                            <div style="display:flex;
                                align-items:center;gap:8px;">
                                <i class="fa-solid fa-certificate"
                                   style="color:#ffe082;
                                          font-size:0.9rem;"></i>
                                <span style="font-size:0.82rem;
                                    color:rgba(255,255,255,0.6);">
                                    Certificates
                                </span>
                            </div>
                            <span style="color:white;font-weight:800;
                                         font-size:0.9rem;">
                                ${certificates.size()}
                            </span>
                        </div>

                    </div>
                </div>

            </div>

            <!-- Right: Edit Forms -->
            <div class="col-lg-8">

                <!-- Tab Nav -->
                <div style="
                    display:flex;gap:6px;
                    margin-bottom:20px;
                    background:rgba(255,255,255,0.03);
                    border:1px solid rgba(255,255,255,0.07);
                    border-radius:12px;
                    padding:5px;">
                    <button onclick="showTab('profile')"
                            id="tab-profile"
                            class="profile-tab active-ptab">
                        <i class="fa-solid fa-user me-1"></i>
                        Edit Profile
                    </button>
                    <button onclick="showTab('password')"
                            id="tab-password"
                            class="profile-tab">
                        <i class="fa-solid fa-lock me-1"></i>
                        Change Password
                    </button>
                </div>

                <!-- Profile Edit Form -->
                <div id="section-profile">
                    <div style="
                        background:rgba(255,255,255,0.03);
                        border:1px solid rgba(255,255,255,0.07);
                        border-radius:16px;
                        overflow:hidden;">

                        <div style="
                            padding:16px 20px;
                            border-bottom:1px solid
                                rgba(255,255,255,0.07);">
                            <h5 style="color:white;font-weight:700;
                                       margin:0;font-size:1rem;">
                                <i class="fa-solid fa-user-pen
                                          me-2"
                                   style="color:#7b9ef0;"></i>
                                Profile Information
                            </h5>
                        </div>

                        <div style="padding:24px;">
                            <form action="${pageContext.request.contextPath}/student/profile/update"
                                  method="post"
                                  enctype="multipart/form-data">
                                <input type="hidden"
                                       name="${_csrf.parameterName}"
                                       value="${_csrf.token}"/>

                                <!-- Full Name -->
                                <div class="mb-4">
                                    <label class="profile-label">
                                        Full Name
                                    </label>
                                    <div style="position:relative;">
                                        <i class="fa-solid fa-user"
                                           style="
                                            position:absolute;
                                            left:13px;top:50%;
                                            transform:translateY(-50%);
                                            color:rgba(255,255,255,0.3);
                                            font-size:0.82rem;"></i>
                                        <input type="text"
                                               name="fullName"
                                               class="profile-input"
                                               style="padding-left:36px;"
                                               value="${student.fullName}"
                                               required/>
                                    </div>
                                </div>

                                <!-- Email (readonly) -->
                                <div class="mb-4">
                                    <label class="profile-label">
                                        Email Address
                                    </label>
                                    <div style="position:relative;">
                                        <i class="fa-solid fa-envelope"
                                           style="
                                            position:absolute;
                                            left:13px;top:50%;
                                            transform:translateY(-50%);
                                            color:rgba(255,255,255,0.2);
                                            font-size:0.82rem;"></i>
                                        <input type="email"
                                               class="profile-input"
                                               style="
                                                padding-left:36px;
                                                opacity:0.5;
                                                cursor:not-allowed;"
                                               value="${student.email}"
                                               readonly/>
                                    </div>
                                    <div style="
                                        font-size:0.72rem;
                                        color:rgba(255,255,255,0.3);
                                        margin-top:5px;">
                                        <i class="fa-solid fa-lock
                                                  me-1"></i>
                                        Email change nahi ho sakta
                                    </div>
                                </div>

                                <!-- Phone -->
                                <div class="mb-4">
                                    <label class="profile-label">
                                        Phone Number
                                    </label>
                                    <div style="position:relative;">
                                        <i class="fa-solid fa-phone"
                                           style="
                                            position:absolute;
                                            left:13px;top:50%;
                                            transform:translateY(-50%);
                                            color:rgba(255,255,255,0.3);
                                            font-size:0.82rem;"></i>
                                        <input type="tel"
                                               name="phone"
                                               class="profile-input"
                                               style="padding-left:36px;"
                                               placeholder="+91 98765 43210"
                                               value="${student.phone}"/>
                                    </div>
                                </div>

                                <!-- Bio -->
                                <div class="mb-4">
                                    <label class="profile-label">
                                        Bio
                                    </label>
                                    <textarea name="bio"
                                              class="profile-input"
                                              rows="4"
                                              style="height:auto;
                                                     resize:none;"
                                              placeholder="Apne baare mein kuch likho...">
                                        <c:out value="${student.bio}"/>
                                    </textarea>
                                </div>

                                <button type="submit"
                                        style="
                                    display:inline-flex;
                                    align-items:center;gap:8px;
                                    background:linear-gradient(
                                        135deg,#4e73df,#224abe);
                                    color:white;font-weight:700;
                                    font-size:0.9rem;
                                    padding:12px 24px;
                                    border-radius:10px;
                                    border:none;cursor:pointer;
                                    transition:all 0.2s ease;"
                                        onmouseover="
                                    this.style.transform=
                                        'translateY(-2px)';"
                                        onmouseout="
                                    this.style.transform=
                                        'translateY(0)';">
                                    <i class="fa-solid fa-floppy-disk"></i>
                                    Save Changes
                                </button>

                            </form>
                        </div>
                    </div>
                </div>

                <!-- Change Password Form -->
                <div id="section-password" style="display:none;">
                    <div style="
                        background:rgba(255,255,255,0.03);
                        border:1px solid rgba(255,255,255,0.07);
                        border-radius:16px;
                        overflow:hidden;">

                        <div style="
                            padding:16px 20px;
                            border-bottom:1px solid
                                rgba(255,255,255,0.07);">
                            <h5 style="color:white;font-weight:700;
                                       margin:0;font-size:1rem;">
                                <i class="fa-solid fa-lock me-2"
                                   style="color:#f6c23e;"></i>
                                Change Password
                            </h5>
                        </div>

                        <div style="padding:24px;">
                            <form action="${pageContext.request.contextPath}/student/profile/change-password"
                                  method="post">
                                <input type="hidden"
                                       name="${_csrf.parameterName}"
                                       value="${_csrf.token}"/>

                                <!-- Current Password -->
                                <div class="mb-4">
                                    <label class="profile-label">
                                        Current Password
                                    </label>
                                    <div style="position:relative;">
                                        <i class="fa-solid fa-lock"
                                           style="
                                            position:absolute;
                                            left:13px;top:50%;
                                            transform:translateY(-50%);
                                            color:rgba(255,255,255,0.3);
                                            font-size:0.82rem;"></i>
                                        <input type="password"
                                               name="currentPassword"
                                               class="profile-input"
                                               style="padding-left:36px;"
                                               placeholder="••••••••"
                                               required/>
                                    </div>
                                </div>

                                <!-- New Password -->
                                <div class="mb-4">
                                    <label class="profile-label">
                                        New Password
                                    </label>
                                    <div style="position:relative;">
                                        <i class="fa-solid fa-key"
                                           style="
                                            position:absolute;
                                            left:13px;top:50%;
                                            transform:translateY(-50%);
                                            color:rgba(255,255,255,0.3);
                                            font-size:0.82rem;"></i>
                                        <input type="password"
                                               name="newPassword"
                                               id="newPwd"
                                               class="profile-input"
                                               style="padding-left:36px;"
                                               placeholder="Min 8 characters"
                                               minlength="8"
                                               required
                                               oninput="checkStrength(this.value)"/>
                                    </div>
                                    <!-- Strength Bar -->
                                    <div style="
                                        margin-top:8px;
                                        display:flex;gap:4px;">
                                        <div id="s1" style="
                                            height:3px;flex:1;
                                            border-radius:2px;
                                            background:rgba(255,255,255,0.1);
                                            transition:all 0.3s;"></div>
                                        <div id="s2" style="
                                            height:3px;flex:1;
                                            border-radius:2px;
                                            background:rgba(255,255,255,0.1);
                                            transition:all 0.3s;"></div>
                                        <div id="s3" style="
                                            height:3px;flex:1;
                                            border-radius:2px;
                                            background:rgba(255,255,255,0.1);
                                            transition:all 0.3s;"></div>
                                        <div id="s4" style="
                                            height:3px;flex:1;
                                            border-radius:2px;
                                            background:rgba(255,255,255,0.1);
                                            transition:all 0.3s;"></div>
                                    </div>
                                    <div id="strengthTxt"
                                         style="font-size:0.72rem;
                                                color:rgba(255,255,255,0.3);
                                                margin-top:4px;">
                                    </div>
                                </div>

                                <!-- Confirm Password -->
                                <div class="mb-4">
                                    <label class="profile-label">
                                        Confirm New Password
                                    </label>
                                    <div style="position:relative;">
                                        <i class="fa-solid fa-shield-check"
                                           style="
                                            position:absolute;
                                            left:13px;top:50%;
                                            transform:translateY(-50%);
                                            color:rgba(255,255,255,0.3);
                                            font-size:0.82rem;"></i>
                                        <input type="password"
                                               name="confirmPassword"
                                               id="confPwd"
                                               class="profile-input"
                                               style="padding-left:36px;"
                                               placeholder="Dobara type karein"
                                               required
                                               oninput="checkMatch()"/>
                                    </div>
                                    <div id="matchTxt"
                                         style="font-size:0.72rem;
                                                margin-top:4px;"></div>
                                </div>

                                <!-- Info Box -->
                                <div style="
                                    background:rgba(78,115,223,0.06);
                                    border:1px solid rgba(78,115,223,0.15);
                                    border-radius:10px;
                                    padding:12px 14px;
                                    margin-bottom:20px;">
                                    <div style="
                                        font-size:0.78rem;
                                        color:rgba(255,255,255,0.5);
                                        line-height:1.6;">
                                        <i class="fa-solid fa-info-circle
                                                  me-1"
                                           style="color:#7b9ef0;"></i>
                                        Password mein hona chahiye:
                                        min 8 characters,
                                        ek uppercase letter,
                                        ek number.
                                    </div>
                                </div>

                                <button type="submit"
                                        id="pwdBtn"
                                        style="
                                    display:inline-flex;
                                    align-items:center;gap:8px;
                                    background:linear-gradient(
                                        135deg,#f6c23e,#e0a800);
                                    color:#1a1a2e;
                                    font-weight:800;
                                    font-size:0.9rem;
                                    padding:12px 24px;
                                    border-radius:10px;
                                    border:none;cursor:pointer;
                                    transition:all 0.2s ease;"
                                        onmouseover="
                                    this.style.transform=
                                        'translateY(-2px)';"
                                        onmouseout="
                                    this.style.transform=
                                        'translateY(0)';">
                                    <i class="fa-solid fa-shield-check"></i>
                                    Update Password
                                </button>

                            </form>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>
</div>

<style>
.profile-tab {
    flex: 1;
    padding: 9px 14px;
    border: 2px solid transparent;
    border-radius: 9px;
    background: transparent;
    color: rgba(255,255,255,0.4);
    font-size: 0.82rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
    font-family: 'Inter', sans-serif;
}
.profile-tab:hover {
    color: rgba(255,255,255,0.7);
}
.active-ptab {
    background: rgba(78,115,223,0.15);
    border-color: rgba(78,115,223,0.35);
    color: #7b9ef0;
}
.profile-label {
    display: block;
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.6px;
    color: rgba(255,255,255,0.4);
    margin-bottom: 8px;
}
.profile-input {
    width: 100%;
    background: rgba(255,255,255,0.04);
    border: 1.5px solid rgba(255,255,255,0.09);
    border-radius: 10px;
    padding: 11px 14px;
    color: #e8e8f0;
    font-size: 0.875rem;
    font-family: 'Inter', sans-serif;
    outline: none;
    transition: all 0.2s ease;
}
.profile-input::placeholder {
    color: rgba(255,255,255,0.2);
}
.profile-input:focus {
    border-color: rgba(78,115,223,0.5);
    background: rgba(78,115,223,0.06);
    box-shadow: 0 0 0 4px rgba(78,115,223,0.1);
    color: white;
}
</style>

<script>
function showTab(tab) {
    document.getElementById('section-profile')
        .style.display = tab === 'profile' ? '' : 'none';
    document.getElementById('section-password')
        .style.display = tab === 'password' ? '' : 'none';

    document.getElementById('tab-profile')
        .className = 'profile-tab' +
            (tab === 'profile' ? ' active-ptab' : '');
    document.getElementById('tab-password')
        .className = 'profile-tab' +
            (tab === 'password' ? ' active-ptab' : '');
}

function checkStrength(val) {
    var score = 0;
    if (val.length >= 8)            score++;
    if (/[A-Z]/.test(val))          score++;
    if (/[0-9]/.test(val))          score++;
    if (/[^A-Za-z0-9]/.test(val))   score++;

    var colors = ['#e74a3b','#f6c23e','#f6c23e','#1cc88a'];
    var labels = ['Weak','Fair','Good','Strong'];

    for (var i = 1; i <= 4; i++) {
        var el = document.getElementById('s' + i);
        el.style.background = i <= score
            ? colors[score - 1]
            : 'rgba(255,255,255,0.1)';
    }

    var txt = document.getElementById('strengthTxt');
    if (val.length > 0) {
        txt.textContent = labels[score - 1] || 'Weak';
        txt.style.color = colors[score - 1] || '#e74a3b';
    } else {
        txt.textContent = '';
    }
}

function checkMatch() {
    var p1 = document.getElementById('newPwd').value;
    var p2 = document.getElementById('confPwd').value;
    var mt = document.getElementById('matchTxt');
    if (p2.length === 0) {
        mt.textContent = '';
        return;
    }
    if (p1 === p2) {
        mt.textContent = '✓ Passwords match!';
        mt.style.color = '#1cc88a';
    } else {
        mt.textContent = '✗ Passwords do not match!';
        mt.style.color = '#e74a3b';
    }
}
</script>

<%@ include file="../common/footer.jsp" %>