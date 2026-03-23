<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<footer class="footer-main">
    <div class="container">
        <div class="row g-4">

            <div class="col-lg-4 col-md-6">
                <div class="footer-brand mb-3">
                    <div class="brand-icon-box">
                        <i class="fa-solid fa-graduation-cap"></i>
                    </div>
                    <span class="brand-text">
                        E-<span class="accent">Learn</span>
                    </span>
                </div>
                <p class="footer-description">
                    Empowering learners across India with world-class education. 
                    Master industry-relevant skills from expert mentors and 
                    earn recognized certifications to build your dream career.
                </p>

                <div class="d-flex gap-2">
                    <a href="#" class="footer-social" title="YouTube"><i class="fa-brands fa-youtube"></i></a>
                    <a href="#" class="footer-social" title="Instagram"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#" class="footer-social" title="LinkedIn"><i class="fa-brands fa-linkedin-in"></i></a>
                    <a href="#" class="footer-social" title="Twitter"><i class="fa-brands fa-x-twitter"></i></a>
                </div>
            </div>

            <div class="col-lg-2 col-md-6 col-6">
                <h6 class="footer-heading">Platform</h6>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/courses">All Courses</a></li>
                    <li><a href="${pageContext.request.contextPath}/courses">Categories</a></li>
                    <li><a href="${pageContext.request.contextPath}/courses">Instructors</a></li>
                    <li><a href="${pageContext.request.contextPath}/auth/login">Certifications</a></li>
                </ul>
            </div>

            <div class="col-lg-2 col-md-6 col-6">
                <h6 class="footer-heading">Account</h6>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/auth/login">Sign In</a></li>
                    <li><a href="${pageContext.request.contextPath}/auth/register">Create Account</a></li>
                    <li><a href="${pageContext.request.contextPath}/auth/login">Student Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/auth/login">Purchase History</a></li>
                </ul>
            </div>

            <div class="col-lg-4 col-md-6">
                <h6 class="footer-heading">Newsletter</h6>
                <p class="footer-sub-text">
                    Subscribe to get the latest course updates and exclusive offers directly in your inbox.
                </p>
                <div class="footer-newsletter">
                    <input type="email" id="newsEmail" placeholder="Enter your email" class="footer-input"/>
                    <button class="footer-sub-btn" onclick="handleSubscription()">
                        Subscribe
                    </button>
                </div>

                <div class="footer-stats-row">
                    <div class="stat-box">
                        <div class="footer-stat-num">50K+</div>
                        <div class="footer-stat-label">Learners</div>
                    </div>
                    <div class="stat-box">
                        <div class="footer-stat-num">1.2K+</div>
                        <div class="footer-stat-label">Courses</div>
                    </div>
                    <div class="stat-box">
                        <div class="footer-stat-num">250+</div>
                        <div class="footer-stat-label">Mentors</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="footer-bottom">
            <div class="copyright">
                &copy; 2026 E-Learn EdTech Platform. All rights reserved.
            </div>
            <div class="footer-legal-links">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Help Center</a>
            </div>
        </div>
    </div>
</footer>

<style>
.footer-main {
    background: #0a0a14;
    border-top: 1px solid rgba(255,255,255,0.06);
    padding: 60px 0 30px;
    position: relative;
    z-index: 10;
}
.footer-brand { display: flex; align-items: center; gap: 12px; }
.brand-icon-box {
    width: 40px; height: 40px; border-radius: 12px;
    background: linear-gradient(135deg, #4e73df, #224abe);
    display: flex; align-items: center; justify-content: center;
    color: white; font-size: 1.1rem; box-shadow: 0 4px 12px rgba(78,115,223,0.3);
}
.brand-text { font-size: 1.3rem; font-weight: 800; color: white; }
.brand-text .accent { color: #f6c23e; }

.footer-description {
    color: rgba(255,255,255,0.5); font-size: 0.85rem;
    line-height: 1.8; margin: 20px 0; max-width: 320px;
}
.footer-heading {
    color: white; font-weight: 700; font-size: 0.85rem;
    text-transform: uppercase; letter-spacing: 1px; margin-bottom: 20px;
}
.footer-links { list-style: none; padding: 0; }
.footer-links li { margin-bottom: 12px; }
.footer-links a {
    color: rgba(255,255,255,0.5); font-size: 0.85rem;
    text-decoration: none; transition: 0.3s;
}
.footer-links a:hover { color: #7b9ef0; transform: translateX(5px); }

.footer-newsletter { display: flex; gap: 8px; margin-top: 15px; }
.footer-input {
    background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);
    border-radius: 8px; padding: 10px 15px; color: white; flex: 1; font-size: 0.85rem; outline: none;
}
.footer-input:focus { border-color: #4e73df; }

.footer-sub-btn {
    background: linear-gradient(135deg, #4e73df, #224abe);
    border: none; border-radius: 8px; padding: 10px 20px;
    color: white; font-weight: 700; font-size: 0.85rem; transition: 0.3s;
}
.footer-sub-btn:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(78,115,223,0.4); }

.footer-stats-row { display: flex; gap: 30px; margin-top: 30px; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.06); }
.footer-stat-num { font-size: 1.2rem; font-weight: 800; color: white; }
.footer-stat-label { font-size: 0.75rem; color: rgba(255,255,255,0.4); text-transform: uppercase; }

.footer-bottom {
    margin-top: 50px; padding-top: 25px; border-top: 1px solid rgba(255,255,255,0.06);
    display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;
}
.copyright { color: rgba(255,255,255,0.3); font-size: 0.8rem; }
.footer-legal-links { display: flex; gap: 20px; }
.footer-legal-links a { color: rgba(255,255,255,0.3); text-decoration: none; font-size: 0.8rem; }
.footer-legal-links a:hover { color: white; }

/* Toast Notification Style */
.toast-dark {
    position: fixed; bottom: 30px; left: 30px; z-index: 9999;
    background: #1a1a2e; color: white; padding: 15px 25px;
    border-radius: 12px; border-left: 4px solid #4e73df;
    display: flex; align-items: center; gap: 12px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.5);
    animation: slideIn 0.4s ease forwards;
}
@keyframes slideIn { from { transform: translateX(-100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
</style>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Newsletter Subscription Logic
    function handleSubscription() {
        const email = document.getElementById('newsEmail').value;
        if(email && email.includes('@')) {
            showToast('Thank you for subscribing! Check your inbox soon.', 'success');
            document.getElementById('newsEmail').value = '';
        } else {
            showToast('Please enter a valid email address.', 'warning');
        }
    }

    // Modern Toast Notification
    function showToast(message, type = 'info') {
        const container = document.body;
        const toast = document.createElement('div');
        toast.className = `toast-dark border-\${type}`;
        
        const icon = type === 'success' ? 'fa-circle-check' : 'fa-circle-info';
        const color = type === 'success' ? '#1cc88a' : '#4e73df';
        toast.style.borderLeftColor = color;

        toast.innerHTML = `
            <i class="fa-solid \${icon}" style="color: \${color}"></i>
            <span>\${message}</span>
        `;
        container.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateY(20px)';
            toast.style.transition = '0.5s';
            setTimeout(() => toast.remove(), 500);
        }, 4000);
    }

    // Scroll to top visibility
    window.onscroll = function() {
        const btn = document.getElementById("backToTop");
        if (document.body.scrollTop > 300 || document.documentElement.scrollTop > 300) {
            btn.style.display = "flex";
        } else {
            btn.style.display = "none";
        }
    };
</script>