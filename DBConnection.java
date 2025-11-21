package hiroaiapp.dbutils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	private static Connection conn;

	public static void openConnection(String dbUrl, String username, String password) {
		try {
			conn = DriverManager.getConnection(dbUrl, username, password);
			System.out.println("Connected successfully to the DB");
		} catch (SQLException ex) {
			System.out.println("Cannot open connection in DBConnection");
			ex.printStackTrace();
		}
	}

	public static Connection getConnection() throws SQLException {
		if (conn == null) {
			throw new SQLException("Connection not opened");
		} else {
			return conn;
		}
	}

	public static void closeConnection() {
		if (conn != null) {
			try {
				conn.close();
				System.out.println("Connection closed successfully");
			} catch (SQLException ex) {
				System.out.println("Cannot close connection in DBConnection");
				ex.printStackTrace();
			}
		}
	}
}