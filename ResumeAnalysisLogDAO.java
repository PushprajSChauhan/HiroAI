package hiroaiapp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import hiroaiapp.dbutils.DBConnection;
import hiroaiapp.pojo.ResumeAnalysisLogPojo;

public class ResumeAnalysisLogDAO {

//	this method will be used to save the JSON String returned by Affinda API in DB 
	public static void saveLog(int userId, String resultJson) throws Exception{
		Connection conn=null;
		PreparedStatement ps=null;
		
		try {
			conn=DBConnection.getConnection();
			ps=conn.prepareStatement("insert into resume_analysis_logs (user_id, result_json) values (?,?)");
			ps.setInt(1, userId);
			ps.setString(2, resultJson);
			ps.executeUpdate();
		}
		finally {
			if(ps!=null) {
				ps.close();
			}
		}
	}
	
	public static List<ResumeAnalysisLogPojo> getLogsByUser(int userId) throws Exception{
		Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		
		List<ResumeAnalysisLogPojo> list=new ArrayList<>();
		
		try {
			conn=DBConnection.getConnection();
			ps=conn.prepareStatement("select * from resume_analysis_logs where user_id=? order by created_at desc");
			ps.setInt(1, userId);
			
			rs=ps.executeQuery();
			while(rs.next()) {
				ResumeAnalysisLogPojo obj=new ResumeAnalysisLogPojo();
				obj.setId(rs.getInt("id"));
				obj.setUserId(rs.getInt("user_id"));
				obj.setJsonResult(rs.getString("result_json"));
				obj.setCreatedAt(rs.getString("created_at"));
				
				list.add(obj);
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
}
