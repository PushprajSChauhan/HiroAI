package hiroaiapp.controllers;

import java.io.IOException;
import java.util.List;

import hiroaiapp.dao.ApplicationDAO;
import hiroaiapp.dao.JobDAO;
import hiroaiapp.pojo.ApplicationPojo;
import hiroaiapp.pojo.JobPojo;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ViewApplicantsServlet extends HttpServlet {
	
//	yeh servlet tab chlega jab View applicants wale anchor tag pe click hoga jiss se GET request fire hogi isliye doGet ko override kra hai
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session=request.getSession(false);
		if(session==null || session.getAttribute("userId")==null || !"employer".equals((String)session.getAttribute("userRole"))) {
			response.sendRedirect("login.jsp");
			return;
		}
		
		try {
			int jobId=Integer.parseInt(request.getParameter("jobId"));
			String status=request.getParameter("status") != null ? request.getParameter("status") : "applied";
//			Fetch Job Details
			JobPojo job=JobDAO.getJobById(jobId);
			if(job==null) {
				response.sendRedirect("EmployerDashboardServlet?error=InvalidJob"); //yeh output chala jayega JSP ke paas and yaha se return krke JSP isse popup mei show krdega
				return;
			}
			
			List<ApplicationPojo> list=ApplicationDAO.getApplicationsByJobAndStatus(jobId, status);
			request.setAttribute("job", job);
			request.setAttribute("applicants", list);
			request.setAttribute("status", status);	
			request.setAttribute("update", request.getParameter("update"));
			
			RequestDispatcher rd=request.getRequestDispatcher("viewApplicants.jsp");
			rd.forward(request, response);
		}
		catch(Exception ex) {
			throw new ServletException("Unable to fetch Applicants or Job Details");
		}
	}
}
