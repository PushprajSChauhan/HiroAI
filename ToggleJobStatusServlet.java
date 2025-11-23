package hiroaiapp.controllers;

import java.io.IOException;

import hiroaiapp.dao.JobDAO;
import hiroaiapp.pojo.JobPojo;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ToggleJobStatusServlet extends HttpServlet {
	
//	yaha bhi doGet ko override krenge bcos iska call ayega ek anchor tag se hi jiske through job ka status toggle hoga
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session=request.getSession(false);
		if(session==null || session.getAttribute("userId")==null || !"employer".equals((String)session.getAttribute("userRole"))) {
			response.sendRedirect("login.jsp");
			return;
		}
		
		int jobId=Integer.parseInt(request.getParameter("jobId"));
		try {
			JobPojo job = JobDAO.getJobById(jobId);
			String currentStatus = job.getStatus();
			
			// Toggle the status
			JobDAO.toggleJobStatus(jobId);
			
			// Determine what the new status will be after toggle
			String newStatus = "active".equals(currentStatus) ? "deactivated" : "activated";
			
			// Redirect with appropriate parameter
			response.sendRedirect("EmployerDashboardServlet?toggle=" + newStatus);
		}
		catch(Exception ex) {
			ex.printStackTrace();
			response.sendRedirect("EmployerDashboardServlet?error=1");
		}
	}
}
