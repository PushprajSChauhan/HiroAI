<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register | <%=application.getAttribute("appName")%></title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	__integrity__="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	__crossorigin__="anonymous" />
<link rel="stylesheet" href="css/style.css" />
<script>
	function showSpinner() {
		document.querySelector(".btn-register").disabled = true;
		document.getElementById("fullPageLoader").classList.remove("d-none");
	}
</script>
</head>
<body>
	<%@ include file="includes/header.jsp"%>
	<!-- registration form starts -->
	<div class="login-container mt-5 mb-5">
		<div class="login-card">
			<h1 class="text-center mb-4">Create Your Account</h1>

			<form action="SendRegisterOTPServlet" method="post"
				onsubmit="showSpinner()">
				<div class="mb-3">
					<input type="text" name="name" class="form-control"
						placeholder="Full Name" required />
				</div>

				<div class="mb-3">
					<input type="email" name="email" class="form-control"
						placeholder="Email" required />
				</div>

				<div class="mb-3">
					<input type="password" name="password" class="form-control"
						placeholder="Password" required />
				</div>

				<div class="mb-3">
					<select name="role" class="form-select">
						<option value="" disabled selected>Select your Role</option>
						<option value="user">Job Seeker</option>
						<option value="employer">Employer</option>
					</select>
				</div>
				<button class="btn btn-register mt-2 lr-custom-btn mx-auto text-light" type="submit"><span>Register</span></button>
			</form>
			<div class="text-center mt-3">
				<small>Already have an account? <a href="login.jsp"
					class="text-light">Login</a></small>
			</div>
		</div>
	</div>
	<!-- registration form ends -->

	<!-- ---------- FULL PAGE LOADER OVERLAY ---------- -->
	<div id="fullPageLoader" class="otp-loader-overlay d-none">
		<div class="loader-wrapper">
			<div class="loader-line">
				<span class="loader-letter">S</span>
				<span class="loader-letter">e</span>
				<span class="loader-letter">n</span>
				<span class="loader-letter">d</span>
				<span class="loader-letter">i</span>
				<span class="loader-letter">n</span>
				<span class="loader-letter">g</span>
				<span class="loader-letter">&nbsp;</span>
				<span class="loader-letter">O</span>
				<span class="loader-letter">T</span>
				<span class="loader-letter">P</span>
			</div>
			<div class="loader-line">
				<span class="loader-letter">P</span>
				<span class="loader-letter">l</span>
				<span class="loader-letter">e</span>
				<span class="loader-letter">a</span>
				<span class="loader-letter">s</span>
				<span class="loader-letter">e</span>
				<span class="loader-letter">&nbsp;</span>
				<span class="loader-letter">W</span>
				<span class="loader-letter">a</span>
				<span class="loader-letter">i</span>
				<span class="loader-letter">t</span>
			</div>

			<div class="loader"></div>
		</div>
	</div>

	<%
	if ("true".equals(request.getParameter("showOtp"))) {
	%>
	<div class="modal fade show" id="otpModal" style="display: block;"
		aria-modal="true" role="dialog">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content bg-dark text-white">
				<div class="modal-header">
					<h5 class="modal-title">Enter the OTP sent to your email</h5>
					<button class="btn-close btn-close-white" type="button"
						aria-label="Close" onclick="window.location.href='register.jsp'"></button>
				</div>
				<form action="VerifyRegisterOTPServlet" method="post">
					<div class="modal-body">
						<%
						if ("invalid".equals(request.getParameter("error"))) {
						%>
						<div class="alert alert-danger text-center py-1">❌ Invalid
							OTP.Please try again</div>
						<%
						}
						%>
						<input type="text" name="otp" class="form-control mt-2"
							placeholder="Enter OTP" required />
					</div>
					<div class="modal-footer">
						<button type="submit" class="btn btn-success w-100">Verify
							and Register</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<script>
		document.body.classList.add("modal-open");
	</script>
	<%
	}
	%>

	<%@ include file="includes/footer.jsp"%>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
		__integrity__="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
		__crossorigin__="anonymous"></script>
</body>
</html>
