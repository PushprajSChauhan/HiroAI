package hiroaiapp.controllers;

import java.io.IOException;
import java.util.List;

import hiroaiapp.dao.JobDAO;
import hiroaiapp.pojo.JobPojo;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class EmployerDashboardServlet extends HttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    doPost(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session=request.getSession(false); //yaha false isliye likha hai bcos hame sirf vahi session use krna hai jo already exist krte hain and not all sessions
		if(session==null || session.getAttribute("userId")==null || !"employer".equals((String)session.getAttribute("userRole"))) {
			response.sendRedirect("login.jsp");
			return;
		}
		
		int employerId=(Integer)session.getAttribute("userId");
		String search=request.getParameter("search");
		String sort=request.getParameter("sort");
		String status=request.getParameter("status");
		
		try {
			List<JobPojo> jobList=JobDAO.getJobsByEmployer(employerId, search, status, sort); //yeh data ham employerDashboard.jsp ko bhejenge for filtering on jobs posted by employer and save the form state after the jsp reloads to show the data sent by dashboard
			request.setAttribute("jobList", jobList);
			request.setAttribute("search", search);
			request.setAttribute("status", status);
			request.setAttribute("sort", sort);
			
			RequestDispatcher rd=request.getRequestDispatcher("employerDashboard.jsp");
			rd.forward(request, response);
		}
		catch(Exception ex) {
			ex.printStackTrace();
			response.sendRedirect("error.jsp");
		}
	}

}
