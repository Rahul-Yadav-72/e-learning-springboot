<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Register | E-Learn Platform</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
<style>
:root {
    --dark-1    : #0d0d1a;
    --dark-2    : #1a1a2e;
    --dark-3    : #16213e;
    --primary   : #4e73df;
    --success   : #1cc88a;
    --danger    : #e74a3b;
    --warning   : #f6c23e;
    --text      : #e8e8f0;
    --muted     : rgba(255,255,255,0.45);
    --border    : rgba(255,255,255,0.08);
}

body {
    font-family: 'Inter', sans-serif;
    background: var(--dark-1);
    color: var(--text);
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 24px 16px;
    position: relative;
}

/* Background Animation */
body::before {
    content: ''; position: fixed; inset: 0;
    background: radial-gradient(circle at 10% 10%, rgba(78,115,223,0.1) 0%, transparent 50%),
                radial-gradient(circle at 90% 90%, rgba(28,200,138,0.06) 0%, transparent 50%);
    z-index: -1;
}

.reg-wrapper {
    width: 100%; max-width: 960px;
    display: grid; grid-template-columns: 1fr 1.1fr;
    border-radius: 24px; overflow: hidden;
    box-shadow: 0 30px 80px rgba(0,0,0,0.6);
    border: 1px solid var(--border);
    z-index: 10;
}

@media (max-width: 768px) {
    .reg-wrapper { grid-template-columns: 1fr; }
    .reg-left { display: none; }
}

