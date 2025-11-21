package hiroaiapp.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import hiroaiapp.dao.ApplicationDAO;
import hiroaiapp.dao.JobDAO;
import hiroaiapp.dao.ResumeAnalysisLogDAO;
import hiroaiapp.pojo.ApplicationPojo;
import hiroaiapp.pojo.JobPojo;
import hiroaiapp.pojo.ResumeAnalysisLogPojo;
import hiroaiapp.utils.AffindaAPI;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class UserDashboardServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("userId") == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		int userId = (Integer) session.getAttribute("userId");
		String search = request.getParameter("search");
		String sort = request.getParameter("sort");
		String location = request.getParameter("location");
		String experience = request.getParameter("experience");
		String packageLpa = request.getParameter("packageLpa");

		try {
			List<ResumeAnalysisLogPojo> logs = ResumeAnalysisLogDAO.getLogsByUser(userId);
			boolean resumeUploaded = !logs.isEmpty(); // agar resume upload hua hoga toh variable mei true ayega and
														// agar nahi hua hoga toh variable mei false ayega
			List<String> userSkills = null;
			if (resumeUploaded) {
				JSONObject obj = new JSONObject(logs.get(0).getJsonResult()); // yaha pehle DB se milne wali String ko
																				// JSON mei convert kara
				userSkills = AffindaAPI.extractSkills(obj.toString()); // fir yaha JSON ka string version pass kiya to
																		// get the skills of user
			}

			List<JobPojo> jobs = JobDAO.getAllJobsForUserDashboard(search, sort, location, experience, packageLpa);
			if (resumeUploaded && userSkills != null) {
				for (JobPojo job : jobs) {
					int score = AffindaAPI.calculateMatchScore(job.getSkills(), userSkills);
					job.setScore(score);
				}
			}

			List<ApplicationPojo> appliedList = ApplicationDAO.getApplicationsByUserId(userId);
//			ab jitni bhi jobs keliye user ne apply kiya hai unhe ApplicationPojo mei se nikal kar ek Set mei daalke aage bhejna hai on UserDashboard JSP to show whether the user has applied for that Job or not based on the Job ID
			Map<Integer, String> appliedJobIds = new HashMap<>();
			for (ApplicationPojo app : appliedList) {
				appliedJobIds.put(app.getJobId(), app.getStatus());
			}

			request.setAttribute("jobs", jobs);
			request.setAttribute("appliedJobIds", appliedJobIds);
			request.setAttribute("search", search);
			request.setAttribute("sort", sort);
			request.setAttribute("location", location);
			request.setAttribute("experience", experience);
			request.setAttribute("packageLpa", packageLpa);
			request.setAttribute("resumeUploaded", resumeUploaded);

			RequestDispatcher rd = request.getRequestDispatcher("userDashboard.jsp");
			rd.forward(request, response);
		} catch (Exception ex) {
			ex.printStackTrace();
			response.sendRedirect("error.jsp");
		}
	}
}
