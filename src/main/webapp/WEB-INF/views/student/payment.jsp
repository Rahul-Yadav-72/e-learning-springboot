<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Secure Checkout"/>
<%@ include file="../common/header.jsp" %>

<div class="row g-4 justify-content-center">
    <div class="col-lg-10">

        <div class="mb-4 text-center">
            <h3 class="text-white fw-800 mb-1">Complete Your Enrollment</h3>
            <p class="text-muted small"><i class="fa-solid fa-shield-halved me-1"></i> Secure 256-bit SSL Encrypted Payment</p>
        </div>

        <div class="row g-4">

            <div class="col-md-7">

                <div class="glass-card mb-4 border-0 shadow-sm" style="background: rgba(255,255,255,0.02);">
                    <div class="glass-card-body">
                        <div class="d-flex align-items-center gap-3">
                            <div style="width:50px; height:50px; border-radius:10px; background:linear-gradient(135deg,#4e73df,#224abe); display:flex; align-items:center; justify-content:center; color:white; font-size:1.2rem;">
                                <i class="fa-solid fa-graduation-cap"></i>
                            </div>
                            <div>
                                <div class="text-white fw-bold small">${course.title}</div>
                                <div class="text-muted" style="font-size: 0.75rem;">Instructor: ${course.instructor.fullName}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="glass-card mb-4">
                    <div class="glass-card-header">
                        <h6 class="text-white fw-bold mb-0"><i class="fa-solid fa-wallet me-2 text-primary"></i>Choose Payment Method</h6>
                    </div>
                    <div class="glass-card-body">
                        <div class="row g-3 mb-4">
                            <div class="col-6">
                                <div class="payment-card selected" onclick="selectPayment('razorpay',this)" id="pay-razorpay">
                                    <div class="payment-logo"><i class="fa-solid fa-bolt text-warning"></i></div>
                                    <div class="fw-bold text-white small mt-1">Instant Pay</div>
                                    <div class="opacity-50" style="font-size: 0.65rem;">UPI, Wallets, NetBanking</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="payment-card" onclick="selectPayment('card',this)" id="pay-card">
                                    <div class="payment-logo"><i class="fa-solid fa-credit-card text-primary"></i></div>
                                    <div class="fw-bold text-white small mt-1">Card Payment</div>
                                    <div class="opacity-50" style="font-size: 0.65rem;">Credit or Debit Cards</div>
                                </div>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/student/payment/process" method="post" id="paymentForm">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="courseId" value="${course.id}"/>
                            <input type="hidden" name="amount" value="${course.discountPrice != null ? course.discountPrice : course.price}"/>
                            <input type="hidden" name="razorpayPaymentId" value="DEMO_PAY_${System.currentTimeMillis()}"/>

                            <div class="mb-3">
                                <label class="form-label-dark small">Card Number</label>
                                <div class="position-relative">
                                    <input type="text" class="form-control-dark" placeholder="0000 0000 0000 0000" maxlength="19" oninput="formatCard(this)"/>
                                    <i class="fa-brands fa-cc-visa position-absolute top-50 end-0 translate-middle-y me-3 opacity-25"></i>
                                </div>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-6">
                                    <label class="form-label-dark small">Expiry Date</label>
                                    <input type="text" class="form-control-dark" placeholder="MM / YY" maxlength="7" oninput="formatExpiry(this)"/>
                                </div>
                                <div class="col-6">
                                    <label class="form-label-dark small">CVV Code</label>
                                    <input type="password" class="form-control-dark" placeholder="***" maxlength="3"/>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label-dark small">Cardholder Name</label>
                                <input type="text" class="form-control-dark" placeholder="Name as on card" value="${student.fullName}"/>
                            </div>

                            <button type="submit" class="btn-glow btn-success-glow w-100 py-3 justify-content-center">
                                <i class="fa-solid fa-lock me-2"></i>
                                Securely Pay &#8377;<c:choose>
                                    <c:when test="${course.discountPrice != null}">${course.discountPrice}</c:when>
                                    <c:otherwise>${course.price}</c:otherwise>
                                </c:choose>
                            </button>
                        </form>

                        <p class="text-center text-muted mt-3" style="font-size: 0.7rem;">
                            Your payment is handled via a secure gateway. We do not store your card details.
                        </p>
                    </div>
                </div>
            </div>

            <div class="col-md-5">
                <div class="glass-card sticky-top" style="top:90px;">
                    <div class="glass-card-header">
                        <h6 class="text-white fw-bold mb-0"><i class="fa-solid fa-receipt me-2 text-primary"></i>Order Summary</h6>
                    </div>
                    <div class="glass-card-body">
                        <div class="d-flex justify-content-between mb-2 small">
                            <span class="text-muted">Original Price</span>
                            <span class="text-white fw-bold">&#8377;${course.price}</span>
                        </div>
                        <c:if test="${course.discountPrice != null}">
                            <div class="d-flex justify-content-between mb-2 small text-success">
                                <span>Applied Discount</span>
                                <span class="fw-bold">-&#8377;${course.price - course.discountPrice}</span>
                            </div>
                        </c:if>
                        <div class="d-flex justify-content-between mb-3 small text-success">
                            <span>Enrollment Fee</span>
                            <span class="fw-bold">WAIVED</span>
                        </div>
                        <hr class="border-white-50 opacity-25">
                        <div class="d-flex justify-content-between mb-4">
                            <span class="text-white fw-bold">Total Amount</span>
                            <h4 class="text-primary fw-900 mb-0">
                                &#8377;<c:choose>
                                    <c:when test="${course.discountPrice != null}">${course.discountPrice}</c:when>
                                    <c:otherwise>${course.price}</c:otherwise>
                                </c:choose>
                            </h4>
                        </div>

                        <div class="p-3 rounded-3 text-center border-0 mb-4" style="background: rgba(28,200,138,0.05); border: 1px solid rgba(28,200,138,0.15) !important;">
                            <i class="fa-solid fa-shield-heart text-success fs-4 mb-2 d-block"></i>
                            <div class="text-white fw-bold small">30-Day Satisfaction Guarantee</div>
                            <p class="text-muted mb-0 mt-1" style="font-size: 0.65rem;">If you are not satisfied, we offer a full refund with no questions asked.</p>
                        </div>

                        <div class="d-flex flex-column gap-2 opacity-75">
                            <div class="small text-white"><i class="fa-solid fa-circle-check text-success me-2"></i> Lifetime access to materials</div>
                            <div class="small text-white"><i class="fa-solid fa-circle-check text-success me-2"></i> Shareable Certificate</div>
                            <div class="small text-white"><i class="fa-solid fa-circle-check text-success me-2"></i> Q&A with the instructor</div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
function selectPayment(method, el) {
    document.querySelectorAll('.payment-card').forEach(c => c.classList.remove('selected'));
    el.classList.add('selected');
}

function formatCard(input) {
    let v = input.value.replace(/\D/g, '').substring(0, 16);
    input.value = v.replace(/(.{4})/g, '$1 ').trim();
}

function formatExpiry(input) {
    let v = input.value.replace(/\D/g, '');
    if (v.length >= 2) v = v.substring(0, 2) + ' / ' + v.substring(2, 4);
    input.value = v;
}

document.getElementById('paymentForm').addEventListener('submit', function() {
    const btn = this.querySelector('button[type="submit"]');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Authorizing Payment...';
});
</script>

<%@ include file="../common/footer.jsp" %>