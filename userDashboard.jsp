<%@ page import="hiroaiapp.pojo.JobPojo"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<title>User Dashboard | <%=application.getAttribute("appName")%>
</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
	crossorigin="anonymous">
<link href="css/style.css" rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
.custom {
	background-color: #fff;
	font-family: "Lora";
	color: #4e54c8;
	font-weight: bold;
}

.custom:hover {
	color: #2c2c84;
	background-color: #e2e2ff;
}

.mycard {
	background: rgba(255, 255, 255, 0.1);
	backdrop-filter: blur(10px);
	border: 1px solid rgba(255, 255, 255, 0.3);
	border-radius: 20px;
	color: #faf8f1;
	transition: transform 0.3s ease;
	animation: fadeInUp 1s ease-in-out;
}

.mycard:hover {
	transform: translateY(-10px);
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
@keyframes expandProperty {
    from { width: 0px; }
    to   { width: var(--dynamic-width); }
}

/* WebKit fallback */
@-webkit-keyframes expandProperty {
    from { width: 0px; }
    to   { width: 420px; }
}

nav {
	background-color: #fff8dd;
}

</style>
</head>
<body>
	<%@include file="includes/header.jsp"%>
	<%
	if (session == null || session.getAttribute("userId") == null) {
		response.sendRedirect("login.jsp");
		return;
	}
	%>
	<main class="container py-5 flex-grow-1">
		<div class="property is-animated">
			<h1 class="code-typing">👨🏻‍💻
				Welcome
				<%=session.getAttribute("userName")%>
			</h1>
		</div>

		<!-- filter code starts -->
		<form action="UserDashboardServlet">
			<div class="row g-3 mb-4">
				<div class="col-md-3">
					<input type="text" name="search" class="form-control"
						placeholder="Search by title or company" value="${param.search}" />
				</div>

				<div class="col-md-2">
					<input type="text" name="location" class="form-control"
						placeholder="Location" value="${param.location}" />
				</div>

				<div class="col-md-2">
					<select name="experience" class="form-select">
						<option value="" selected disabled>Experience</option>
						<option value="Fresher"
							${param.experience == 'Fresher' ? 'selected':''}>Fresher</option>
						<option value="0-1 years"
							${param.experience == '0-1 year' ? 'selected':''}>0-1
							years</option>
						<option value="1-2 years"
							${param.experience == '1-2 years' ? 'selected':''}>1-2
							years</option>
						<option value="2-3 years"
							${param.experience == '2-3 years' ? 'selected':''}>2-3
							years</option>
						<option value="3-5 years"
							${param.experience == '3-5 years' ? 'selected':''}>3-5
							years</option>
						<option value="5+ years"
							${param.experience == '5+ years' ? 'selected':''}>5+
							years</option>
					</select>
				</div>

				<div class="col-md-2">
					<select name="packageLpa" class="form-select">
						<option value="" selected disabled>Package (LPA)</option>
						<option value="1-3 Lacs P.A."
							${param.packageLpa == '1-3 Lacs P.A.' ? 'selected':''}>1-3
							LPA</option>
						<option value="3-5 Lacs P.A."
							${param.packageLpa == '3-5 Lacs P.A.' ? 'selected':''}>3-5
							LPA</option>
						<option value="5-7 Lacs P.A."
							${param.packageLpa == '5-7 Lacs P.A.' ? 'selected':''}>5-7
							LPA</option>
						<option value="7-10 Lacs P.A."
							${param.packageLpa == '7-10 Lacs P.A.' ? 'selected':''}>7-10
							LPA</option>
						<option value="10+ Lacs P.A."
							${param.packageLpa == '10+ Lacs P.A.' ? 'selected':''}>10+
							LPA</option>
						<option value="Not Disclosed">Not disclosed</option>
					</select>
				</div>

				<div class="col-md-2">
					<select name="sort" class="form-select">
						<option value="" selected disabled>Sort</option>
						<option value="asc" ${param.sort == 'asc' ? 'selected':''}>Fewest</option>
						<option value="desc" ${param.sort == 'desc' ? 'selected':''}>Most</option>
					</select>
				</div>

				<div class="col-md-1">
					<button type="submit" class="btn custom">Go</button>
				</div>
			</div>
		</form>
		<!-- filter code ends -->

		<!-- job card starts -->
		<%
		List<JobPojo> jobs = (List<JobPojo>) request.getAttribute("jobs");
		Map<Integer, String> appliedJobIds = (Map<Integer, String>) request.getAttribute("appliedJobIds");
		boolean resumeUploaded = (boolean) request.getAttribute("resumeUploaded");
		if (jobs != null && !jobs.isEmpty()) {
		%>
		<div class="row g-4">
			<%
			for (JobPojo job : jobs) {
			%>
			<div class="col-md-3 col-lg-3">
				<div class="card p-2 position-relative shadow mycard">
					<span class="position-absolute top-0 end-0 px-2 py-1 small">
						<%=job.getCreatedAt() != null ? new SimpleDateFormat("d MMM").format(job.getCreatedAt()) : ""%>
					</span>

					<div class="card-body">
						<h4 class="mb-1"><%=job.getTitle()%>
						</h4>
						<p><%=job.getCompany()%>
						</p>

						<div class="d-flex flex-wrap small mb-2 gap-3">
							<div>
								<i class="bi bi-briefcase-fill me-1"></i><%=job.getExperience()%>
							</div>
							<div>
								<i class="bi bi-currency-rupee me-1"></i><%=job.getPackageLpa()%>
							</div>
							<div>
								<i class="bi bi-geo-alt me-1"></i><%=job.getLocation()%>
							</div>
							<div>
								<i class="bi bi-people-fill me-1"></i><%=job.getVacancies()%>
								Openings
							</div>
						</div>
						<%
						if (appliedJobIds.containsKey(job.getId())) {
						%>
						<span
							class="badge bg-<%=appliedJobIds.get(job.getId()).equals("rejected") ? "danger" : "success"%> col-md-1 p-2 mt-2 w-50"><%=appliedJobIds.get(job.getId()).toUpperCase()%></span>
						<br />
						<%
						} else {
						%>

						<button type="button"
							class="btn btn-outline-warning btn-sm mt-2 small"
							onclick="openResumePopup(<%=job.getId()%>, <%=job.getScore()%>, '<%=job.getSkills().replace("'", "\\'")%>')">
							Apply Now</button>
						<button type="button"
							class="btn btn-outline-info btn-sm mt-2 small"
							onclick='showDetails(<%=job.getId()%>,"<%=job.getTitle().replace("\"", "&quot;")%>", " <%=job.getCompany().replace("\"", "&quot;")%>", "<%=job.getLocation().replace("\"", "&quot;")%>", "<%=job.getExperience().replace("\"", "&quot;")%>", "<%=job.getPackageLpa().replace("\"", "&quot;")%>", "<%=job.getVacancies()%>", "<%=job.getSkills().replace("\"", "&quot;")%>", "<%=job.getDescription().replace("\"", "&quot;")%>", "<%=new java.text.SimpleDateFormat("dd MMM yyyy").format(job.getCreatedAt())%>")'>
							View Details</button>
						<%
						}
						%>
					</div>
					<%
					if (resumeUploaded) {
					%>
					<div
						class="position-absolute badge bg-primary bottom-0 end-0 p-1 small m-2">
						<%=(int) job.getScore()%>% Match
					</div>
					<%
					}
					%>


				</div>
			</div>
			<%
			}
			%>
		</div>
		<%
		} else {
		%>
		<h5 class="text-warning text-center mt-4"><i class="fas fa-exclamation-circle text-warning"></i>&nbsp;No Jobs Found</h5>
		<%
		}
		%>
		<!-- job card ends -->

		<!-- view job details popup starts -->
		<div class="modal fade" id="jobDetailsModal" tabindex="-1"
			aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered modal-lg">
				<div class="modal-content bg-white text-dark">
					<div class="modal-header">
						<h5 class="modal-title fw-bold" id="modalJobTitle">Job Title</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
					</div>
					<div class="modal-body">
						<p>
							<strong>Company:</strong> <span id="modalCompany"></span>
						</p>
						<p>
							<strong>Location:</strong> <span id="modalLocation"></span>
						</p>
						<p>
							<strong>Experience:</strong> <span id="modalExperience"></span>
						</p>
						<p>
							<strong>Package:</strong> <span id="modalPackage"></span>
						</p>
						<p>
							<strong>Vacancies:</strong> <span id="modalVacancies"></span>
						</p>
						<p>
							<strong>Skills:</strong> <span id="modalJobSkills"></span>
						</p>
						<p>
							<strong>Description:</strong> <span id="modalDescription"></span>
						</p>
						<p>
							<strong>Posted On:</strong> <span id="modalPostedDate"></span>
						</p>
					</div>
				</div>
			</div>
		</div>
		<!-- view job details popup ends -->

		<!-- Resume Upload Modal -->
		<div class="modal fade" id="resumeModal" tabindex="-1"
			aria-labelledby="resumeModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-lg modal-dialog-centered">
				<form id="resumeForm" method="post" enctype="multipart/form-data"
					action="UploadResumeServlet"
					class="modal-content bg-dark text-white">
					<div class="modal-header">
						<h5 class="modal-title" id="resumeModalLabel">📄 Upload
							Resume</h5>
						<button type="button" class="btn-close btn-close-white"
							data-bs-dismiss="modal"></button>
					</div>
					<div class="modal-body">
						<input type="hidden" name="jobId" id="modalJobId"> <input
							type="hidden" name="skills" id="modalSkills"> <label
							for="resumeFile" class="form-label">Upload Resume (PDF)</label> <input
							type="file" name="resume" id="resumeFile" class="form-control"
							accept=".pdf" required />
					</div>
					<div class="modal-footer justify-content-between">
						<button type="submit" class="btn btn-success">Continue</button>
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Cancel</button>
					</div>
				</form>
			</div>
		</div>


	</main>

	<%@include file="includes/footer.jsp"%>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
		crossorigin="anonymous"></script>
	<script>
<%if (request.getParameter("applied") != null) {%>
    Swal.fire({icon:'success',title:'Applied Successfully',showConfirmButton:false,timer:1500})
<%}%>
let lastFocusedElement = null;
function openResumePopup(jobId, score, skills) {
    const resumeUploaded =<%=request.getAttribute("resumeUploaded")%>;
    lastFocusedElement = document.activeElement;
    if (resumeUploaded) {
        Swal.fire({
            title: "Apply for this job?", icon:
                "question", showCancelButton: true, confirmButtonText: "Yes, Apply",
            cancelButtonText: "Cancel"
        })
            .then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: "Apply with same resume", icon:
                            "question", showCancelButton: true, confirmButtonText: "Yes, Apply",
                        cancelButtonText: "Upload new"
                    }).then((result)=>{
                       if(result.isConfirmed){
                           const form = document.createElement("form");
                           form.method = "POST";
                           form.action = "ApplyJobServlet";
                           const input1 = document.createElement("input");
                           input1.type = "hidden";
                           input1.name = "jobId";
                           input1.value = jobId;
                           form.appendChild(input1);
                           const input2 = document.createElement("input");
                           input2.type = "hidden";
                           input2.name = "score";
                           input2.value = score;
                           form.appendChild(input2);
                           document.body.appendChild(form);
                           form.submit();
                       }else{
                           document.getElementById("modalJobId").value = jobId;
                           document.getElementById("modalSkills").value = skills;
                           document.getElementById("resumeFile").value = "";
                           new
                           bootstrap.Modal(document.getElementById('resumeModal')).show();
                       }
                    });
                }
            });
    } else {
        document.getElementById("modalJobId").value = jobId;
        document.getElementById("modalSkills").value = skills;
        document.getElementById("resumeFile").value = "";
        new
        bootstrap.Modal(document.getElementById('resumeModal')).show();
    }
}

