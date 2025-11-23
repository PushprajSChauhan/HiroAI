<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.List,hiroaiapp.pojo.JobPojo,hiroaiapp.pojo.UserPojo"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Panel | HiroAI</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
<link rel="stylesheet" href="css/style.css" />
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
.mycard {
	background: rgba(255, 255, 255, 0.1);
	backdrop-filter: blur(10px);
	border: 1px solid rgba(255, 255, 255, 0.3);
	border-radius: 20px;
	box-shadow: 0 0 10px #00e8f0;
}

.is-animated {
	font-weight: bold;
	padding: 0;
}

.is-animated h1 {
	padding: 0 10px;
	width: 200px;
	font-size: 3rem;
}

.property {
	text-align: left;
	border-right: 2px solid #fff;
	border-bottom: 2px solid #fff;
	width: 0;
	margin-bottom: 2rem;
	overflow: hidden;
	display: inline-block;
	white-space: nowrap;
	/* STANDARD ANIMATION */
	animation-name: expandProperty;
	animation-delay: 0.5s;
	animation-duration: 1s;
	animation-fill-mode: forwards;
	animation-timing-function: ease-in-out;
	/* Vendor prefix (optional, fallback) */
	-webkit-animation-name: expandProperty;
	-webkit-animation-delay: 0.5s;
	-webkit-animation-duration: 1s;
	-webkit-animation-fill-mode: forwards;
	-webkit-animation-timing-function: ease-in-out;
}

/* STANDARD KEYFRAMES */
@keyframes expandProperty {from { width:0px;
	
}

to {
	width: 530px;
}

}

/* WebKit fallback */
@-webkit-keyframes expandProperty {from { width:0px;
	
}

to {
	width: 650px;
}
}
</style>
</head>
<body>
	<%@ include file="includes/header.jsp"%>
	<%
	if (session == null || session.getAttribute("userId") == null
			|| !"admin".equals((String) session.getAttribute("userRole"))) {
		response.sendRedirect("login.jsp");
		return;
	}
	%>
	<div class="container py-3 mt-3">
		<div class="property is-animated">
			<h1 class="code-typing">👑 Admin Dashboard</h1>
		</div>


		<!-- filter section starts -->
		<div class="p-4 mb-4">
			<h4 class="mb-3">Filter Users</h4>
			<form action="AdminPanelServlet" method="get">
				<div class="row g-2">
					<div class="col-md-4">
						<input type="text" name="search" class="form-control"
							placeholder="Search by name or email" />
					</div>

					<div class="col-md-3">
						<select name="role" class="form-select">
							<option value="" selected disabled>All roles</option>
							<option value="employer">Employer</option>
							<option value="user">User</option>
						</select>
					</div>

					<div class="col-md-3">
						<select name="status" class="form-select">
							<option value="" selected disabled>All status</option>
							<option value="active">Active</option>
							<option value="blocked">Blocked</option>
						</select>
					</div>

					<div class="col-md-2" style="margin-top: 5px">
						<button type="submit" class="lr-custom-btn"><span style="padding: 12px 65px">Search</span></button>
					</div>
				</div>
			</form>
		</div>
		<!-- filter section ends -->

		<!-- user table starts -->
		<div class="card p-4 mb-5 mycard">
			<h4 class="mb-3">👥 Users</h4>
			<table class="table text-light">
				<thead>
					<tr class="text-center">
						<th>Name</th>
						<th>Email</th>
						<th>Role</th>
						<th>Status</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<%
					List<UserPojo> users = (List<UserPojo>) request.getAttribute("users");
					if (users != null && !users.isEmpty()) {
						for (int i = 0; i < users.size(); i++) {
					%>
					<tr class="text-center">
						<td><%=users.get(i).getName()%></td>
						<td><%=users.get(i).getEmail()%></td>
						<td><%=users.get(i).getRole().toUpperCase()%></td>
						<td><%=users.get(i).getStatus().toUpperCase()%></td>
						<td>
							<%
							if ("active".equals(users.get(i).getStatus())) {
							%> <a
							href="UpdateUserStatusServlet?userId=<%=users.get(i).getId()%>&action=block&role=<%=users.get(i).getRole()%>"
							class="btn btn-outline-danger text-white">🚫 Block</a> <%
 } else {
 %> <a
							href="UpdateUserStatusServlet?userId=<%=users.get(i).getId()%>&action=unblock&role=<%=users.get(i).getRole()%>"
							class="btn btn-outline-success text-white">☑️ Unblock</a>
						</td>
						<%
						}
						%>
					</tr>
					<%
					}
					} else {
					%>
					<tr>
						<td colspan="5" class="text-center"><div
								class="d-flex justify-content-center align-items-center text-warning">
								<i class="fas fa-exclamation-circle"></i>&nbsp;
								<h5 class="mt-2">No Jobs Found</h5>
							</div>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</div>
		<!--user table ends  -->

		<!-- manage job listing starts -->
		<div class="card p-4 mb-5 mycard">
			<h4 class="mb-3">📋 Manage Job Listings</h4>
			<%
			List<JobPojo> jobs = (List<JobPojo>) request.getAttribute("jobs");
			if (jobs != null && !jobs.isEmpty()) {
			%>
			<table class="table text-light">
				<thead>
					<tr class="text-center">
						<th>Job Title</th>
						<th>Company</th>
						<th>Applicants</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<%
					for (int i = 0; i < jobs.size(); i++) {
					%>
					<tr class="text-center">
						<td><%=jobs.get(i).getTitle()%></td>
						<td><%=jobs.get(i).getCompany()%></td>
						<td><%=jobs.get(i).getApplicantsCount()%></td>
						<td><a href="DeleteJobServlet?jobId=<%=jobs.get(i).getId()%>"
							class="btn btn-outline-danger text-white">🗑️ Remove</a></td>
					</tr>
					<%
					}
					} else {
					%>
					<tr>
						<td colspan="4" class="text-center"><div
								class="d-flex justify-content-center align-items-center text-warning">
								<i class="fas fa-exclamation-circle"></i>&nbsp;
								<h5 class="mt-2">No Jobs Found</h5>
							</div>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</div>
		<!-- manage job listing ends -->
	</div>
	<%@ include file="includes/footer.jsp"%>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
		crossorigin="anonymous"></script>
	<script>
		
	<%if ("1".equals(request.getAttribute("userSuccess"))) {%>
		Swal.fire({
			icon : 'success',
			title : 'User Status Updated Successfully',
			showConfirmButton : false,
			timer : 1500
		})
	<%} else if ("0".equals(request.getAttribute("userSuccess"))) {%>
		Swal.fire({
			icon : 'error',
			title : 'User Status Updation Failed',
			showConfirmButton : false,
			timer : 1500
		})
	<%}%>
		
	<%if ("1".equals(request.getParameter("delete"))) {%>
		Swal.fire({
			icon : 'success',
			title : 'Job Deleted Successfully',
			showConfirmButton : false,
			timer : 1500
		})
	<%} else if ("0".equals(request.getParameter("delete"))) {%>
		Swal.fire({
			icon : 'success',
			title : 'Job Deletion Failed',
			showConfirmButton : false,
			timer : 1500
		})
	<%}%>
		
	</script>
</body>
</html>
