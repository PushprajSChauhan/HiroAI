<%@ page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Applicant Details | <%=application.getAttribute("appName")%></title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<style>
.mycard {
	background: #bdd5fa55;
	backdrop-filter: blur(10px);
	border: 1px solid rgba(255, 255, 255, 0.3);
	border-radius: 20px;
	color: #faf8f1;
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
@
keyframes expandProperty {from { width:0px;
	
}

to {
	width: var(--dynamic-width);
}

}

/* WebKit fallback */
@
-webkit-keyframes expandProperty {from { width:0px;
	
}

to {
	width: 650px;
}
}
</style>
</head>
<body>
	<%
	if (session.getAttribute("userId") == null || !"employer".equals(session.getAttribute("userRole"))) {
		response.sendRedirect("login.jsp");
		return;
	}

	// Backend se ye data pass hoga
	String[] personalDetails = (String[]) request.getAttribute("personalDetails");
	String applicantName = personalDetails[0];
	String resumeSummary = (String) request.getAttribute("summary");
	String[] education = (String[]) request.getAttribute("education");
	String[] workExperience = (String[]) request.getAttribute("workEx");
	List<String> skills = (List<String>) request.getAttribute("skills");
	%>
	<%@ include file="includes/header.jsp"%>

	<main class="container py-5">
		<!-- Applicant Name as Heading -->
		<div class="property is-animated">
			<h1 class="welcome-title code-typing">
				👤
				<%=applicantName != null ? applicantName : "Applicant Details"%>
			</h1>
		</div>

		<!-- Personal Details Card -->
		<div class="mycard shadow p-4 mb-4">
			<h4 class="job-section-title">
				<i class="fas fa-id-card me-2"></i>Personal Details
			</h4>
			<%
			for (String s : personalDetails) {
				if (s.contains(".com")) {
					String cleanUrl = s.replaceAll("\\s+", "");

					// https:// add karo agar nahi hai to
					if (!cleanUrl.startsWith("http://") && !cleanUrl.startsWith("https://")) {
				cleanUrl = "https://" + cleanUrl;
					}
			%>
			<a href="<%=cleanUrl%>" class="text-white"> <%=s.trim()%>
			</a><br>
			<%
			} else {
			%>
			<p class="text-white">
				<%=s%>
			</p>
			<%
			}
			}
			%>
		</div>

		<!-- Resume Summary Card -->
		<div class="mycard shadow p-4 mb-4">
			<h4 class="job-section-title">
				<i class="fas fa-file-alt me-2"></i>Resume Summary
			</h4>
			<p>
				<%=resumeSummary != null ? resumeSummary : "No summary available"%>
			</p>
		</div>

		<!-- Education Details Card -->
		<div class="mycard shadow p-4 mb-4">
			<h4 class="job-section-title">
				<i class="fas fa-graduation-cap me-2"></i>Education
			</h4>
			<%
			if (education.length != 0) {
				for (String s : education) {
			%>
			<%
			if (s.length() == 0) {
				continue;
			}
			%>

			<p class="text-white">
				<%=s%>
			</p>

			<%
			}
			} else {
			%>
			<p class="text-white">No Data Available</p>
			<%
			}
			%>
		</div>

		<!-- Work Experience Card -->
		<div class="mycard shadow p-4 mb-4">
			<h4 class="job-section-title">
				<i class="fas fa-briefcase me-2"></i>Work Experience
			</h4>
			<%
			if (workExperience.length != 0) {
				for (String s : workExperience) {
			%>
			<p class="text-white">
				<%=s%>
			</p>
			<%
			}
			} else {
			%>
			<p class="text-white">No Data Available</p>
			<%
			}
			%>
		</div>

		<!-- Skills Card -->
		<div class="mycard shadow p-4 mb-4">
			<h4 class="job-section-title">
				<i class="fas fa-tools me-2 mb-4"></i>Skills
			</h4>

			<%
			if (skills != null && !skills.isEmpty()) {
			%>

			<div class="row">
				<%
				int count = 0;
				for (String skill : skills) {
				%>

				<div class="col-md-2 col-4 mb-3">
					<span class="badge bg-success p-3 w-100 text-wrap border"> <%=skill.trim().toUpperCase()%>
					</span>
				</div>

				<%
				count++;
				if (count % 6 == 0) {
				%>
			</div>
			<div class="row">
				<%
				}
				}
				%>
			</div>

			<%
			} else {
			%>
			<p>No skills available</p>
			<%
			}
			%>
		</div>


		<!-- Back Button -->
		<div class="text-center mt-4">
			<a
				href="ViewApplicantsServlet?jobId=<%=request.getAttribute("jobId")%>"
				class="btn btn-gradient text-light"> <i
				class="bi bi-arrow-left me-2"></i>Back to Applicants
			</a>
		</div>
	</main>

	<%@ include file="includes/footer.jsp"%>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		window.onload = function() {
			const textElement = document.querySelector(".property h1");
			const container = document.querySelector(".property");

			if (textElement && container) {
				// Get exact required width (content width)
				const requiredWidth = textElement.scrollWidth + "px";

				// Apply the value to CSS variable
				container.style.setProperty("--dynamic-width", requiredWidth);
			}
		};
	</script>
</body>
</html>