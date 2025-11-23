<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List,java.net.URLEncoder"%>
<%@ page import="hiroaiapp.pojo.ApplicationPojo,hiroaiapp.pojo.JobPojo"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Applicants | <%=application.getAttribute("appName")%></title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<style>
.applicant-card {
	border-radius: 1rem;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
	padding: 1.5rem;
	height: 100%;
	position: relative;
	transition: all 0.3s ease;
	background: rgba(255, 255, 255, 0.1);
	backdrop-filter: blur(10px);
	border: 2px solid rgba(255, 255, 255, 0.3);
	color: #faf8f1;
}

@
keyframes glowShift { 0% {
	box-shadow: 0 0 20px rgba(250, 234, 177, 0.7);
	border-color: #faeab1;
}

50
%
{
box-shadow
:
0
0
20px
rgba(
226
,
226
,
255
,
0.7
);
border-color
:
#4e54c8;
}
100
%
{
box-shadow
:
0
0
20px
rgba(
250
,
234
,
177
,
0.7
);
border-color
:
#faeab1;
}
}
.applicant-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 0 15px #246BFD;
}

.match-badge {
	position: absolute;
	bottom: 15px;
	right: 15px;
	background-color: #007bff;
	color: white;
	font-size: 12px;
	padding: 4px 10px;
	border-radius: 12px;
}

.small-btn {
	font-size: 0.8rem;
	padding: 3px 8px;
}

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
	width: 470px;
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
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
	<%@ include file="includes/header.jsp"%>
	<%
	if (session.getAttribute("userId") == null || !"employer".equals(session.getAttribute("userRole"))) {
		response.sendRedirect("login.jsp");
		return;
	}

	JobPojo job = (JobPojo) request.getAttribute("job");
	//System.out.println(job+" from viewApplicants.jsp");
	%>

	<main class="container py-5 mb-5">
		<div class="property is-animated">
			<h1 class="welcome-title code-typing">🔍 View Applicants</h1>
		</div>

		<div class="p-4 mb-4 mycard rounded-4">
			<h3><%=job.getTitle()%>
				@
				<%=job.getCompany()%></h3>
			<p class="text-light">
				<i class="bi bi-geo-alt"></i>
				<%=job.getLocation()%>
				&nbsp; <i class="bi bi-briefcase"></i>
				<%=job.getExperience()%>
				&nbsp; <i class="bi bi-currency-rupee"></i>
				<%=job.getPackageLpa()%>
				&nbsp; <i class="bi bi-people"></i>
				<%=job.getVacancies()%>
			</p>
		</div>

		<div class="mycard p-4 mb-4 rounded-4">
			<h4 class="filter-title mb-3">
				<i class="fas fa-filter me-2"></i>Filter Applicants
			</h4>
			<form method="get" action="ViewApplicantsServlet?jobId="
				<%=job.getId()%>>
				<input type="hidden" name="jobId" value="<%=job.getId()%>" />
				<div class="row align-items-center">
					<div class="col-md-4">
						<label for="status" class="form-label text-light">Filter
							by Status</label> <select name="status" class="form-select"
							onchange="this.form.submit()">
							<option value="" selected disabled>Select status</option>
							<option value="applied"
								<%="applied".equals(request.getAttribute("selectedStatus")) ? "selected" : ""%>>
								Applied</option>
							<option value="shortlisted"
								<%="shortListed".equals(request.getAttribute("selectedStatus")) ? "selected" : ""%>>
								Shortlisted</option>
							<option value="rejected"
								<%="rejected".equals(request.getAttribute("selectedStatus")) ? "selected" : ""%>>
								Rejected</option>
						</select>
					</div>
				</div>
			</form>
		</div>

		<h5 class="mb-3 mt-5">
			<i class="fas fa-users me-2"></i>Applicants List
		</h5>
		<div class="row g-4 mt-2">
			<%
			List<ApplicationPojo> list = (List<ApplicationPojo>) request.getAttribute("applicants");
			if (list != null && !list.isEmpty()) {
				for (ApplicationPojo obj : list) {
			%>

			<div class="col-md-6 col-lg-4">
				<div class="applicant-card">
					<h6 class="fw-bold">
						👤 User ID:
						<%=obj.getUserId()%></h6>
					<p class="mb-1">
						<i class="bi bi-bar-chart"></i>&nbsp; <strong>Status:</strong> <span
							class="text-capitalize"><%=obj.getStatus()%></span>
					</p>
					<p class="mb-1">
						<i class="bi bi-calendar-check"></i>&nbsp; <strong>Applied:</strong>
						<%=obj.getAppliedAt()%>
					</p>
					<p class="mb-1">
						<i class="bi bi-file-earmark-arrow-down"></i>&nbsp; <strong>Resume:</strong>
						<%
						if (obj.getResumePath() != null && !obj.getResumePath().isEmpty()) {
						%>
						<a
							href="DownloadResumeServlet?path=<%=URLEncoder.encode(obj.getResumePath(), "UTF-8")%>"
							target="_blank"
							class="btn btn-primary text-light btn-sm small-btn">Download</a>
						<%
						} else {
						%>
						<span class="text-danger">No Resume</span>
						<%
						}
						%>
					</p>
					<form method="get" action="UpdateApplicationServlet"
						class="d-flex gap-2 mt-3">
						<input type="hidden" name="appId" value="<%=obj.getId()%>" /> <input
							type="hidden" name="jobId" value="<%=obj.getJobId()%>" />
						<%
						if (obj.getStatus().equals("applied")) {
						%>
						<button type="submit" name="status" value="shortlisted"
							class="btn btn-success btn-sm">Shortlist</button>
						<button type="submit" name="status" value="rejected"
							class="btn btn-danger btn-sm">Reject</button>
						<%
						} else if (obj.getStatus().equals("shortlisted")) {
						%>
						<button type="submit" name="status" value="rejected"
							class="btn btn-danger btn-sm">Reject</button>
						<%
						} else {
						%>
						<span class="badge bg-danger col-md-2 p-2 px-1 mt-2 text-white">Rejected</span>
						<br />
						<%
						}
						%>

					</form>
					<form action="" method="get">
						<input type="hidden" name="userId" value="<%=obj.getUserId()%>">
						<a
							href="ViewFullDetailsServlet?id=<%=obj.getUserId()%>&jobId=<%=obj.getJobId()%>"
							class="btn btn-gradient btn-sm mt-2 text-light"> <i
							class="bi bi-eye me-1"></i> View Full Details
						</a>
					</form>
					<div class="match-badge">
						Match: <strong><%=obj.getScore()%>%</strong>
					</div>
				</div>
			</div>
			<%
			}
			} else {
			%>
			<div class="col-12 mb-5">
				<h4 class="text-center text-warning">
					<i class="fas fa-exclamation-triangle me-2"></i>No Applications
					found for this status
				</h4>
			</div>
			<%
			}
			%>
		</div>
	</main>

	<%@ include file="includes/footer.jsp"%>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		
	<%if ("1".equals(request.getAttribute("update"))) {%>
		Swal.fire({
			icon : 'success',
			title : 'Application Status Updated Successfully',
			showConfirmButton : false,
			timer : 1500
		})
	<%}%>
		
	</script>
</body>
</html>
