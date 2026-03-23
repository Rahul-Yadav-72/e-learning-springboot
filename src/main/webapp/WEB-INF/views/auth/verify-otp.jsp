<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Verify OTP | E-Learn</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        body { background: #0a0a18; color: white; font-family: 'Inter', sans-serif; min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .otp-card { background: rgba(18, 18, 42, 0.95); padding: 40px; border-radius: 24px; box-shadow: 0 20px 50px rgba(0,0,0,0.5); width: 100%; max-width: 450px; text-align: center; border: 1px solid rgba(255,255,255,0.1); }
        .otp-input { width: 50px; height: 60px; border: 2px solid rgba(255,255,255,0.1); border-radius: 12px; background: rgba(255,255,255,0.05); text-align: center; font-size: 1.5rem; font-weight: bold; color: white; margin: 0 5px; transition: 0.3s; }
        .otp-input:focus { border-color: #4e73df; outline: none; background: rgba(78,115,223,0.1); }
        .btn-verify { width: 100%; padding: 14px; border-radius: 12px; background: linear-gradient(135deg, #4e73df, #224abe); border: none; color: white; font-weight: 700; margin-top: 25px; transition: 0.3s; }
        .btn-verify:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(78,115,223,0.4); }
    </style>
</head>
<body>
    <div class="otp-card">
        <div class="mb-4">
            <i class="fa-solid fa-shield-halved fa-3x text-primary mb-3"></i>
            <h3>Verify Your Email</h3>
            <p class="text-white-50 small">Enter the 6-digit code sent to <br/><strong>${email}</strong></p>
        </div>

        <form action="${pageContext.request.contextPath}/auth/verify-otp" method="post">
            <input type="hidden" name="email" value="${email}"/>
            <div class="d-flex justify-content-center mb-3">
                <input type="text" name="otp" class="otp-input" maxlength="6" placeholder="000000" style="width: 200px; letter-spacing: 10px;" required/>
            </div>
            <button type="submit" class="btn-verify">Verify & Activate</button>
        </form>

        <p class="mt-4 small text-white-50">Didn't receive code? <a href="#" class="text-primary text-decoration-none">Resend OTP</a></p>
    </div>
</body>
</html>