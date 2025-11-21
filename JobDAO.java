package hiroaiapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import hiroaiapp.dbutils.DBConnection;
import hiroaiapp.pojo.JobPojo;

public class JobDAO {
	
	public static boolean postJob(JobPojo job) throws Exception{
		Connection conn=null;
		PreparedStatement ps=null;
		
		boolean result=false;
		
		try {
			conn=DBConnection.getConnection();
			ps=conn.prepareStatement("insert into jobs (title, description, skills, company, location, experience, package_lpa, vacancies, employer_id) values (?,?,?,?,?,?,?,?,?)");
			ps.setString(1, job.getTitle());
			ps.setString(2, job.getDescription());
			ps.setString(3, job.getSkills());
			ps.setString(4, job.getCompany());
			ps.setString(5, job.getLocation());
			ps.setString(6, job.getExperience());
			ps.setString(7, job.getPackageLpa());
			ps.setInt(8, job.getVacancies());
			ps.setInt(9, job.getEmployerId());
			
			return result=ps.executeUpdate()>0;
		}
		finally {
			if(ps!=null) {
				ps.close();
			}
		}
	}
	
	public static JobPojo getJobById(int jobId) throws Exception{
		Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		
		JobPojo job=null;
		
		try {
			conn=DBConnection.getConnection();
			ps=conn.prepareStatement("select * from jobs where id=?");
			ps.setInt(1, jobId);
			
			rs=ps.executeQuery();
			if(rs.next()) {
				job=new JobPojo();
				job.setId(rs.getInt("id"));
				job.setTitle(rs.getString("title"));
				job.setDescription(rs.getString("description"));
				job.setSkills(rs.getString("skills"));
				job.setCompany(rs.getString("company"));
				job.setLocation(rs.getString("location"));
				job.setExperience(rs.getString("experience"));
				job.setPackageLpa(rs.getString("package_lpa"));
				job.setVacancies(rs.getInt("vacancies"));
				job.setEmployerId(rs.getInt("employer_id"));
				job.setCreatedAt(rs.getTimestamp("created_at"));
				job.setStatus(rs.getString("status"));
			}
			
			return job;
		}
		finally {
			if(rs!=null) {
				rs.close();
			}
			if(ps!=null) {
				ps.close();
			}
		}
	}
	
	public static List<JobPojo> getJobsByEmployer(int employerId, String search, String status, String sort) throws Exception{
		Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		
		List<JobPojo> list=new ArrayList<>();
		
		try {			
			conn=DBConnection.getConnection();
			
//			Base SQL query to fetch job details along with the number of applicants for each job id
			StringBuilder sql=new StringBuilder("select j.*,(select count(*) from applications a where a.job_id=j.id) as applicants_count from jobs j where j.employer_id=?");
			
//			Prepare the list of parameters in the query based on the filtering choice
			List<Object> params=new ArrayList<>();
			params.add(employerId);
			
//			Add search condition for any search term provided by employer
			if(search!=null && !search.trim().isEmpty()) {
				sql.append(" and j.title like ?");
				params.add("%"+search.trim()+"%");
			}
			
//			Add job status for any job posted by employer
			if(status!=null && !status.trim().isEmpty()) {
				sql.append(" and j.status=?");
				params.add(status);
			}
			
//			Handle sorting of jobs for each employer based on applicant count or date of job posting
			if("asc".equalsIgnoreCase(sort)) {
				sql.append(" order by applicants_count asc");
			}else if("desc".equalsIgnoreCase(sort)) {
				sql.append(" order by applicants_count desc");
			}
			else {
				sql.append(" order by j.created_at desc");
			}
			
			ps=conn.prepareStatement(sql.toString());
			for(int i=0;i<params.size();i++) {
				ps.setObject(i+1, params.get(i));
			}
			
			rs=ps.executeQuery();
			while(rs.next()) {
				JobPojo job=new JobPojo();
				job.setId(rs.getInt("id"));
				job.setTitle(rs.getString("title"));
				job.setDescription(rs.getString("description"));
				job.setSkills(rs.getString("skills"));
				job.setCompany(rs.getString("company"));
				job.setLocation(rs.getString("location"));
				job.setExperience(rs.getString("experience"));
				job.setPackageLpa(rs.getString("package_lpa"));
				job.setVacancies(rs.getInt("vacancies"));
				job.setEmployerId(rs.getInt("employer_id"));
				job.setCreatedAt(rs.getTimestamp("created_at"));
				job.setStatus(rs.getString("status"));
				job.setApplicantsCount(rs.getInt("applicants_count"));
				
				list.add(job);
			}
			
			return list;
		}
		finally {
			if(rs!=null) {
				rs.close();
			}
			if(ps!=null) {
				ps.close();
			}
		}
	}
	
