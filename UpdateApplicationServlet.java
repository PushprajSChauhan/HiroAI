package hiroaiapp.controllers;

import java.io.IOException;

import hiroaiapp.dao.ApplicationDAO;
import hiroaiapp.dao.JobDAO;
import hiroaiapp.dao.UserDAO;
import hiroaiapp.pojo.JobPojo;
import hiroaiapp.pojo.UserPojo;
import hiroaiapp.utils.MailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class UpdateApplicationServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
        if(session.getAttribute("userId") == null || !session.getAttribute("userRole").equals("employer")){
            response.sendRedirect("login.jsp");
            return;
        }

        int appId = Integer.parseInt(request.getParameter("appId"));
        int jobId = Integer.parseInt(request.getParameter("jobId"));
        String status = request.getParameter("status");

        try{
        	boolean result = ApplicationDAO.updateApplicationStatus(appId, status);
            request.setAttribute("jobId", jobId);
            if(result){
                JobPojo job = JobDAO.getJobById(jobId);
                UserPojo user = UserDAO.getUserById(ApplicationDAO.getApplicationById(appId).getUserId());
                if(status.equals("shortlisted")){
                    MailUtil.sendShortlistingConfirmation(
                            user.getName(),
                            user.getEmail(),
                            job.getTitle(),
                            job.getCompany()
                    );
                }else{
                    MailUtil.sendRejectionConfirmation(
                            user.getName(),
                            user.getEmail(),
                            job.getTitle(),
                            job.getCompany()
                    );
                }
                request.getRequestDispatcher("ViewApplicantsServlet?update=1&jobId="+jobId).forward(request, response);
            }else {
                request.getRequestDispatcher("ViewApplicantsServlet?update=0&jobId="+jobId).forward(request, response);
            }
        } catch (Exception e) {	
            throw new ServletException(e+" exception in updateapplicationstatusservlet");
        }

	}

}
