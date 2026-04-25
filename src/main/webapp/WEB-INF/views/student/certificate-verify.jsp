<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Certificate Verification"/>
<%@ include file="../common/header.jsp" %>


<style>
    :root {
        --primary-blue: #1e3a8a;
        --gold-classic: #b45309;
        --bg-body: #020617;
        --cert-white: #ffffff;
    }

    body { background-color: var(--bg-body); font-family: 'Inter', sans-serif; }

    /* ── Certificate Container ── */
    .cert-wrapper {
        padding: 60px 20px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }

    .cert-card {
        background: var(--cert-white);
        width: 1000px;
        padding: 60px 80px;
        border: 20px solid var(--primary-blue);
        position: relative;
        text-align: center;
        box-shadow: 0 40px 100px rgba(0,0,0,0.5);
        color: #1f2937;
    }

    .cert-card::before {
        content: ''; position: absolute; inset: 5px;
        border: 2px solid var(--gold-classic);
        pointer-events: none;
    }

    .brand-title { font-size: 3rem; font-weight: 900; color: var(--primary-blue); margin-bottom: 5px; }
    .subtitle { text-transform: uppercase; letter-spacing: 5px; font-weight: 700; color: #6b7280; font-size: 0.8rem; margin-bottom: 40px; }
    .cert-type { font-size: 1.2rem; color: var(--gold-classic); font-weight: 800; text-transform: uppercase; letter-spacing: 3px; margin-bottom: 20px; }
    .present-text { font-size: 1.4rem; color: #4b5563; font-style: italic; margin-bottom: 15px; }
    
    .recipient-name { 
        font-family: 'Times New Roman', serif;
        font-size: 4.5rem; font-weight: 900; color: #111827;
        border-bottom: 3px solid #e5e7eb; display: inline-block;
        padding: 0 40px 10px; margin-bottom: 30px;
    }

    .course-info { font-size: 1.5rem; color: #4b5563; margin-bottom: 10px; }
    .course-title { font-size: 2.2rem; font-weight: 800; color: var(--primary-blue); margin-bottom: 40px; }

    .meta-row {
        display: flex; justify-content: space-between; align-items: flex-end;
        margin-top: 60px; padding: 0 50px;
    }

    .meta-col { width: 30%; text-align: center; }
    .sig-line { border-top: 2px solid #374151; margin-top: 10px; padding-top: 10px; }
    .meta-val { font-weight: 800; font-size: 1.1rem; color: #111827; }
    .meta-lab { font-size: 0.75rem; text-transform: uppercase; color: #6b7280; font-weight: 700; letter-spacing: 1px; }

    .cert-footer { margin-top: 50px; font-family: monospace; color: #9ca3af; font-weight: 700; }

    .btn-action-row { margin-top: 40px; display: flex; justify-content: center; gap: 15px; }

    /* ── CSS PRINT FIXES (Prevents Double Printing) ── */
    @media print {
        @page { size: A4 landscape; margin: 0; }
        
        /* Hide everything by default */
        body * { visibility: hidden; overflow: hidden; }
        
        /* Show only the capture area and its children */
        #capture, #capture * { visibility: visible; }
        
        #capture {
            position: absolute;
            left: 0;
            top: 0;
            width: 100vw !important;
            height: 100vh !important;
            border: 20px solid var(--primary-blue) !important;
            margin: 0 !important;
            padding: 60px 80px !important;
            box-shadow: none !important;
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
        }

        /* Hide specific elements that cause double pages */
        .btn-action-row, .elearn-navbar, .footer-main, .header-main { display: none !important; }
    }
</style>

<div class="cert-wrapper">
    <c:choose>
        <c:when test="${valid}">
            <div class="cert-card" id="capture">
                <div class="brand-title">EduPortal</div>
                <div class="subtitle">Academy Excellence Credential</div>

                <div class="cert-type">Certificate of Completion</div>
                <div class="present-text">This certifies that</div>
                <div class="recipient-name">${certificate.user.fullName}</div>

                <div class="course-info">has successfully completed the course</div>
                <div class="course-title">${certificate.course.title}</div>
                
                <div class="meta-row">
                    <div class="meta-col">
                        <div class="meta-val">
                            <c:choose>
                                <c:when test="${not empty certificate.issueDate}">
                                    <c:set var="rawDate" value="${certificate.issueDate.toString()}"/>
                                    <c:out value="${rawDate.substring(8,10)}-${rawDate.substring(5,7)}-${rawDate.substring(0,4)}"/>
                                </c:when>
                                <c:otherwise>
                                    <jsp:useBean id="now" class="java.util.Date" />
                                    <fmt:formatDate value="${now}" pattern="dd-MM-yyyy" />
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="sig-line"></div>
                        <div class="meta-lab">Date of Achievement</div>
                    </div>
                    <div class="meta-col">
                        <div class="meta-val">Verified Online</div>
                        <div class="sig-line"></div>
                        <div class="meta-lab">Credential Status</div>
                    </div>
                    <div class="meta-col">
                        <div class="meta-val">EduPortal Admin</div>
                        <div class="sig-line"></div>
                        <div class="meta-lab">Program Director</div>
                    </div>
                </div>

                <div class="cert-footer">
                    Certificate ID: ${certificate.certificateNumber}
                </div>
            </div>

            <div class="btn-action-row pb-5">
                <button onclick="window.print()" class="btn btn-warning px-5 py-3 rounded-pill fw-bold shadow-lg">
                    <i class="fa-solid fa-file-pdf me-2"></i> Download PDF
                </button>
                <a href="javascript:history.back()" class="btn btn-outline-light px-5 py-3 rounded-pill fw-bold">
                    <i class="fa-solid fa-arrow-left me-2"></i> Go Back
                </a>
            </div>
        </c:when>
        
        <c:otherwise>
            <div class="text-center py-5" style="color: white; max-width: 500px; margin: auto;">
                <i class="fa-solid fa-circle-exclamation text-danger display-1 mb-4"></i>
                <h2 class="fw-bold">Invalid Credential</h2>
                <p class="text-white-50">The credential ID <b>${certNumber}</b> does not exist in our records.</p>
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary rounded-pill w-100 mt-4 py-3 fw-bold">Return Home</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="../common/footer.jsp" %>