package hiroaiapp.controllers;

import java.io.IOException;

import hiroaiapp.dao.UserDAO;
import hiroaiapp.pojo.UserPojo;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class VerifyRegisterOTPServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		String inputOTP = request.getParameter("otp");
		String actualOTP = (String) session.getAttribute("regOTP");

		if (inputOTP.equals(actualOTP)) {
			String name = (String) session.getAttribute("regName");
			String email = (String) session.getAttribute("regEmail");
			String password = (String) session.getAttribute("regPassword");
			String role = (String) session.getAttribute("regRole");

			UserPojo user = new UserPojo(0, name, email, password, role, "active", null);

			try {
				UserDAO.registerUser(user);
				session.removeAttribute("regOTP");
				response.sendRedirect("login.jsp?registered=true");
			} catch (Exception ex) {
				throw new ServletException("Error in OTP verification/registration " + ex.getMessage());
			}
		} else {
			response.sendRedirect("register.jsp?showOtp=true&error=invalid");
		}
	}

}
