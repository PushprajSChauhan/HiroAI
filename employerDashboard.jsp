<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employer Dashboard | <%=application.getAttribute("appName")%></title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous" />
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet">
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
	box-shadow: 0 0 5px #00e8f0;
}

.is-animated {
	font-weight: bold;
	padding: 0;
}

div.is-animated h1 {
	padding: 0 10px;
	width: 200px;
	font-size: 3rem;
}

.property {
	text-align: left;
	border-right: 2px solid #fff;
	border-bottom: 2px solid #fff;
	width: 0;
	margin-bottom: 3rem;
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
	width: var(--dynamic-width);
}

}

/* WebKit fallback */
@-webkit-keyframes expandProperty {from { width:0px;
	
}

to {
	width: 420px;
}

}
</style>
</head>
<body>
	<%@ include file="includes/header.jsp"%>
	<%
	if (session == null || session.getAttribute("userId") == null
			|| !"employer".equals((String) session.getAttribute("userRole"))) {
		response.sendRedirect("login.jsp");
		return;
	}
	%>

	<main class="container py-5">
		<div class="property is-animated">
			<h1 class="code-typing">
				👨🏻‍💼 Welcome,
				<%=session.getAttribute("userName")%>
			</h1>
		</div>


		<div class="p-4 mb-5 job-form-card mycard">
			<h4 class="mb-3">Post a New Job</h4>
			<form action="PostJobServlet" method="post">
				<!-- Row 1: Job Title and Company Name side by side -->
				<div class="row mb-3">
					<div class="col-md-6">
						<input type="text" class="form-control" placeholder="Job Title"
							name="title" required />
					</div>
					<div class="col-md-6">
						<input type="text" name="company" class="form-control"
							placeholder="Company Name" required />
					</div>
				</div>

				<!-- Row 2: Job Description (full width) -->
				<div class="mb-3">
					<textarea name="description" class="form-control"
						placeholder="Job Description" required></textarea>
				</div>

				<!-- Row 3: Required Skills and Vacancies side by side -->
				<div class="row mb-3">
					<div class="col-md-6">
						<input type="text" name="skills" class="form-control"
							placeholder="Required Skills (Comma Separated)" required />
					</div>
					<div class="col-md-6">
						<input type="number" name="vacancies" class="form-control"
							placeholder="Number of Vacancies" required />
					</div>
				</div>

				<!-- Row 4: Location, Experience, Package in one row (styled dropdowns) -->
				<div class="row mb-5">
					<div class="col-md-4">
						<select name="location" class="form-select">
							<option value="" disabled selected>Select location</option>
							<option value="Bangalore">Bangalore</option>
							<option value="Mumbai">Mumbai</option>
							<option value="Pune">Pune</option>
							<option value="Noida">Noida</option>
							<option value="Delhi">Delhi</option>
							<option value="Hyderabad">Hyderabad</option>
						</select>
					</div>
					<div class="col-md-4">
						<select name="experience" class="form-select">
							<option value="" disabled selected>Select Experience</option>
							<option value="Fresher">Fresher</option>
							<option value="0-1 years">0-1 Years</option>
							<option value="1-2 years">1-2 Years</option>
							<option value="2-3 years">2-3 Years</option>
							<option value="3-5 years">3-5 Years</option>
							<option value="5+ years">5+ Years</option>
						</select>
					</div>
					<div class="col-md-4">
						<select name="packageLpa" class="form-select">
							<option value="" disabled selected>Package(LPA)</option>
							<option value="1-3 Lacs P.A.">1-3 LPA</option>
							<option value="3-5 Lacs P.A.">3-5 LPA</option>
							<option value="5-7 Lacs P.A.">5-7 LPA</option>
							<option value="7-10 Lacs P.A.">7-10 LPA</option>
							<option value="10+ Lacs P.A.">10+ LPA</option>
						</select>
					</div>
				</div>

				<button type="submit" class="custom-btn mx-auto">
					<span>Post Job</span>
				</button>
			</form>
		</div>


		<!-- search and filter jobs section starts -->
		<form action="EmployerDashboardServlet" method="post" class="mb-4"
			style="margin-left: 2rem;">
			<div class="row g-4">
				<div class="col-md-4">
					<input type="text" name="search" class="form-control"
						placeholder="Search by title" value="${param.search}" />
					<!-- yaha par param.search se ham search parameter ki value fetch krrhe hain request object se -->
				</div>

				<div class="col-md-3">
					<select name="status" class="form-select custom-select">
						<option value="" selected disabled>Filter by Status</option>
						<option value="active" ${param.status=='active' ? 'selected' : ''}>Active</option>
						<option value="inactive"
							${param.status=='inactive' ? 'selected' : ''}>Inactive</option>
					</select>
				</div>

				<div class="col-md-3">
					<select name="sort" class="form-select custom-select">
						<option value="" selected disabled>Sort by Number of
							Applicants</option>
						<option value="asc" ${param.sort=='asc' ? 'selected' : ''}>Least
							to most</option>
						<option value="desc" ${param.sort=='desc' ? 'selected' : ''}>Most
							to least</option>
					</select>
				</div>

				<div class="col-md-2" style="margin-top: 22px;">
					<button type="submit" class="lr-custom-btn">
						<span>Search</span>
					</button>
				</div>
			</div>
		</form>
		<!-- search and filter jobs section ends -->
		<!-- now we have to fetch all Jobs posted by the employer and show them in a table -->
		<%
