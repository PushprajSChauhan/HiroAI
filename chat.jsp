<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>AI Chat | <%=application.getAttribute("appName")%></title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65"
	crossorigin="anonymous" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
<link rel="stylesheet" href="css/style.css" />
<style>
.chat-messages {
	box-shadow: 0 0 10px #00e8f0;
	max-height: 400px;
	overflow-y: auto;
	padding: 1rem;
	/* Glassmorphism */
	background: rgba(255, 255, 255, 0.162); /* Light frosted glass */
	border-radius: 20px;
	backdrop-filter: blur(20px) saturate(180%);
	-webkit-backdrop-filter: blur(20px) saturate(180%);
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
@keyframes expandProperty {
	from { 
		width: 0px;
	}
	to {
		width: 480px;
	}
}

/* WebKit fallback */
@-webkit-keyframes expandProperty {
	from { 
		width: 0px;
	}
	to {
		width: 420px;
	}
}

/* ----------- FULL PAGE OVERLAY ----------- */
.ai-loader-overlay {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.65);
	backdrop-filter: blur(6px);
	display: flex;
	justify-content: center;
	align-items: center;
	z-index: 99999;
}

.d-none {
	display: none !important;
}

/* ----------- LOADER WRAPPER ----------- */
.loader-wrapper {
	position: relative;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	width: 250px;
	height: 250px;
	font-size: 1.2em;
	font-weight: 300;
	color: white;
	text-align: center;
}

/* ----------- CIRCULAR COLORFUL LOADER ----------- */
.loader {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	aspect-ratio: 1 / 1;
	border-radius: 50%;
	background-color: transparent;
	animation: loader-rotate 2.1s linear infinite;
	z-index: 0;
}

@keyframes loader-rotate {
	0% {
		transform: rotate(90deg);
		box-shadow: 0 10px 20px 0 #fff inset, 0 20px 30px 0 #ad5fff inset,
			0 60px 60px 0 #471eec inset;
	}
	50% {
		transform: rotate(270deg);
		box-shadow: 0 10px 20px 0 #fff inset, 0 20px 10px 0 #d60a47 inset,
			0 40px 60px 0 #311e80 inset;
	}
	100% {
		transform: rotate(450deg);
		box-shadow: 0 10px 20px 0 #fff inset, 0 20px 30px 0 #ad5fff inset,
			0 60px 60px 0 #471eec inset;
	}
}

/* ----------- Animated Letters ----------- */
.loader-letter {
	display: inline-block;
	opacity: 0.4;
	animation: loader-letter-anim 1.5s ease-in-out infinite;
	z-index: 1;
}

.loader-letter:nth-child(1) { animation-delay: 0s; }
.loader-letter:nth-child(2) { animation-delay: 0.1s; }
.loader-letter:nth-child(3) { animation-delay: 0.2s; }
.loader-letter:nth-child(4) { animation-delay: 0.3s; }
.loader-letter:nth-child(5) { animation-delay: 0.4s; }
.loader-letter:nth-child(6) { animation-delay: 0.5s; }
.loader-letter:nth-child(7) { animation-delay: 0.6s; }
.loader-letter:nth-child(8) { animation-delay: 0.7s; }
.loader-letter:nth-child(9) { animation-delay: 0.8s; }
.loader-letter:nth-child(10) { animation-delay: 0.9s; }
.loader-letter:nth-child(11) { animation-delay: 1s; }
.loader-letter:nth-child(12) { animation-delay: 1.1s; }
.loader-letter:nth-child(13) { animation-delay: 1.2s; }
.loader-letter:nth-child(14) { animation-delay: 1.3s; }
.loader-letter:nth-child(15) { animation-delay: 1.4s; }
.loader-letter:nth-child(16) { animation-delay: 1.5s; }
.loader-letter:nth-child(17) { animation-delay: 1.6s; }
.loader-letter:nth-child(18) { animation-delay: 1.7s; }
.loader-letter:nth-child(19) { animation-delay: 1.8s; }
.loader-letter:nth-child(20) { animation-delay: 1.9s; }
.loader-letter:nth-child(21) { animation-delay: 2s; }
.loader-letter:nth-child(22) { animation-delay: 2.1s; }
.loader-letter:nth-child(23) { animation-delay: 2.2s; }
.loader-letter:nth-child(24) { animation-delay: 2.3s; }
.loader-letter:nth-child(25) { animation-delay: 2.4s; }
.loader-letter:nth-child(26) { animation-delay: 2.5s; }
.loader-letter:nth-child(27) { animation-delay: 2.6s; }
.loader-letter:nth-child(28) { animation-delay: 2.7s; }
.loader-letter:nth-child(29) { animation-delay: 2.8s; }
.loader-letter:nth-child(30) { animation-delay: 2.9s; }

