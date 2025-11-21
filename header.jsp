<!-- navbar code starts here -->
<nav class="navbar navbar-expand-lg">
	<div class="container-fluid p-1 px-3">
		<a href="./index.jsp" class="navbar-brand fw-bold"><%=application.getAttribute("appName")%></a>

		<button type="button" class="navbar-toggler" data-bs-toggle="collapse"
			data-bs-target="#mynav">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse" id="mynav">
			<ul class="navbar-nav ms-auto">
				<%
				String role = (String) session.getAttribute("userRole");
				if (role == null) {
				%>
				<!-- guest links -->
				<li class="nav-item"><a href="./login.jsp" class="nav-link">Login</a></li>
				<li class="nav-item"><a href="./register.jsp" class="nav-link">Register</a>
				</li>
				<li class="nav-item">
                    <a class="nav-link" href="./chat.jsp"></i>AI Assistant</a>
                </li>
				<%
				} else if (role.equals("employer")) {
				%>
				<!-- employer links -->
				<li class="nav-item"><a href="./EmployerDashboardServlet" class="nav-link">Dashboard</a>
				</li>
				<li class="nav-item"><a href="./LogoutServlet" class="nav-link">Logout</a></li>
				<li class="nav-item">
                    <a class="nav-link" href="./chat.jsp"></i>AI Assistant</a>
                </li>
				<%
				} else if (role.equals("user")) {
				%>
				<!-- job seeker links -->
				<li class="nav-item"><a href="./UserDashboardServlet" class="nav-link">Dashboard</a>
				</li>
				<li class="nav-item"><a href="./LogoutServlet" class="nav-link">Logout</a></li>
				<li class="nav-item">
                    <a class="nav-link" href="./chat.jsp"></i>AI Assistant</a>
                </li>
				<%
				} else if (role.equals("admin")) {
				%>
				<!-- admin links -->
				<li class="nav-item"><a href="./AdminPanelServlet" class="nav-link">Admin
						Panel</a></li>
				<li class="nav-item"><a href="./LogoutServlet" class="nav-link">Logout</a></li>
				<li class="nav-item">
                    <a class="nav-link" href="./chat.jsp"></i>AI Assistant</a>
                </li>
				<%
				}
				%>
			</ul>
		</div>
	</div>
</nav>
<!-- navbar code ends here -->
<script>
    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();

            const targetId = this.getAttribute('href');
            if (targetId === '#') return;

            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 70,
                    behavior: 'smooth'
                });
            }
        });
    });

    // Change navbar background on scroll
    //window.addEventListener('scroll', function() {
    //    const navbar = document.querySelector('.navbar');
    //    if (window.scrollY > 50) {
     //       navbar.style.background = 'rgba(102, 126, 234, 0.95)';
    //        navbar.style.boxShadow = '0 4px 20px rgba(0, 0, 0, 0.1)';
    //    } else {
    //        navbar.style.background = 'transparent';
    //        navbar.style.boxShadow = 'none';
    //    }
   // });

    // Hamburger menu functionality
    document.addEventListener('DOMContentLoaded', function() {
        const navbarToggler = document.querySelector('.navbar-toggler');
        const navbarCollapse = document.querySelector('.navbar-collapse');

        // Close menu when clicking on a link
        const navLinks = document.querySelectorAll('.nav-link');
        navLinks.forEach(link => {
            link.addEventListener('click', () => {
                if (navbarCollapse.classList.contains('show')) {
                    navbarToggler.click();
                }
            });
        });
    });

</script>