java.util.List<hiroaiapp.pojo.JobPojo> jobList = (java.util.List<hiroaiapp.pojo.JobPojo>) request.getAttribute("jobList");
String companyName = (String) session.getAttribute("companyName"); // Get from session if available
%>
<div class="card p-4 mb-5 mycard">
    <%
    if (jobList != null && !jobList.isEmpty()) {
    %>
        <h4 class="mb-3">
            Jobs Posted by <%=jobList.get(0).getCompany()%>
        </h4>
        <table class="table text-light text-center">
            <thead>
                <tr>
                    <th>Job Title</th>
                    <th>Applicants</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                for (hiroaiapp.pojo.JobPojo job : jobList) {
                %>
                <tr>
                    <td><%=job.getTitle()%></td>
                    <td><%=job.getApplicantsCount()%></td>
                    <td><%=job.getStatus().toUpperCase()%></td>
                    <td class="gap-3">
                        <a href="ViewApplicantsServlet?jobId=<%=job.getId()%>"
                           class="btn btn-sm text-light btn-outline-info">👀 View</a>
                        <a href="ToggleJobStatusServlet?jobId=<%=job.getId()%>"
                           class="btn btn-sm <%="active".equals(job.getStatus()) ? "btn-outline-danger text-light" : "btn-outline-warning text-light"%>">
                           <%="active".equals(job.getStatus()) ? "🔽 Deactivate" : "🔼 Activate"%>
                        </a>
                    </td>
                </tr>
                <%
                }
                %>
            </tbody>
        </table>
    <%
    } else {
    %>
        <h4 class="mb-3">Your Job Postings</h4>
        <div class="text-center text-warning py-5">
            <p class="fs-5">
                <i class="fas fa-exclamation-triangle me-2"></i>No Jobs Posted Yet!
            </p>
            <p class="text-light">Start by posting your first job using the form above.</p>
        </div>
    <%
    }
    %>
</div>

	</main>
	<!-- now we will use Sweet Alert library to generate custom popups for notifying about job posting action status -->
	<%
	String success = request.getParameter("success");
	if ("1".equals(success)) {
	%>
	<script>
		Swal.fire({
			title : "Job Posted ✅",
			text : "The job has been successfully posted",
			timer : 2000,
			icon : "success",
			showConfirmButton : false
		});
	</script>
	<%
	}
	String error = request.getParameter("error");
	if ("1".equals(error)) {
	%>
	<script>
		Swal.fire({
			title : "Error!",
			text : "Something went wrong. Please try again",
			timer : 2000,
			icon : "error",
			confirmButtonText : "Okay"
		});
	</script>
	<%
	}
	String toggleStatus = request.getParameter("toggle");
	if ("activated".equals(toggleStatus)) {
	%>
	<script>
		Swal.fire({
			title : "Job Activated ✅",
			text : "The job posting is now active",
			timer : 2000,
			icon : "success",
			showConfirmButton : false
		});
	</script>
	<%
	} else if ("deactivated".equals(toggleStatus)) {
	%>
	<script>
		Swal.fire({
			title : "Job Deactivated ⏸️",
			text : "The job posting is now inactive",
			timer : 2000,
			icon : "info",
			showConfirmButton : false
		});
	</script>
	<%
	}
	%>
	<%@ include file="includes/footer.jsp"%>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
		crossorigin="anonymous"></script>
	<script>
		window.onload = function() {
			const textElement = document.querySelector(".property h1");
			const container = document.querySelector(".property");

			if (textElement && container) {
				// Get exact required width (content width)
				const requiredWidth = (textElement.scrollWidth) + 10 + "px";

				// Apply the value to CSS variable
				container.style.setProperty("--dynamic-width", requiredWidth);
			}
		};
	</script>
</body>
</html>