@keyframes loader-letter-anim {
	0%, 100% {
		opacity: 0.4;
	}
	50% {
		opacity: 1;
	}
}

.loader-line {
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	width: 100%;
	z-index: 1;
	padding: 0 10px;
}

.user-input{
	background-color: rgba(255,255,255,0.2);
}
</style>
</head>
<body class="user-dashboard-page">
	<%@include file="includes/header.jsp"%>
	<main class="container py-5">
		<div class="property is-animated">
			<h1 class="welcome-title code-typing">
				🤖
				<%=application.getAttribute("appName")%>
				Assistant
			</h1>
		</div>


		<!-- Chat Container -->
		<div class="filter-card glass-card mb-4">
			<h4 class="filter-title mb-3">
				<i class="fas fa-comments me-2"></i>Chat with AI
			</h4>

			<!-- Chat Messages -->
			<div class="chat-messages mb-4">
				<%
				List<JSONObject> chatHistory = (List<JSONObject>) session.getAttribute("chatHistory");
				if (chatHistory != null && !chatHistory.isEmpty()) {
					for (JSONObject msg : chatHistory) {
						String role1 = msg.getString("role");
						String content = msg.getString("content");
						boolean isUser = role1.equals("user");
				%>
				<div
					class="message-wrapper mb-3 text-dark <%=isUser ? "text-end" : "text-start"%>">
					<div
						class="message-content d-inline-block p-3 rounded-3 <%=isUser ? "bg-info text-dark" : "bg-light text-dark"%>"
						style="max-width: 70%; word-wrap: break-word;">
						<div class="message-header mb-1">
							<small> <i
								class="fas <%=isUser ? "fa-user" : "fa-robot"%> me-1"></i> <%=isUser ? "You" : "AI Assistant"%>
							</small>
						</div>
						<div class="message-text">
							<%=content.replaceAll("\n", "<br/>")%>
						</div>
					</div>
				</div>
				<%
				}
				} else {
				%>
				<div class="text-center text-white-50">
					<i class="fas fa-comment-dots fa-3x mb-3"></i>
					<p>Start a conversation with our AI assistant!</p>
				</div>
				<%
				}
				%>
			</div>

			<!-- Chat Input Form -->
			<form method="post" action="ChatAssistantServlet" onsubmit="showAILoader()"
				class="d-flex gap-2">
				<input type="text" name="message"
					class="form-control user-input flex-grow-1"
					placeholder="Type your message here then click send..." required />
				<button type="submit" class="btn btn-gradient text-info">
					<i class="fas fa-paper-plane me-1"></i>Send
				</button>
			</form>
		</div>

		<!-- Quick Actions -->
		<div class="job-card glass-card p-3">
			<h5 class="mb-4 mt-2">
				<i class="fas fa-lightbulb me-2"></i>Quick Questions
			</h5>
			<div class="row g-3 justify-content-center">
				<div class="col-md-6 d-flex justify-content-center">
					<button class="btn btn-outline-light w-50 quick-question"
						data-question="How do I improve my resume?">
						<i class="fas fa-file-alt me-1"></i>Resume Tips
					</button>
				</div>

				<div class="col-md-6 d-flex justify-content-center">
					<button class="btn btn-outline-light w-50 quick-question"
						data-question="What are the latest job market trends?">
						<i class="fas fa-chart-line me-1"></i>Job Market
					</button>
				</div>

				<div class="col-md-6 d-flex justify-content-center">
					<button class="btn btn-outline-light w-50 quick-question"
						data-question="How to prepare for technical interviews?">
						<i class="fas fa-code me-1"></i>Interview Prep
					</button>
				</div>

				<div class="col-md-6 d-flex justify-content-center">
					<button class="btn btn-outline-light w-50 quick-question"
						data-question="Best skills to learn in 2025?">
						<i class="fas fa-graduation-cap me-1"></i>Skills Guide
					</button>
				</div>
			</div>
		</div>
	</main>

	<!-- ---------- AI LOADER OVERLAY ---------- -->
	<div id="aiLoader" class="ai-loader-overlay d-none">
		<div class="loader-wrapper">
			<div class="loader-line" id="loaderText">
				<!-- Dynamic text will be inserted here -->
			</div>
			<div class="loader"></div>
		</div>
	</div>

	<%@include file="includes/footer.jsp"%>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4"
		crossorigin="anonymous"></script>

	<script>
    const loadingMessages = [
        "Thinking...",
        "AI is analyzing your prompt...",
        "Brewing ideas. Please wait...",
        "Let me think about that...",
        "Neurons firing at full speed...",
        "Crafting an intelligent response..."
    ];

    function showAILoader() {
        // Pick a random message
        const randomMessage = loadingMessages[Math.floor(Math.random() * loadingMessages.length)];
        
        console.log('Selected loading message:', randomMessage);
        
        const loaderTextDiv = document.getElementById('loaderText');
        loaderTextDiv.innerHTML = '';
        
        // Split message into words
        const words = randomMessage.split(' ');
        const maxCharsPerLine = 20; // Maximum characters per line
        
        let currentLine = document.createElement('div');
        currentLine.style.display = 'flex';
        currentLine.style.justifyContent = 'center';
        currentLine.style.flexWrap = 'nowrap';
        currentLine.style.marginBottom = '5px';
        
        let currentLineLength = 0;
        let letterIndex = 0;
        
        words.forEach((word, wordIndex) => {
            // Check if adding this word would exceed the line limit
            if (currentLineLength + word.length > maxCharsPerLine && currentLineLength > 0) {
                // Start a new line
                loaderTextDiv.appendChild(currentLine);
                currentLine = document.createElement('div');
                currentLine.style.display = 'flex';
                currentLine.style.justifyContent = 'center';
                currentLine.style.flexWrap = 'nowrap';
                currentLine.style.marginBottom = '5px';
                currentLineLength = 0;
            }
            
            // Add each letter of the word
            for (let i = 0; i < word.length; i++) {
                const span = document.createElement('span');
                span.className = 'loader-letter';
                span.textContent = word[i];
                span.style.animationDelay = (letterIndex * 0.1) + 's';
                currentLine.appendChild(span);
                letterIndex++;
            }
            
            currentLineLength += word.length;
            
            // Add space after word (except for last word)
            if (wordIndex < words.length - 1) {
                const space = document.createElement('span');
                space.className = 'loader-letter';
                space.textContent = '\u00A0'; // Non-breaking space
                space.style.animationDelay = (letterIndex * 0.1) + 's';
                currentLine.appendChild(space);
                letterIndex++;
                currentLineLength += 1;
            }
        });
        
        // Append the last line
        loaderTextDiv.appendChild(currentLine);
        
        // Show the loader
        document.getElementById('aiLoader').classList.remove('d-none');
    }

    // Auto-scroll to bottom of chat
    function scrollToBottom() {
        const chatMessages = document.querySelector('.chat-messages');
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    // Scroll to bottom on page load
    window.addEventListener('load', scrollToBottom);

    // Quick question functionality
    document.querySelectorAll('.quick-question').forEach(button => {
        button.addEventListener('click', function() {
            const question = this.getAttribute('data-question');
            const messageInput = document.querySelector('input[name="message"]');
            messageInput.value = question;
            messageInput.focus();
        });
    });
</script>
</body>
</html>