	public static void toggleJobStatus(int jobId) throws Exception{
		Connection conn=null;
		PreparedStatement ps=null;
		
		try {
			conn=DBConnection.getConnection();
			
//			Here we use CASE, WHEN, THEN, END keywords which are used for conditional tasks like if-else in Java
			ps=conn.prepareStatement("update jobs set status= CASE when status='active' then 'inactive' else 'active' END where id=?");
			ps.setInt(1, jobId);
			ps.executeUpdate();
		}
		finally {
			if(ps!=null) {
				ps.close();
			}
		}
	}
	
//	This method is made for the role of ADMIN to remove fake job postings
	public static boolean deleteJob(int jobId) throws Exception{
		Connection conn=null;
		PreparedStatement ps1=null, ps2=null;
		
		try {
			conn=DBConnection.getConnection();
			
//			Yaha phle ham child table Applications se voh jobId wali applications delete krenge fir parent table Jobs se voh id wali job delete krenge
//			Iske liye hame phle auto-commit feature OFF krna pdega taki Applications table mei deletion ke time problem ane pe rollback krna possible ho
			
			conn.setAutoCommit(false);
			ps1=conn.prepareStatement("delete from applications where job_id=?");
			ps1.setInt(1, jobId);
			ps1.executeUpdate(); //agar yeh line bina exception ke chal jayegi toh ham samjhenge ki ab given job id keliye jobs table ki dependency applications table se khatam hogyi hai bhale hi uss job id keliye applications ayi ho ya nahi ayi ho
			
			ps2=conn.prepareStatement("delete from jobs where id=?");
			ps2.setInt(1, jobId);
			int rowsEffected=ps2.executeUpdate();
			
			conn.commit();
			
			return rowsEffected>0;
		}
		catch(Exception ex) {
//			Yaha ham voh code likhenge jo tab chlega jab Jobs table mei se row delete krte time problem ayegi but Applications table mei se row delete ho jayegi and rollback krna pdega iss deletion ko
			if(conn!=null) {
				conn.rollback(); //Yeh rollback ham DB consistency keliye kar rahe hain
			}
			
//			Yaha alag se exception throw karenge bcos hame frontend ko indicate krna hai ki problem ayi hai and usse handle karo properly
			throw ex;
		}
		finally {
			if(ps1!=null) {
				ps1.close();
			}
			if(ps2!=null) {
				ps2.close();
			}
		}
	}
	
	public static List<JobPojo> getAllJobsForUserDashboard(String search, String sort, String location, String experience, String packageLpa) throws Exception{
		Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		
		List<JobPojo> jobs=new ArrayList<>();
		
		try {
			conn=DBConnection.getConnection();
			
			StringBuilder sql=new StringBuilder("select * from jobs where status='active'");
			List<Object> params=new ArrayList<>();
			
			if(search!=null && !search.trim().isEmpty()) {
				sql.append(" and (title like ? or company like ?)");
				String input="%"+search.trim()+"%";
				params.add(input);
				params.add(input);
			}
			
			if(location!=null && !location.trim().isEmpty()) {
				sql.append(" and location like ?");
				params.add("%"+location.trim()+"%");
			}
			
			if(experience!=null && !experience.trim().isEmpty()) {
				sql.append(" and experience=?");
				params.add(experience.trim());
			}
			
			if(packageLpa!=null && !packageLpa.trim().isEmpty()) {
				sql.append(" and package_lpa=?");
				params.add(packageLpa.trim());
			}
			
			if("asc".equalsIgnoreCase(sort)) {
				sql.append(" order by vacancies asc");
			}else if("desc".equalsIgnoreCase(sort)) {
				sql.append(" order by vacancies desc");
			}
			else {
				sql.append(" order by created_at desc");
			}
			
			ps=conn.prepareStatement(sql.toString());
			for(int i=0;i<params.size();i++) {
				ps.setObject(i+1, params.get(i));
			}
			
			rs=ps.executeQuery();
			while(rs.next()) {
				JobPojo job=new JobPojo();
				job.setId(rs.getInt("id"));
				job.setTitle(rs.getString("title"));
				job.setDescription(rs.getString("description"));
				job.setSkills(rs.getString("skills"));
				job.setCompany(rs.getString("company"));
				job.setLocation(rs.getString("location"));
				job.setExperience(rs.getString("experience"));
				job.setPackageLpa(rs.getString("package_lpa"));
				job.setVacancies(rs.getInt("vacancies"));
				job.setEmployerId(rs.getInt("employer_id"));
				job.setCreatedAt(rs.getTimestamp("created_at"));
				job.setStatus(rs.getString("status"));
				
				jobs.add(job);
			}
			
			return jobs;
		}
		finally {
			if(rs!=null) {
				rs.close();
			}
			if(ps!=null) {
				ps.close();
			}
		}
	}
	
//	This method is also for ADMIN to see what all jobs are posted by employers and the number of applicants
	public static List<JobPojo> getAllJobsWithEmployerAndApplicantCount() throws Exception{
		Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		
		List<JobPojo> jobs=new ArrayList<>();
		
		try {
			conn=DBConnection.getConnection();
			
			String sql=new String("select j.*, (select count(*) from applications a where a.job_id=j.id) as applicants_count from jobs j");
			ps=conn.prepareStatement(sql);
			rs=ps.executeQuery();
			while(rs.next()) {
				JobPojo job=new JobPojo();
				job.setId(rs.getInt("id"));
				job.setTitle(rs.getString("title"));
				job.setDescription(rs.getString("description"));
				job.setSkills(rs.getString("skills"));
				job.setCompany(rs.getString("company"));
				job.setLocation(rs.getString("location"));
				job.setExperience(rs.getString("experience"));
				job.setPackageLpa(rs.getString("package_lpa"));
				job.setVacancies(rs.getInt("vacancies"));
				job.setEmployerId(rs.getInt("employer_id"));
				job.setCreatedAt(rs.getTimestamp("created_at"));
				job.setStatus(rs.getString("status"));
				job.setApplicantsCount(rs.getInt("applicants_count"));
				
				jobs.add(job);				
			}
			
			return jobs;
		}
		finally {
			if(rs!=null) {
				rs.close();
			}
			if(ps!=null) {
				ps.close();
			}
		}	
	}
	
	public static int updateJobStatusByEmployer(int employerId, String status) throws Exception {
	    Connection conn = null;
	    PreparedStatement ps = null;

	    try {
	        conn = DBConnection.getConnection();
	        ps = conn.prepareStatement("UPDATE jobs SET status=? WHERE employer_id=?");
	        ps.setString(1, status);
	        ps.setInt(2, employerId);
	        return ps.executeUpdate();
	    } finally {
	        if (ps != null) ps.close();
	    }
	}
}
