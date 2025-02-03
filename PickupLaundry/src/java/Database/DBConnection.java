package Database;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
	
	private static Connection conn = null;
	
	public static Connection getConnection(){
		try{
			// for pc
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Pickup_Laundry", "root", "");
			
			// for college lab
//			Class.forName("com.mysql.jdbc.Driver");
//			conn = DriverManager.getConnection("jdbc:mysql://192.168.40.8/bca21104", "bca21104", "bca21104");
			
//			System.out.println(conn);
		}
		catch(Exception e){
			System.out.println(e);
		}
		return conn;
	}
}
