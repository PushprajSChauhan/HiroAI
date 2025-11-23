package hiroaiapp.controllers;

import java.io.IOException;
import java.util.List;

import org.json.JSONObject;

import hiroaiapp.dao.ApplicationDAO;
import hiroaiapp.dao.JobDAO;
import hiroaiapp.dao.ResumeAnalysisLogDAO;
import hiroaiapp.dao.UserDAO;
import hiroaiapp.pojo.ApplicationPojo;
import hiroaiapp.pojo.JobPojo;
import hiroaiapp.pojo.ResumeAnalysisLogPojo;
import hiroaiapp.pojo.UserPojo;
import hiroaiapp.utils.MailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ApplyJobServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session=request.getSession(false); //yaha false isliye likha hai bcos hame sirf vahi session use krna hai jo already exist krte hain and not all sessions
		if(session==null || session.getAttribute("userId")==null) {
			response.sendRedirect("login.jsp");
			return;
		}
		
		int userId=(Integer)session.getAttribute("userId");
		int jobId=Integer.parseInt(request.getParameter("jobId"));
		int score=Integer.parseInt(request.getParameter("score"));
		
		try {
			String resumePath="N/A";
			List<ResumeAnalysisLogPojo> logs=ResumeAnalysisLogDAO.getLogsByUser(userId);
			if(!logs.isEmpty()) {
				String resultJson=logs.get(0).getJsonResult();
				JSONObject obj=new JSONObject(resultJson);
				JSONObject data=obj.getJSONObject("data");
				resumePath=data.optString("resumePath","N/A"); //data is the key in a Map, using which we are fetching another key named resumePath, if found it will be returned otherwise return N/A
			}
			ApplicationPojo app=new ApplicationPojo(0,userId,jobId,resumePath,score,"Applied",null);
			ApplicationDAO.applyForJob(app); //here the application process is over for the user, now mails will be sent to applicant and employer
			
			UserPojo user1=UserDAO.getUserById(userId); //here user is applicant
			JobPojo job=JobDAO.getJobById(jobId);
			MailUtil.sendApplicationConfirmation(user1.getName(), user1.getEmail(), job.getTitle(), job.getCompany());
			
			UserPojo user2=UserDAO.getUserById(job.getEmployerId()); //here user is employer
			MailUtil.sendNewApplicationNotificationToEmployer(user2.getName(), user2.getEmail(), user1.getName(), job.getTitle());
			
//			response.sendRedirect("userDashboard.jsp?success=applied"); 
			response.sendRedirect("UserDashboardServlet?success=applied");

		}
		catch(Exception ex) {
			ex.printStackTrace();
//			response.sendRedirect("userDashboard.jsp?error=apply_failed"); 
			response.sendRedirect("error.jsp");

		}
	}

}