/* Left Panel */
.reg-left {
    background: linear-gradient(160deg, #0f3460 0%, #16213e 100%);
    padding: 48px 40px;
    display: flex; flex-direction: column; justify-content: space-between;
}

.reg-logo { display: flex; align-items: center; gap: 12px; }
.reg-logo-icon {
    width: 42px; height: 42px; border-radius: 12px;
    background: linear-gradient(135deg, var(--success), #13a66e);
    display: flex; align-items: center; justify-content: center; color: white;
    box-shadow: 0 8px 20px rgba(28,200,138,0.3);
}

.reg-tagline { font-size: 1.8rem; font-weight: 800; line-height: 1.2; margin-top: 40px; }
.reg-tagline span { color: var(--success); }

.reg-step { display: flex; gap: 15px; margin-bottom: 20px; }
.step-num {
    width: 30px; height: 30px; border-radius: 50%;
    background: rgba(28,200,138,0.2); color: var(--success);
    display: flex; align-items: center; justify-content: center;
    font-weight: 800; font-size: 0.8rem; flex-shrink: 0;
}

/* Right Panel */
.reg-right {
    background: rgba(10,10,24,0.98); backdrop-filter: blur(20px);
    padding: 40px;
}

.rfield-input {
    width: 100%; background: rgba(255,255,255,0.04);
    border: 1px solid var(--border); border-radius: 10px;
    padding: 12px 15px 12px 40px; color: white; font-size: 0.9rem;
    transition: 0.3s; outline: none;
}
.rfield-input:focus { border-color: var(--success); background: rgba(28,200,138,0.05); }

.role-cards { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 20px; }
.role-card {
    border: 1px solid var(--border); border-radius: 12px; padding: 15px;
    text-align: center; cursor: pointer; transition: 0.3s; background: rgba(255,255,255,0.02);
}
.role-card.selected { border-color: var(--success); background: rgba(28,200,138,0.1); color: var(--success); }

.btn-reg {
    width: 100%; border: none; border-radius: 12px; padding: 14px;
    background: linear-gradient(135deg, var(--success), #13a66e);
    color: white; font-weight: 700; transition: 0.3s;
}
.btn-reg:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(28,200,138,0.4); }

.pwd-bar-seg { flex: 1; height: 4px; border-radius: 2px; background: rgba(255,255,255,0.1); transition: 0.3s; }
</style>
</head>
<body>

<div class="reg-wrapper">
    <div class="reg-left">
        <div>
            <div class="reg-logo">
                <div class="reg-logo-icon"><i class="fa-solid fa-graduation-cap"></i></div>
                <span class="fw-bold fs-5">E-<span style="color:var(--warning)">Learn</span></span>
            </div>
            <h2 class="reg-tagline">Start Your<br/><span>Learning Journey.</span></h2>
            <p class="text-white-50 mt-3 small">Join 50,000+ students and get access to premium courses today.</p>
            
            <div class="mt-5">
                <div class="reg-step">
                    <div class="step-num">1</div>
                    <div><div class="fw-bold small">Create Account</div><div class="text-white-50" style="font-size:0.75rem">Free registration in 2 minutes</div></div>
                </div>
                <div class="reg-step">
                    <div class="step-num">2</div>
                    <div><div class="fw-bold small">Select Course</div><div class="text-white-50" style="font-size:0.75rem">Choose from 1,000+ topics</div></div>
                </div>
                <div class="reg-step">
                    <div class="step-num">3</div>
                    <div><div class="fw-bold small">Get Certified</div><div class="text-white-50" style="font-size:0.75rem">Earn industry-recognized certificates</div></div>
                </div>
            </div>
        </div>
        <div class="p-3 rounded-4" style="background: rgba(255,255,255,0.05); border: 1px solid var(--border);">
            <p class="small fst-italic text-white-50">"E-Learn transformed my career. I became a Data Scientist in just 6 months!"</p>
            <div class="d-flex align-items-center gap-2 mt-2">
                <div class="step-num" style="background: var(--primary)">R</div>
                <span class="small fw-bold">Rahul Yadav</span>
            </div>
        </div>
    </div>

    <div class="reg-right">
        <div class="mb-4">
            <h3 class="fw-bold">Create Free Account 🚀</h3>
            <p class="text-white-50 small">Already have an account? <a href="${pageContext.request.contextPath}/auth/login" class="text-decoration-none" style="color:var(--primary)">Login here</a></p>
        </div>

        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger border-0 small py-2 rounded-3"><i class="fa-solid fa-circle-exmark me-2"></i>${errorMsg}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/auth/register" method="post" id="regForm" onsubmit="return validateReg()">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <label class="text-white-50 small fw-bold mb-2">I AM REGISTERING AS</label>
            <div class="role-cards">
                <div class="role-card selected" id="cardStudent" onclick="pickRole('STUDENT')">
                    <i class="fa-solid fa-user-graduate mb-1"></i>
                    <div class="small fw-bold">Student</div>
                    <input type="radio" name="role" value="STUDENT" id="roleStudent" checked class="d-none"/>
                </div>
                <div class="role-card" id="cardTeacher" onclick="pickRole('TEACHER')">
                    <i class="fa-solid fa-chalkboard-user mb-1"></i>
                    <div class="small fw-bold">Instructor</div>
                    <input type="radio" name="role" value="TEACHER" id="roleTeacher" class="d-none"/>
                </div>
            </div>

            <div class="mb-3">
                <label class="text-white-50 small fw-bold mb-1">FULL NAME</label>
                <div class="position-relative">
                    <i class="fa-solid fa-user position-absolute top-50 start-0 translate-middle-y ms-3 text-white-50"></i>
                    <input type="text" name="fullName" class="rfield-input" placeholder="Enter your name" required/>
                </div>
            </div>

            <div class="mb-3">
                <label class="text-white-50 small fw-bold mb-1">EMAIL ADDRESS</label>
                <div class="position-relative">
                    <i class="fa-solid fa-envelope position-absolute top-50 start-0 translate-middle-y ms-3 text-white-50"></i>
                    <input type="email" name="email" class="rfield-input" placeholder="name@example.com" required/>
                </div>
            </div>

            <div class="row g-3 mb-3">
                <div class="col-6">
                    <label class="text-white-50 small fw-bold mb-1">PASSWORD</label>
                    <input type="password" name="password" id="pwdInput" class="rfield-input" style="padding-left:15px" placeholder="Min 6 chars" required oninput="checkStrength(this)"/>
                </div>
                <div class="col-6">
                    <label class="text-white-50 small fw-bold mb-1">CONFIRM</label>
                    <input type="password" name="confirmPassword" id="confirmInput" class="rfield-input" style="padding-left:15px" placeholder="Repeat password" required/>
                </div>
            </div>

            <div id="pwdStrength" class="mb-3" style="display:none">
                <div class="d-flex gap-1 mb-1">
                    <div class="pwd-bar-seg" id="seg1"></div>
                    <div class="pwd-bar-seg" id="seg2"></div>
                    <div class="pwd-bar-seg" id="seg3"></div>
                    <div class="pwd-bar-seg" id="seg4"></div>
                </div>
                <span id="strengthText" style="font-size:0.7rem"></span>
            </div>

            <div class="form-check small mb-4">
                <input class="form-check-input" type="checkbox" id="termsCheck" required>
                <label class="form-check-label text-white-50" for="termsCheck">
                    I agree to the <a href="#" class="text-decoration-none text-success">Terms</a> & <a href="#" class="text-decoration-none text-success">Privacy Policy</a>
                </label>
            </div>

            <button type="submit" class="btn-reg" id="regBtn">Create Account</button>
        </form>
    </div>
</div>

<script>
function pickRole(role) {
    document.getElementById('roleStudent').checked = (role === 'STUDENT');
    document.getElementById('roleTeacher').checked = (role === 'TEACHER');
    document.getElementById('cardStudent').classList.toggle('selected', role === 'STUDENT');
    document.getElementById('cardTeacher').classList.toggle('selected', role === 'TEACHER');
}

function checkStrength(el) {
    const val = el.value;
    const str = document.getElementById('pwdStrength');
    str.style.display = val.length > 0 ? 'block' : 'none';
    
    let score = 0;
    if (val.length >= 6) score++;
    if (/[A-Z]/.test(val) && /[0-9]/.test(val)) score += 2;
    if (/[^A-Za-z0-9]/.test(val)) score++;
    score = Math.min(score, 4);

    const colors = ['#e74a3b', '#f6c23e', '#4e73df', '#1cc88a'];
    const labels = ['Weak', 'Fair', 'Good', 'Strong'];
    
    for(let i=1; i<=4; i++) {
        document.getElementById('seg'+i).style.background = i <= score ? colors[score-1] : 'rgba(255,255,255,0.1)';
    }
    document.getElementById('strengthText').textContent = labels[score-1] || '';
    document.getElementById('strengthText').style.color = colors[score-1];
}

function validateReg() {
    if (document.getElementById('pwdInput').value !== document.getElementById('confirmInput').value) {
        alert("Passwords do not match!");
        return false;
    }
    const btn = document.getElementById('regBtn');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Processing...';
    return true;
}
</script>
</body>
</html>