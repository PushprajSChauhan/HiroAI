<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HiroAI App</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
<link rel="stylesheet" href="css/style.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
		.typewriter {
            display: inline-block; 
        }

        .typewriter h1 {
            border-right: 0.12em solid white; 
            white-space: nowrap;
            margin: 0;
            padding: 0;
            letter-spacing: 0.1em;
            font-size: 5rem;
			font-weight: 800;
            min-height: 5.6rem;
            animation: blink-caret 1s step-end infinite;
        }

        @keyframes blink-caret {
            from, to {
                border-color: transparent;
            }
            50% {
                border-color: white;
            }
        }
    </style>
</head>
<body>
	<%@ include file="includes/header.jsp"%>
	<!-- front page content start -->
	<main>
		<div class="hero">
			<div class="typewriter">
				<h1 class="code-typing" id="dynamic-texts"></h1>
			</div>
			<p>AI powered resume analysis and smart job matching in one
				platform</p>
			<a href="login.jsp" class="text-light custom-btn mt-5 mb-3 mx-auto"
				style="display: inline-flex; align-items: center; justify-content: center; text-decoration: none; cursor: pointer;"><span>Get
					Started</span></a>
		</div>

		<!-- feature content starts -->
		<div class="container py-5 mb-5">
			<div class="row text-center">

				<div class="col-md-4 mb-4">
					<div class="feature-card">
						<h3 class="code-typing">🧠 AI Resume Insights</h3>
						<p>Let our AI analyze your resume and extract deep insights
							like skills, experience and summary.</p>
					</div>
				</div>

				<div class="col-md-4 mb-4">
					<div class="feature-card">
						<h3 class="code-typing">🛠️ Skill Gap Analyzer</h3>
						<p>Identify missing skills by comparing your resume with job
							requirements.</p>
					</div>
				</div>

				<div class="col-md-4 mb-4">
					<div class="feature-card">
						<h3 class="code-typing">🎯 Smart Job Matching</h3>
						<p>Get best matching jobs for your resume, skills and goals -
							powered by intelligent AI.</p>
					</div>
				</div>

				<div class="col-md-4 mb-4">
					<div class="feature-card">
						<h3 class="code-typing">📊 Data-Driven Insights</h3>
						<p>Make correct decisions with detailed analytics and
							reporting on your hiring performance.</p>
					</div>
				</div>

				<div class="col-md-4 mb-4">
					<div class="feature-card">
						<h3 class="code-typing">🧑🏻‍🤝‍🧑🏻 Team Collaboration</h3>
						<p>Get best matching jobs for your resume, skills and goals -
							powered by intelligent AI.</p>
					</div>
				</div>

				<div class="col-md-4 mb-4">
					<div class="feature-card">
						<h3 class="code-typing">🔒 Secure Data Protection</h3>
						<p>Your personal and hiring data is encrypted and securely
							stored, ensuring privacy and protection.</p>
					</div>
				</div>

			</div>
		</div>
		<!-- feature content ends -->

		<!-- Row 1: About Section (Left Aligned) -->
		<section id="about" class="features-section">
			<div class="container mb-5">
				<div class="row">
					<div class="col-lg-6">
						<!-- Left Side -->
						<h2 class="section-title code-typing mb-4">
							ℹ️&nbsp;About HiroAI
						</h2>
						<p>HiroAI is revolutionizing the recruitment industry with
							cutting-edge AI technology and intuitive design. Our platform
							empowers companies to make smarter hiring decisions while
							providing candidates with a seamless application experience.
							Founded by industry experts, we understand the challenges of
							modern recruitment and built a solution that addresses real-world
							hiring needs with innovation.</p>
					</div>
				</div>
			</div>
		</section>
		<!-- About Ends -->


		<!-- Row 2: Contact Section (Right Aligned) -->
		<section id="contact" class="mb-5">
			<div class="container">
				<div class="row justify-content-end">
					<!-- Move to right -->
					<div class="col-lg-6 text-end">
						<!-- Right Side -->
						<h2 class="code-typing">
							Get In Touch&nbsp;🫱🏻‍🫲🏻
						</h2>

						<div class="mt-3">
							<h4 class="code-typing">Ready to Transform Your Hiring?</h4>
							<p>Contact our team to learn how HiroAI can streamline your
								recruitment process.</p>
							<div class="mt-4">
								<a href="mailto:contact@hirioai.com"
									class="btn btn-outline-info text-light me-3"> <i
									class="fas fa-envelope me-2"></i>Email Us
								</a> <a href="tel:+1234567890"
									class="btn btn-outline-info text-light"> <i
									class="fas fa-phone me-2"></i>Call Us
								</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>
		<!-- Contact Ends -->


	</main>
	<!-- front page content end -->
	<%@ include file="includes/footer.jsp"%>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
		crossorigin="anonymous"></script>
		<script>
        const carouselText = [
            { text: "AI Shows You The Career"}, 
            { text: "AI Smart Job Matching"}, 
            { text: "Talent Meets AI"},    
            { text: "Your AI Job Partner"},
            { text: "Get Hired Smarter With AI"}
        ];

        // Target the element with class 'code-typing'
        const targetSelector = "#dynamic-texts"; 

        // --- Asynchronous Typing/Deletion Functions ---

        async function typeSentence(sentence, eleRef, delay = 100) {
            const letters = sentence.split("");
            let i = 0;
            while (i < letters.length) {
                await waitForMs(delay);
                $(eleRef).append(letters[i]);
                i++;
            }
            return;
        }

        async function deleteSentence(eleRef) {
            const sentence = $(eleRef).html();
            const letters = sentence.split("");
            let i = 0;
            while (letters.length > 0) {
                await waitForMs(80); // Slightly faster deletion
                letters.pop();
                $(eleRef).html(letters.join(""));
            }
        }

        async function carousel(carouselList, eleRef) {
            var i = 0;
            while (true) {
                await typeSentence(carouselList[i].text, eleRef);
                await waitForMs(2000); // Pause time after typing (2 seconds)
                await deleteSentence(eleRef);
                await waitForMs(500);  // Pause time after deleting (0.5 seconds)
                i++;
                if (i >= carouselList.length) {
                    i = 0; // Reset to the start of the list
                }
            }
        }

        function waitForMs(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }

        // --- Execution Start ---

        $(document).ready(async function() {
            carousel(carouselText, targetSelector);
        });
    </script>
</body>
</html>
