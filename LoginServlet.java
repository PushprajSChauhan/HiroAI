package hiroaiapp.controllers;

import java.io.IOException;

import hiroaiapp.dao.UserDAO;
import hiroaiapp.pojo.UserPojo;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email=request.getParameter("email");
		String password=request.getParameter("password");
		
		try {
			UserPojo user=UserDAO.getUserByEmail(email);
			if(user!=null && password.equals(user.getPassword()) && "active".equals(user.getStatus())) {
				HttpSession session=request.getSession();
				session.setAttribute("userId", user.getId());
				session.setAttribute("userName", user.getName());
				session.setAttribute("userRole", user.getRole());
				switch(user.getRole()) {
					case "admin":
						response.sendRedirect("AdminPanelServlet");
						break;
					case "employer":
						response.sendRedirect("EmployerDashboardServlet");
						break;
					default: 
						response.sendRedirect("UserDashboardServlet");
						break;
				}
			}
			else {
				request.setAttribute("error", "Invalid Credentials or Account Blocked!");
				RequestDispatcher rd=request.getRequestDispatcher("login.jsp");
				rd.forward(request, response);
			}
		}
		catch(Exception ex) {
			throw new ServletException("Login Failed: "+ex.getMessage());
		}
	}

}
