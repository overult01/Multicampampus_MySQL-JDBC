package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionTest {

	public static void main(String[] args) {

		try {
			// MySQL DB용 드라이로드
			Class.forName("com.mysql.cj.jdbc.Driver");
			// DB연결 
			Connection conn =
			DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "12345678");
			System.out.println("mysql db 연결 성공");
		
			// DB연결해제(필수!!)
			conn.close();
			System.out.println("mysql 연결해제 성공");
		}
		catch(ClassNotFoundException error) {
			System.out.println("mysql driver 미설치 또는 드라이버 이름 오류");
		}
		catch(SQLException error) {
			System.out.println("DB접속오류");
		}
		
	}

}