function showDetails(id, title, company, location, experience, packageLpa, vacancies, skills, description, posted) {
    lastFocusedElement = document.activeElement;
    document.getElementById("modalJobTitle").innerText = title;
    document.getElementById("modalCompany").innerText = company;
    document.getElementById("modalLocation").innerText = location;
    document.getElementById("modalExperience").innerText = experience;
    document.getElementById("modalPackage").innerText = packageLpa;
    document.getElementById("modalVacancies").innerText = vacancies;
    document.getElementById("modalJobSkills").innerText = skills;
    document.getElementById("modalDescription").innerText = description;
    document.getElementById("modalPostedDate").innerText = posted;
    const jobModalEl = document.getElementById('jobDetailsModal');
    const jobModal = new bootstrap.Modal(jobModalEl);
    new bootstrap.Modal(document.getElementById('jobDetailsModal')).show();
}

//On modal hidden, restore focus to opener if possible
document.getElementById('jobDetailsModal').addEventListener('hidden.bs.modal', function () {
if (lastFocusedElement && document.contains(lastFocusedElement)) {
    try {
        lastFocusedElement.focus({preventScroll: true});
    } catch (e) {
        lastFocusedElement.focus();
    }
} else {
    // fallback: focus first focusable element or body
    const firstFocusable = document.querySelector('button, a, input, [tabindex]:not([tabindex="-1"])');
    if (firstFocusable) firstFocusable.focus();
    else document.body.focus();
}
lastFocusedElement = null;
});

//similar restore for resumeModal if you open it programmatically
document.getElementById('resumeModal').addEventListener('hidden.bs.modal', function () {
if (lastFocusedElement && document.contains(lastFocusedElement)) {
    try {
        lastFocusedElement.focus({preventScroll: true});
    } catch (e) {
        lastFocusedElement.focus();
    }
}
lastFocusedElement = null;
});

window.onload = function () {
    const textElement = document.querySelector(".property h1");
    const container = document.querySelector(".property");

    if (textElement && container) {
        // Get exact required width (content width)
        const requiredWidth = (textElement.scrollWidth)+ 10 + "px";

        // Apply the value to CSS variable
        container.style.setProperty("--dynamic-width", requiredWidth);
    }
};

</script>
</body>
</html>
