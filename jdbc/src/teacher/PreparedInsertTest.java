package teacher;

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
		DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "emp");
		System.out.println("mysql db 연결 성공");

		//명령행 매개변수 5개 입력 - 이자바 java2@b.com 01022246788 법학 us
		String insertSQL = "insert into students values(null, ?, ?, ?, ?, default, ?)";
		
		PreparedStatement pt = conn.prepareStatement(insertSQL);// db전송 구문분석 컴파일-저장
		 //sql 입력파라미터값 설정
		 //pt.setString(1, args[0]);
		 pt.setString(2, args[1]);
		 pt.setString(3, args[2]);
		 pt.setString(4, args[3]);
		 pt.setString(5, args[4]);
		 
		 int rows = pt.executeUpdate();//실행결과리턴
		 System.out.println(rows + " 개의 행 삽입 완료");
		
		
		//Statement st = conn.createStatement();
		//int insertROW = st.executeUpdate(insertSQL);
		
		
		conn.close();
		System.out.println("mysql db 연결 해제 성공");		
		}
		catch(ClassNotFoundException e) {
			System.out.println("mysql driver 미설치 또는 드라이버이름 오류");
		}
		catch(SQLException e) {
			System.out.println("db접속오류이거나 sql문장오류");
			e.printStackTrace();
		}

	}

}


