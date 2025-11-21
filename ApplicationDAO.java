package hiroaiapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import hiroaiapp.dbutils.DBConnection;
import hiroaiapp.pojo.ApplicationPojo;

public class ApplicationDAO {

	public static boolean applyForJob(ApplicationPojo application) throws Exception{
		Connection conn=null;
		PreparedStatement ps=null;
		
		try {
			conn=DBConnection.getConnection();
			ps=conn.prepareStatement("insert into applications (user_id, job_id, resume_path, score) values (?,?,?,?)");
			ps.setInt(1, application.getUserId());
			ps.setInt(2, application.getJobId());
			ps.setString(3,application.getResumePath());
			ps.setDouble(4, application.getScore());
			
			int ans=ps.executeUpdate();
			return ans>0;
		}
		finally {
			if(ps!=null) {
				ps.close();
			}
		}
	}
	
	public static List<ApplicationPojo> getApplicationsByUserId(int userId) throws Exception{
		Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		
		List<ApplicationPojo> list=new ArrayList<>();
		
		try {
			conn=DBConnection.getConnection();
			ps=conn.prepareStatement("select * from applications where user_id=?");
			ps.setInt(1, userId);
			
			rs=ps.executeQuery();
			while(rs.next()) {
				ApplicationPojo application=new ApplicationPojo();
				application.setId(rs.getInt("id"));
				application.setJobId(rs.getInt("job_id"));
				application.setUserId(rs.getInt("user_id"));
				application.setResumePath(rs.getString("resume_path"));
				application.setScore(rs.getDouble("score"));
				application.setStatus(rs.getString("status"));
				application.setAppliedAt(rs.getString("applied_at"));
				
				list.add(application);
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
	
	public static List<ApplicationPojo> getApplicationsByJobAndStatus(int jobId, String status) throws Exception{
		Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		
		List<ApplicationPojo> list=new ArrayList<>();
		
		try {
			conn=DBConnection.getConnection();
			ps=conn.prepareStatement("select * from applications where job_id=? and status=? order by score desc");
			ps.setInt(1, jobId);
			ps.setString(2, status);
			rs=ps.executeQuery();
			
			while(rs.next()) {
				ApplicationPojo application=new ApplicationPojo();
				application.setId(rs.getInt("id"));
				application.setJobId(rs.getInt("job_id"));
				application.setUserId(rs.getInt("user_id"));
				application.setResumePath(rs.getString("resume_path"));
				application.setScore(rs.getDouble("score"));
				application.setStatus(rs.getString("status"));
				application.setAppliedAt(rs.getString("applied_at"));
				
				list.add(application);
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
	
	public static boolean updateApplicationStatus(int applicationId, String status) throws Exception{
		Connection conn=null;
		PreparedStatement ps=null;
		
		try {
			conn=DBConnection.getConnection();
			ps=conn.prepareStatement("update applications set status=? where id=?");
			ps.setString(1, status);
			ps.setInt(2, applicationId);
			
			return ps.executeUpdate()>0;
		}
		finally {
			if(ps!=null) {
				ps.close();
			}
		}
	}

	public static ApplicationPojo getApplicationById(int applicationId) throws Exception {
	    Connection conn = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;

	    try {
	        conn = DBConnection.getConnection();
	        ps = conn.prepareStatement(
	            "SELECT id, user_id, job_id, resume_path, score, status, applied_at " +
	            "FROM applications WHERE id=?"
	        );
	        ps.setInt(1, applicationId);

	        rs = ps.executeQuery();

	        if (rs.next()) {
	            ApplicationPojo obj = new ApplicationPojo();
	            obj.setId(rs.getInt("id"));
	            obj.setJobId(rs.getInt("job_id"));
	            obj.setUserId(rs.getInt("user_id"));
	            obj.setStatus(rs.getString("status"));
	            obj.setAppliedAt(rs.getTimestamp("applied_at").toString());
	            obj.setResumePath(rs.getString("resume_path"));
	            obj.setScore(rs.getInt("score"));
	            return obj;
	        }

	        return null;

	    } finally {
	        if (rs != null) rs.close();
	        if (ps != null) ps.close();
	    }
	}

}
