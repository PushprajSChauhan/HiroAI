package hiroaiapp.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import hiroaiapp.dao.JobDAO;
import hiroaiapp.pojo.JobPojo;

public class PostJobServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session=request.getSession(false); //yaha false isliye likha hai bcos hame sirf vahi session use krna hai jo already exist krte hain and not all sessions
		if(session==null || session.getAttribute("userId")==null || !"employer".equals((String)session.getAttribute("userRole"))) {
			response.sendRedirect("login.jsp");
			return;
		}
		
		try {
			int employerId=(Integer)session.getAttribute("userId");
			String title=request.getParameter("title");
			String description=request.getParameter("description");
			String skills=request.getParameter("skills");
			String company=request.getParameter("company");
			String location=request.getParameter("location");
			String experience=request.getParameter("experience");
			String packageLpa=request.getParameter("packageLpa");
			int vacancies=Integer.parseInt(request.getParameter("vacancies"));
			
			JobPojo job=new JobPojo();
			job.setTitle(title);
			job.setDescription(description);
			job.setSkills(skills);
			job.setCompany(company);
			job.setLocation(location);
			job.setExperience(experience);
			job.setPackageLpa(packageLpa);
			job.setVacancies(vacancies);
			job.setEmployerId(employerId);
			
			boolean result=JobDAO.postJob(job);
			if(result) {
				response.sendRedirect("EmployerDashboardServlet?success=1"); //this status in query string will be used by jsp page and not by dashboard
			}
			else {
				response.sendRedirect("EmployerDashboardServlet?error=1");
			}
		}
		catch(Exception ex) {
			ex.printStackTrace();
			response.sendRedirect("EmployerDashboardServlet?error=1");
		}
	}

}
