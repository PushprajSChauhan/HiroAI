package hiroaiapp.controllers;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DownloadResumeServlet extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String resumePath=request.getParameter("path");
		if(resumePath==null || !new File(resumePath).exists()){
			response.sendError(HttpServletResponse.SC_NOT_FOUND); //control comes here means that the resume file does not exists
			return;
		}
		
		File file=new File(resumePath); //here we got connected with the file to be downloaded
		response.setContentType("application/pdf"); //this line tells browser that the file to be downloaded is a PDF file
		response.setHeader("Content-Description", "attachment;filename\""+file.getName()+"\""); //this gives browser the info about PDF file name which will be used when saving the file on user's system
		
//		now we will write file generation code
		try(FileInputStream inp=new FileInputStream(file); OutputStream out=response.getOutputStream();){
//			one object will fetch data from file by reading and another will write the data in response
			byte[]buffer=new byte[1024];
			int bytesRead;
			while((bytesRead=inp.read(buffer))!=-1) {
				 out.write(buffer,0,bytesRead); //first argument tells what to write, second index tell from which index to start writing and third argument says how much to write  
			}
		}
	}
}
