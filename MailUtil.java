package hiroaiapp.utils;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class MailUtil {

//	this mail was for sending a Welcome message
	public static void sendTextEmail(String recepientEmail, String subject, String body) throws MessagingException{
		Session sess=MailConfig.getSession();	
		Message message = new MimeMessage(sess);
		
		InternetAddress [] addr=InternetAddress.parse(recepientEmail);
		message.setRecipients(Message.RecipientType.TO, addr);
		message.setSubject(subject);
		message.setText(body);
		
		Transport.send(message);
	}
	
	public static void sendApplicationConfirmation(String name, String toEmail, String jobTitle, String company) throws MessagingException{
		String subject="✅ Applied Successfully for "+jobTitle;
		String body="\n\nDear "+name+",\n\nYou have successfully applied for the position of "+jobTitle+" at "+company+".\n\n";
		body+="We wish you best of luck.\n\n"+"Regards, Team HiroAI";
		sendTextEmail(toEmail,subject,body);
	}
	
	public static void sendNewApplicationNotificationToEmployer(String employerName, String toEmail, String applicant, String jobTitle) throws MessagingException{
		String subject="✅ New application received for "+jobTitle;
		String body="\n\nDear "+employerName+",\n\nA new candidate "+applicant+" has applied for the position of "+jobTitle+".";
		body+="\n\nYou can review the applicant details in your dashboard.\n\n"+"Regards, Team HiroAI";
		sendTextEmail(toEmail,subject,body);
	}
	
	public static void sendShortlistingConfirmation(String name, String toEmail, String jobTitle, String company) throws MessagingException{
		String subject = "🎉 Shortlisted for " + jobTitle + "!";
		String body = "\n\nDear " + name + ",\n\n"
		        + "Congratulations! You have been *shortlisted* for the position of **" + jobTitle + "** at **" + company + "**.\n\n"
		        + "The hiring team was impressed with your profile.\n"
		        + "They will contact you soon regarding further interview steps.\n\n"
		        + "Wishing you all the best.\n\n"
		        + "Regards,\nTeam HiroAI";
	}
	
	public static void sendRejectionConfirmation(String name, String toEmail, String jobTitle, String company) throws MessagingException{
		String subject = "Update on Your Application for " + jobTitle;
		String body = "\n\nDear " + name + ",\n\n"
		        + "Thank you for applying for the position of **" + jobTitle + "** at **" + company + "**.\n\n"
		        + "After careful review, we regret to inform you that your application has *not been shortlisted* at this stage.\n"
		        + "Please do not be discouraged — we encourage you to apply for future openings that match your profile.\n\n"
		        + "We appreciate your interest and wish you success in your career ahead.\n\n"
		        + "Regards,\nTeam HiroAI";

	}
}
