package hiroaiapp.controllers;

import java.io.IOException;
import java.util.List;

import hiroaiapp.dao.JobDAO;
import hiroaiapp.dao.UserDAO;
import hiroaiapp.pojo.JobPojo;
import hiroaiapp.pojo.UserPojo;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminPanelServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false); // yaha false isliye likha hai bcos hame sirf vahi session use
															// krna hai jo already exist krte hain and not all sessions
		if (session == null || session.getAttribute("userId") == null
				|| !"admin".equals((String) session.getAttribute("userRole"))) {
			response.sendRedirect("login.jsp");
			return;
		}

		String search = request.getParameter("search");
		String role = request.getParameter("role");
		String status = request.getParameter("status");

		try {
			List<UserPojo> list = UserDAO.getFilteredUsers(search, role, status);
			request.setAttribute("users", list);

			List<JobPojo> jobs = JobDAO.getAllJobsWithEmployerAndApplicantCount();
			request.setAttribute("jobs", jobs);

			request.setAttribute("search", search);
			request.setAttribute("role", role);
			request.setAttribute("status", status);
			request.setAttribute("userSuccess", request.getParameter("userSuccess"));

			RequestDispatcher rd = request.getRequestDispatcher("adminPanel.jsp");
			rd.forward(request, response);
		} catch (Exception ex) {
			ex.printStackTrace();
			response.sendRedirect("error.jsp");
		}
	}

}
