# HiroAI

[![Java](https://img.shields.io/badge/Java-17-orange.svg)]()
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue.svg)]()
[![Tomcat](https://img.shields.io/badge/Tomcat-10.x-lightgrey.svg)]()

HiroAI is an intelligent recruitment platform that revolutionizes the hiring process through AI-powered resume analysis and smart candidate matching. The platform connects job seekers with employers while automating tedious recruitment tasks through advanced resume parsing and skill-matching algorithms.

---

## 🚀 About

HiroAI simplifies hiring by combining resume parsing, skill extraction, and intelligent matching to surface the best candidates for each role. The platform supports multi-role access (Users, Employers, Admin), automated resume analysis using the Affinda API, OTP-based email verification, session-based authentication, and a modern responsive UI.

Key highlights:
- AI-Powered Matching: Automatic resume analysis using Affinda API
- Smart Scoring: Real-time candidate-job compatibility scoring
- Multi-Role System: Separate dashboards for Users, Employers, and Admins
- Email Integration: OTP verification and notifications
- Modern UI: Responsive glassmorphism design with animations
- Secure: Session-based authentication with role management

---

## ✨ Features

### For Job Seekers (Users)
- Register and create professional profiles
- Upload PDF resumes for automatic parsing
- Smart job search and filtering (location, experience, package, etc.)
- View match percentage for each job
- Track application status (Applied / Shortlisted / Rejected)
- Personalized AI-based job recommendations

### For Employers
- Create detailed job listings with required skills
- View and filter applicants
- See match scores for candidates
- Download resumes
- Shortlist or reject candidates
- Dashboard analytics for posted jobs and applicants

### For Administrators
- Manage users and accounts (block/unblock)
- Search & filter users by name, email, role
- Monitor platform activity and system overview

### System Features
- Email-based registration with OTP verification
- Session handling and role-based access control
- Automated email notifications (OTP, application updates)
- Responsive, mobile-first UI using Bootstrap and modern design patterns

---

## 🧰 Tech Stack

### Backend
- Java 17
- Jakarta EE (Servlets)
- Maven
- MySQL 8.0
- JavaMail (email features)

### Frontend
- JSP (server-side templates)
- Bootstrap 5
- Bootstrap Icons, Font Awesome
- SweetAlert2
- Vanilla JavaScript (ES6+), CSS (glassmorphism)

### External APIs & Tools
- Affinda Resume Parser API — resume parsing & skill extraction
- Perplexity AI Chat API
- Eclipse (recommended IDE)
- Apache Tomcat (application server)
- Git & GitHub
- MySQL Workbench

---

## 🏛 Architecture

HiroAI follows a three-tier architecture:


```
                  ┌─────────────────────────────────────┐
                  │         Presentation Layer          │
                  │  (JSP, CSS, JavaScript, Bootstrap)  │
                  └─────────────────┬───────────────────┘
                                    │
                                    ▼
                  ┌─────────────────────────────────────┐
                  │       Business Logic Layer          │
                  │        (Servlets, DAOs)             │
                  └─────────────────┬───────────────────┘
                                    │
                                    ▼
                  ┌─────────────────────────────────────┐
                  │         Data Access Layer           │
                  │             (MySQL)                 │
                  └─────────────────────────────────────┘
```

Package structure (top-level):
- hiroaiapp
  - controllers/         # Servlet controllers
  - services/            # Business services
  - dao/                 # Data access objects
  - pojo/                # Entity POJOs
  - utils/               # Utility classes (Affinda API, MailUtil, etc.)
  - dbutils/             # DB connection & initialization

---

## ✅ Prerequisites

- Java Development Kit (JDK) 17 or higher  
- Apache Maven 3.6+  
- MySQL Server 8.0+  
- Apache Tomcat 10.x+  
- Git (for cloning)  
- Optional: Eclipse IDE (recommended)

System requirements:
- OS: Windows 10/11, macOS, or Linux  
- RAM: 4GB minimum (8GB recommended)  
- Disk: 500MB+ free

---

## 🛠 Installation

1. Clone the repository
```bash
git clone https://github.com/PushprajSChauhan/HiroAI.git
cd HiroAI
```

2. Build the project
```bash
mvn clean install
```

3. Deploy the generated WAR to Tomcat
- Copy `target/<artifact>.war` to `$TOMCAT_HOME/webapps/`
- Start Tomcat:
  - Linux/macOS: `$TOMCAT_HOME/bin/catalina.sh run`
  - Windows: `$TOMCAT_HOME\bin\catalina.bat run`

Or run with Maven Tomcat plugin (if configured):
```bash
mvn tomcat7:run
```

Open in browser:
```
http://localhost:8080/
```

---

## ⚙️ Configuration

# Email Configuration
mail.smtp.host=smtp.gmail.com  
mail.smtp.port=587  
mail.smtp.auth=true  
mail.smtp.starttls.enable=true  
mail.username=your-email
mail.password=your-app-password

# Affinda API Configuration
api.key=YOUR_AFFINDA_API_KEY

Notes:
- For Gmail use an App Password (if using 2FA).
- Keep credentials secret — use environment variables or secrets in production.

Edit `src/main/webapp/WEB-INF/web.xml` to change app context parameters if needed.

---

## 🗄 Database Setup

1. Create a new MySQL database.  
2. Execute the project's SQL schema (see `hiresense_db.sql`) to create tables and initial structure.  
3. Update DB connection settings in your DB utility (e.g. `DBConnection` in `dbutils`).

> Note: This README contains the ER model (Mermaid) for the schema. No additional SQL commands are included here.

---

## 🧭 ER Diagram (Database Model)

The following Mermaid ER diagram represents the database schema used by HiroAI (parsed from `hiresense_db.sql`). This diagram is embedded as Mermaid code so it renders on GitHub.

```mermaid
erDiagram
    USERS {
        int id PK
        varchar(100) name
        varchar(100) email "UNIQUE"
        varchar(255) password
        enum role "user, employer, admin"
        enum status "active, blocked"
        timestamp created_at
    }

    JOBS {
        int id PK
        varchar(150) title
        text description
        text skills
        varchar(100) company
        varchar(100) location
        varchar(50) experience
        varchar(50) package_lpa
        int vacancies
        int employer_id FK
        timestamp created_at
        varchar(10) status
    }

    APPLICATIONS {
        int id PK
        int user_id FK
        int job_id FK
        varchar(255) resume_path
        float score
        enum status "applied, shortlisted, rejected"
        timestamp applied_at
    }

    RESUME_ANALYSIS_LOGS {
        int id PK
        int user_id FK
        json result_json
        timestamp created_at
    }

    USERS ||--o{ JOBS : "posts (employer_id)"
    USERS ||--o{ APPLICATIONS : "submits (user_id)"
    JOBS  ||--o{ APPLICATIONS : "receives (job_id)"
    USERS ||--o{ RESUME_ANALYSIS_LOGS : "has"
```

---

## ▶️ Running the Application

1. Start MySQL and ensure DB and tables are created.  
2. Ensure `config.properties` contains correct DB and API/email credentials.  
3. Build and deploy WAR to Tomcat (see Installation).  
4. Visit `http://localhost:8080/` and register a new user.  
5. For employer functionality, register with the `employer` role.

---

## 📚 Usage Guide

### Job Seeker (User)
- Register and verify via OTP  
- Login to access dashboard  
- Upload resume (PDF) — triggers Affinda parser and log entry  
- Browse jobs, view match percentage, and apply  
- Track application status

### Employer
- Register as employer  
- Post jobs with required skills and details  
- View applicants per job, with match scores  
- Download resumes, shortlist or reject candidates

### Admin
- Login with admin credentials  
- Manage users: search, block/unblock accounts  
- View platform metrics and system activity

---

## 🔗 API Integration (Affinda)

HiroAI integrates Affinda Resume Parser API for resume parsing and skill extraction.

#### Setup

1. Sign up at [Affinda](https://www.affinda.com/)
2. Get your API key from dashboard
3. Add to AffindaAPI util class

```properties
api.key=YOUR_AFFINDA_API_KEY
```

#### Features Used

- Resume text extraction
- Skills identification
- Education parsing
- Work experience extraction
- Contact information extraction

#### API Endpoints Used

```
POST https://api.affinda.com/v2/resumes
```

Example conceptual response:
```json
{
  "data": {
    "name": "John Doe",
    "email": "john@example.com",
    "skills": ["Java", "Python", "SQL"],
    "education": { ... },
    "experience": { ... }
  }
}
```

---

## 🗂 Project Structure

Representative layout:
```
hiroaiapp/
│
├── src/
│   └── main/
│       ├── java/
│       │    └── hiroaiapp/
│       │        ├── controllers/
│       │        │   ├── LoginServlet.java
│       │        │   ├── RegistrationServlet.java
│       │        │   ├── VerifyOTPRegisterServlet.java
│       │        │   ├── UserDashboardServlet.java
│       │        │   ├── EmployerDashboardServlet.java
│       │        │   ├── PostJobServlet.java
│       │        │   ├── ApplyJobServlet.java
│       │        │   ├── UploadResumeServlet.java
│       │        │   ├── ViewApplicantsServlet.java
│       │        │   ├── UpdateApplicationServlet.java
│       │        │   ├── DownloadResumeServlet.java
│       │        │   ├── AdminPanelServlet.java
│       │        │   ├── UpdateUserStatusServlet.java
│       │        │   ├── ToggleJobStatusServlet.java
│       │        │   ├── LogoutServlet.java
│       │        │   ├── ViewFullDetailsServlet.java
│       │        │   ├── DeleteJobServlet.java
│       │        │   └── SendRegisterOTPServlet.java
│       │        ├── dao/
│       │        │   ├── UserDAO.java
│       │        │   ├── JobDAO.java
│       │        │   ├── ApplicationDAO.java
│       │        │   └── ResumeAnalysisLogDAO.java
│       │        ├── pojo/
│       │        │   ├── UserPojo.java
│       │        │   ├── JobPojo.java
│       │        │   ├── ApplicationPojo.java
│       │        │   └── ResumeAnalysisLogsPojo.java
│       │        ├── utils/
│       │        │   ├── AffindaAPI.java
│       │        │   ├── MailUtil.java
│       │        │   ├── MailConfig.java
│       │        │   ├── MyAuthenticator.java
│       │        └── dbutils/
│       │            ├── DBConnection.java
│       │            └── AppInitializer.java
│       │
│       └── webapp/
│           ├── css/
│           │   └── styles.css
│           ├── includes/
│           │   ├── header.jsp
│           │   └── footer.jsp
│           ├── WEB-INF/
│           │   └── web.xml
│           ├── index.jsp
|           |── chat.jsp
│           ├── login.jsp
│           ├── register.jsp
│           ├── userDashboard.jsp
│           ├── employerDashboard.jsp
│           ├── adminPanel.jsp
│           ├── viewApplicants.jsp
│           └── viewFullDetails.jsp
|            
├── target/
├── pom.xml
└── README.md
```

---

## 🖼 Screenshots & Demo

(Placeholders — add your screenshots and demo video files to `docs/screenshots/` and a demo link when ready.)

- Demo video: docs/demo/hiroai-demo.mp4 (placeholder)  
- Screenshots: docs/screenshots/home.png, register.png, login.png, user_dashboard.png, employer_dashboard.png, view_applicants.png, admin_panel.png

---

## 🤝 Contributing

Contributions are welcome!

1. Fork the repository  
2. Create a feature branch: `git checkout -b feature/YourFeature`  
3. Commit your changes: `git commit -m "Add feature"`  
4. Push to your branch: `git push origin feature/YourFeature`  
5. Open a Pull Request

Guidelines:
- Follow Java naming conventions and best practices.  
- Add comments for complex logic.  
- Write tests where applicable.  
- Use clear, descriptive commit messages.

---

## 📬 Contact

Project Maintainer: Pushpraj Singh Chauhan

- Email: chauhanpushprajsingh003@gmail.com  
- GitHub: https://github.com/PushprajSChauhan  
- LinkedIn: https://linkedin.com/in/pschauhan2k3

Project Link: https://github.com/PushprajSChauhan/HiroAI

---

## 🙏 Acknowledgments

- Affinda — Resume parsing API  
- Perplexity — AI Chat Assistance API  
- Bootstrap — Frontend framework  
- Hibernate — ORM framework  
- Font Awesome — Icons  
- SweetAlert2 — Alerts UI

---

<div align="center">

**Made by the Pushpraj Singh Chauhan**

Star this repository if you find it helpful!

</div>
