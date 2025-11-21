<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login | <%=application.getAttribute("appName")%></title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
<link rel="stylesheet" href="css/style.css" />
</head>
<body>
	<%@ include file="includes/header.jsp"%>
	<div class="login-container">
		<div class="login-card shadow">
			<h3 class="text-center mb-4">Welcome Back</h3>

			<%
			String error = (String) request.getAttribute("error"); //error tab ayegi jab login attempt fail hogaya ho and LoginServlet ne vapis bhej diya ho
			if (error != null) {
			%>
			<div class="alert alert-danger text-center py-1"><%=error%></div>
			<%
			}
			String registered = request.getParameter("registered");
			if ("true".equals(registered)) {
			%>
			<div class="alert alert-success text-center py-1">✅
				Registration Successful!</div>
			<%
			}
			%>

			<form action="LoginServlet" method="post">

				<div class="mb-3">
					<input type="email" name="email" class="form-control"
						placeholder="Email" required />
				</div>

				<div class="mb-3">
					<input type="password" name="password" class="form-control"
						placeholder="Password" required />
				</div>

				<button type="submit" class="btn btn-login mt-2">Login</button>

				<div class="text-center mt-3">
					<small>Don't have an account? <a href="register.jsp"
						class="text-warning">Register</a></small>
				</div>
			</form>
		</div>
	</div>
	<%@ include file="includes/footer.jsp"%>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
		crossorigin="anonymous"></script>
</body>
</html>