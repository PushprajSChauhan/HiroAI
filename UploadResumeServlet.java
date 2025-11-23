package hiroaiapp.controllers;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.List;

import org.json.JSONObject;

import hiroaiapp.dao.ResumeAnalysisLogDAO;
import hiroaiapp.pojo.ResumeAnalysisLogPojo;
import hiroaiapp.utils.AffindaAPI;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@MultipartConfig // this is added to access the pdf files sent by user as resume
public class UploadResumeServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("userId") == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		int userId = (Integer) session.getAttribute("userId");
		Part filePart = request.getPart("resume"); // yeh Part object mei resume file convert hoke ayegi form se through
													// an input control of type 'file' named 'resume'
		String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

		String uploadDir = getServletContext().getRealPath("/resumes");
		File dir = new File(uploadDir);
		if (!dir.exists()) {
			dir.mkdirs();
		}
		File resumeFile = new File(dir, fileName);
		
//		here we will first delete the previous resumes uploaded by user
		try {
			List<ResumeAnalysisLogPojo> logs = ResumeAnalysisLogDAO.getLogsByUser(userId);
			if (!logs.isEmpty()) {
				String prevJson = logs.get(0).getJsonResult();
				JSONObject obj = new JSONObject(prevJson);
				String prevPath = obj.getJSONObject("data").optString("resumePath", null);
				if (prevPath != null) {
					File oldFile = new File(prevPath);
					if (oldFile.exists()) {
						oldFile.delete();
					}
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		
		try (InputStream input = filePart.getInputStream(); 
				FileOutputStream out = new FileOutputStream(resumeFile)) {
			byte[] buffer = new byte[1024]; //ek baar mei file se 1024 characters padh padh ke out object mei enter hote jayenge
			int bytesRead;
			while ((bytesRead = input.read(buffer)) != -1) { //the read method will go thru the uploaded file and return -1 when it stops reading
				out.write(buffer, 0, bytesRead);
			}
		}
		
		// Call Affinda API
		try {
			String resultJson=AffindaAPI.analyzeResume(resumeFile);
			JSONObject result=new JSONObject(resultJson);
			result.getJSONObject("data").put("resumePath", resumeFile.getAbsolutePath()); //along with the resume file another key will also be stored having the resume path
			ResumeAnalysisLogDAO.saveLog(userId, result.toString());
		}		
		catch(Exception ex) {
			ex.printStackTrace();
		}
//		response.sendRedirect("userDashboard.jsp"); 
		String jobIdParam = request.getParameter("jobId");
		if (jobIdParam != null && !jobIdParam.isEmpty()) {
		    // Redirect to apply for the specific job
		    int jobId = Integer.parseInt(jobIdParam);
		    String skills = request.getParameter("skills");
		    // Forward to ApplyJobServlet
		    request.setAttribute("jobId", jobId);
		    request.getRequestDispatcher("ApplyJobServlet").forward(request, response);
		} else {
		    // Just uploaded resume without applying
		    response.sendRedirect("UserDashboardServlet");
		}
	}

}
