package hiroaiapp.controllers;

import java.io.IOException;

import hiroaiapp.dao.JobDAO;
import hiroaiapp.dao.UserDAO;
import hiroaiapp.pojo.UserPojo;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class UpdateUserStatusServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("userId"));
        String action = request.getParameter("action");   // block | unblock
        String newStatus = action.equals("block") ? "blocked" : "active";
        String role = request.getParameter("role");

        try {
            int userResult = UserDAO.updateStatus(userId, newStatus);

            if (userResult >= 1) {

                if ("block".equals(action) && role.equals("employer")) {
                       JobDAO.updateJobStatusByEmployer(userId, "inactive");
                }
                response.sendRedirect("AdminPanelServlet?userSuccess=1");
            } else {
                response.sendRedirect("AdminPanelServlet?userSuccess=0");
            }

        } catch (Exception e) {
            System.out.println("Error in UpdateUserStatusServlet");
            e.printStackTrace();
        }
    }
}
