package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

public class PreparedInsertTest {

	public static void main(String[] args) {

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");

			Connection conn =
			DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "12345678");
			System.out.println("mysql db 연결 성공");
			
		// 명령행 매개변수 이용 : run confiuration - arguments - (null, '김학생', 'kim@a.com', '01234567891', default, 'us')
			String insertSQL = "insert into students values(null, ?, ?, ?, default, ?)";
			
			// update문 : update 테이블명 set 변경컬럼명 =? where 컬럼명 = ? limit ? 
			
			PreparedStatement pt = conn.prepareStatement(insertSQL);
			pt.setString(1, args[0]);
			pt.setString(2, args[1]);
			pt.setString(3, args[2]);
			pt.setString(4, args[3]);

			
			Statement st = conn.createStatement();   // conn에 sql문 전송. 즉 DB로 전달.
			int insertRow = st.executeUpdate(insertSQL);  // executeUpdate메서드: 실행할 문장을 담아 DB로 요청하는 메서드.			
			System.out.println(insertRow + "개의 행 수정 완료");
			
			conn.close();
			System.out.println("mysql 연결해제 성공");
		}
		catch(ClassNotFoundException error) {
			System.out.println("mysql driver 미설치 또는 드라이버 이름 오류");
		}
		catch(SQLException error) {
			error.printStackTrace();  // sql문법오류 일수도, DB연결 오류일수도 있다. 따라서 원인파악 필요.
		}
		
	}

}
