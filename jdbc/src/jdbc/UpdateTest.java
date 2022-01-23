package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class UpdateTest {

	public static void main(String[] args) {

		try {
			// MySQL DB용 드라이버 로드
			Class.forName("com.mysql.cj.jdbc.Driver");

			// DB연결 
			Connection conn =
			DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "12345678");
			System.out.println("mysql db 연결 성공");
			
			// emp_copy 테이블 레코드 저장 - employee_id: 자동증가, first_name, salary, hire_date: current_date
			
			// 모든 sql문은 작성할 때 String 타입으로 쓰기 위해 "" 로 감싸야 한다.
//			String insertSQL = "insert into emp_copy values(null, '이름', 10000, current_date)";

			// 여러개 삽입 예제 - 서브쿼리
//			String insertSQL = "insert into emp_copy (select employee_id, first_name, salary, hire_date from employees)";
//			107개의 행 삽입 완료
			
			
			// 명령행 매개변수 이용 : run confiuration - arguments - 이사원 20000 args[0]
			String insertSQL = "insert into emp_copy values(null, '" + args[0] + "', " + args[1] + ", current_date)";
			Statement st = conn.createStatement();   // conn에 sql문 전송. 즉 DB로 전달.
			int insertRow = st.executeUpdate(insertSQL);  // executeUpdate메서드: 실행할 문장을 담아 DB로 요청하는 메서드.			
			System.out.println(insertRow + "개의 행 삽입 완료");

			// DB연결해제(필수!!): 연결 해제 하지 않으면 다른사람이 DB접근 불가. 
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
