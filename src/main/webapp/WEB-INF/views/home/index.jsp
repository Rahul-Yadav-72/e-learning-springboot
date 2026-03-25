<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Learn | Master Your Future</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --bg-dark: #050505;
            --surface: #0f0f0f;
            --emerald: #10b981;
            --emerald-hover: #059669;
            --indigo: #6366f1;
            --text-main: #f8fafc;
            --text-dim: #94a3b8;
            --nav-height: 80px;
        }

        body {
            background-color: var(--bg-dark);
            color: var(--text-main);
            font-family: 'Plus Jakarta Sans', sans-serif;
            margin: 0;
            overflow-x: hidden;
        }

        /* ── Modern Navbar ── */
        .modern-nav {
            background: rgba(5, 5, 5, 0.9);
            backdrop-filter: blur(15px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            height: var(--nav-height);
            display: flex;
            align-items: center;
            z-index: 1000;
        }

        .nav-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
        }

        .brand-link {
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand-icon {
            background: var(--emerald);
            color: white;
            width: 38px; height: 38px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem;
            box-shadow: 0 0 20px rgba(16, 185, 129, 0.3);
        }

        .brand-name { font-weight: 800; font-size: 1.5rem; color: white; letter-spacing: -0.5px; }

        .nav-search-wrap {
            position: relative;
            flex: 1;
            max-width: 500px;
            margin: 0 40px;
        }

        .search-icon { position: absolute; left: 18px; top: 12px; color: var(--text-dim); }
        
        .search-input {
            width: 100%;
            background: var(--surface);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 50px;
            padding: 10px 20px 10px 50px;
            color: white;
            font-size: 0.9rem;
            outline: none;
            transition: 0.3s;
        }

        .search-input:focus { border-color: var(--emerald); background: #161616; }

        .nav-auth-btns { display: flex; align-items: center; gap: 25px; }
        
        .login-link { color: var(--text-main); text-decoration: none; font-weight: 600; transition: 0.3s; }
        .login-link:hover { color: var(--emerald); }

        .signup-btn {
            background: var(--emerald);
            color: white;
            padding: 10px 24px;
            border-radius: 10px;
            font-weight: 700;
            text-decoration: none;
            transition: 0.3s;
            white-space: nowrap;
        }

        .signup-btn:hover { background: var(--emerald-hover); transform: translateY(-2px); color: white; }

        /* ── Hero Section ── */
        .hero-v2 {
            padding: 100px 0;
            min-height: calc(100vh - var(--nav-height));
            display: flex;
            align-items: center;
        }

        .hero-chip {
            display: inline-flex;
            align-items: center;
            background: rgba(99, 102, 241, 0.1);
            border: 1px solid rgba(99, 102, 241, 0.2);
            padding: 8px 18px;
            border-radius: 50px;
            color: var(--indigo);
            font-size: 0.85rem;
            font-weight: 700;
        }

        .hero-title {
            font-size: 4.5rem;
            font-weight: 800;
            line-height: 1.1;
            margin: 25px 0;
            letter-spacing: -2.5px;
        }

        .text-gradient {
            background: linear-gradient(to right, var(--emerald), var(--indigo));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-lead {
            font-size: 1.25rem;
            color: var(--text-dim);
            line-height: 1.7;
            max-width: 550px;
            margin-bottom: 40px;
        }

        .btn-hero-main {
            background: white;
            color: black;
            padding: 18px 40px;
            border-radius: 14px;
            font-weight: 800;
            text-decoration: none;
            font-size: 1.1rem;
            transition: 0.3s;
            display: inline-block;
        }

        .btn-hero-main:hover { transform: scale(1.05); box-shadow: 0 10px 30px rgba(255,255,255,0.1); }

        /* ── Image Card & Floating Elements ── */
        .hero-visual { position: relative; }
        .main-img {
            width: 100%;
            border-radius: 40px;
            border: 1px solid rgba(255,255,255,0.1);
            box-shadow: 0 50px 100px rgba(0,0,0,0.8);
        }

        .glass-float {
            position: absolute;
            background: rgba(15, 15, 15, 0.8);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255,255,255,0.1);
            padding: 15px 22px;
            border-radius: 20px;
            font-weight: 700;
            box-shadow: 0 20px 40px rgba(0,0,0,0.4);
        }

        .top-float { top: 40px; left: -30px; }
        .bottom-float { bottom: 40px; right: -10px; color: var(--emerald); }

        .pulse-dot {
            width: 10px; height: 10px;
            background: var(--emerald);
            border-radius: 50%;
            display: inline-block;
            margin-right: 8px;
            animation: pulse 1.5s infinite;
        }

        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.7); }
            70% { box-shadow: 0 0 0 12px rgba(16, 185, 129, 0); }
            100% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0); }
        }

        @media (max-width: 991px) {
            .nav-search-wrap { display: none; }
            .hero-title { font-size: 3rem; letter-spacing: -1.5px; }
            .hero-lead { font-size: 1.1rem; }
        }
    </style>
</head>
<body>

<nav class="modern-nav sticky-top">
    <div class="container nav-container">
        <a href="${pageContext.request.contextPath}/" class="brand-link">
            <div class="brand-icon"><i class="fa-solid fa-bolt-lightning"></i></div>
            <span class="brand-name">E-Learn</span>
        </a>
        
        <div class="nav-search-wrap">
            <i class="fa-solid fa-magnifying-glass search-icon"></i>
            <input type="text" placeholder="What do you want to learn today?" class="search-input">
        </div>

        <div class="nav-auth-btns">
            <a href="${pageContext.request.contextPath}/auth/login" class="login-link">Log in</a>
            <a href="${pageContext.request.contextPath}/auth/register" class="signup-btn">Sign up</a>
        </div>
    </div>
</nav>

<section class="hero-v2">
    <div class="container">
        <div class="row align-items-center g-5">
            <div class="col-lg-7">
                <div class="hero-chip">
                    <span>🚀 New Course: Full-Stack Java Masterclass</span>
                </div>
                <h1 class="hero-title">
                    Build skills that <br/>
                    <span class="text-gradient">matter most.</span>
                </h1>
                <p class="hero-lead">
                    Learn from industry experts, work on real projects, and join 50,000+ students mastering the latest tech stacks.
                </p>
                
                <div class="d-flex align-items-center gap-4">
                    <a href="${pageContext.request.contextPath}/courses" class="btn-hero-main">Explore Courses</a>
                    <div class="d-flex align-items-center gap-2">
                        <i class="fa-solid fa-play-circle fs-2 text-emerald"></i>
                        <span class="fw-bold text-dim">Watch Preview</span>
                    </div>
                </div>

                <div class="row g-4 mt-5 d-none d-sm-flex">
                    <div class="col-auto"><i class="fa-solid fa-circle-check text-emerald me-2"></i> 1.2K+ Courses</div>
                    <div class="col-auto"><i class="fa-solid fa-circle-check text-emerald me-2"></i> Verified Certificates</div>
                    <div class="col-auto"><i class="fa-solid fa-circle-check text-emerald me-2"></i> Expert Mentors</div>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="hero-visual">
                    <div class="glass-float top-float">
                        <i class="fa-solid fa-star text-warning me-2"></i>
                        <span>4.9 Avg Instructor Rating</span>
                    </div>
                    <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=1200" alt="Learning" class="main-img">
                    <div class="glass-float bottom-float">
                        <div class="pulse-dot"></div>
                        <span>150+ Live Classes Monthly</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>