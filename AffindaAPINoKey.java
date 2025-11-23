package hiroaiapp.utils;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.json.JSONArray;
import org.json.JSONObject;

public class AffindaAPI {
//	this class has 2 major tasks: analyze the resume file using Affinda and transfer the data after extracting it from the API response for displaying on the frontend 

	private static final String API_KEY = "<Affinda_API_KEY>";

	public static String analyzeResume(File resumeFile) throws IOException {
		String boundary = "----WebKitFormBoundary" + UUID.randomUUID(); // it is the boundary value required by the
																		// Affinda API while processing the input or
																		// attachment just like the browser does to our
																		// attachments
		String LINE_FEED = "\r\n";

		URL url = new URL("https://api.affinda.com/v2/resumes"); // actual API communication starts from here
		HttpURLConnection connection = (HttpURLConnection) url.openConnection(); // this class is mainly used for API
																					// calling
		connection.setRequestMethod("POST");
		connection.setRequestProperty("Authorization", "Bearer " + API_KEY);
		connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
		connection.setDoOutput(true); // by this line we tell Affinda that we need permission to send output stream to
										// write the data and send it to server

//		here we have used try with resources which was introduced in Java 7, and gives us the feature of auto closing the resources created inside it like connections, files etc
//		and as we have written throws IOException in method declaration, we do not have to write catch also
		try (OutputStream output = connection.getOutputStream();
				PrintWriter writer = new PrintWriter(new OutputStreamWriter(output, StandardCharsets.UTF_8), true)) {

			writer.append("--" + boundary).append(LINE_FEED);
			writer.append("Content-Disposition: form-data; name=\"file\"; filename=\"" + resumeFile.getName() + "\"")
					.append(LINE_FEED);
			writer.append("Content-Type: application/pdf").append(LINE_FEED);
			writer.append(LINE_FEED).flush();

			Files.copy(resumeFile.toPath(), output); // actual data from the PDF file is appended here for sending it to
														// server in the form of bytes, the copy method will take all
														// data from file and write that data in output object which is
														// connected to server
			output.flush();

			writer.append(LINE_FEED).flush();
			writer.append("--" + boundary + "--").append(LINE_FEED);
			writer.flush();
		}

//		now we will capture the response sent by Affinda API in the form of bytes, convert it in a String and return it to servlet in JSON format
		InputStream responseStream = connection.getResponseCode() == 200 ? connection.getInputStream()
				: connection.getErrorStream();

		return new String(responseStream.readAllBytes(), StandardCharsets.UTF_8);
	}

//	now we will create different methods to extract various types of data from this JSON String
	public static String extractSummary(String resultJson) {
		String summary = null;
		try {
			JSONObject result = new JSONObject(resultJson);
			JSONObject data = result.getJSONObject("data");
			JSONArray summaryArr = data.optJSONArray("sections");
			if (summaryArr != null) {
				for (int i = 0; i < summaryArr.length(); i++) {
					JSONObject summaryObj = summaryArr.getJSONObject(i);
					String sectionType = summaryObj.optString("sectionType");
					if (sectionType.equalsIgnoreCase("Summary")) {
						summary = summaryObj.optString("text");
						break;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return summary;
	}

	public static String[] extractPersonalDetails(String resultJson) {
		String personalDetails = null;
		try {
			JSONObject result = new JSONObject(resultJson);
			JSONObject data = result.getJSONObject("data");
			JSONArray sectionArr = data.optJSONArray("sections");
			if (sectionArr != null) {
				for (int i = 0; i < sectionArr.length(); i++) {
					JSONObject sectionObj = sectionArr.getJSONObject(i);
					String sectionType = sectionObj.optString("sectionType");
					if (sectionType.equalsIgnoreCase("PersonalDetails")) {
						personalDetails = sectionObj.optString("text");
						break;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return personalDetails.split("[ƒ#ï§œ]+");
	}

	public static String[] extractEducation(String resultJson) {
		String education = null;
		try {
			JSONObject result = new JSONObject(resultJson);
			JSONObject data = result.getJSONObject("data");
			JSONArray educationArr = data.optJSONArray("sections");
			if (educationArr != null) {
				for (int i = 0; i < educationArr.length(); i++) {
					JSONObject educationObj = educationArr.getJSONObject(i);
					String sectionType = educationObj.optString("sectionType");
					if (sectionType.equalsIgnoreCase("Education")) {
						education = educationObj.optString("text");
						break;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return education.split("\n");
	}

	public static List<String> extractSkills(String resultJson) {
		List<String> skills = new ArrayList<>();
		try {
			JSONObject result = new JSONObject(resultJson);
			JSONObject data = result.getJSONObject("data");
			JSONArray skillArray = data.optJSONArray("skills");
			if (skillArray != null) {
				for (int i = 0; i < skillArray.length(); i++) {
					JSONObject skillObj = skillArray.getJSONObject(i);
					String name = skillObj.optString("name");
					if (name != null && !name.isEmpty()) {
						skills.add(name.trim().toLowerCase());
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return skills;
	}
	
	public static String[] extractWorkExperience(String resultJson) {
		String experience=null;
		String totalExperience=null;
		try {
			JSONObject result=new JSONObject(resultJson);
			JSONObject data=result.getJSONObject("data");
			JSONArray experienceArr=data.optJSONArray("sections");
			totalExperience=data.optString("totalYearsExperience");
			if(experienceArr!=null) {
				for(int i=0;i<experienceArr.length();i++) {
					JSONObject experienceObj=experienceArr.getJSONObject(i);
					String sectionType=experienceObj.optString("sectionType");
					if(sectionType.equalsIgnoreCase("WorkExperience")) {
						experience=experienceObj.optString("text");
						break;
					}
				}
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
		return experience.split("\\n|\\. ");
	}
	
	public static int calculateMatchScore(String jobSkillsCsv, List<String> resumeSkills){
        if(resumeSkills == null || resumeSkills.isEmpty()) return 0;

        String[] jobSkills = jobSkillsCsv.split(",");
        Set<String> required = new HashSet<>();
        for(String s : jobSkills){
            required.add(s.trim().toLowerCase());
        }
        int matched = 0;

        for(String r : required){
            for (String s : resumeSkills) {
                if (s.toLowerCase().contains(r.toLowerCase())) {
                    matched ++;
                    break;
                }
            }

        }

        return (int) ((matched*100)/required.size());
    }
}
