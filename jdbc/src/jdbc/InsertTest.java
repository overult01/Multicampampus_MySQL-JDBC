package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class InsertTest {

	public static void main(String[] args) {

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");

			Connection conn =
			DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "12345678");
			System.out.println("mysql db 연결 성공");
			
		// 명령행 매개변수 이용 : run confiuration - arguments - 이사원 2 입력. args[0] 하면 이사원은 급여 2배. 
			// SQL update문 : update 테이블명 set 변경컬럼명 = 변경값 where 변경레코드조건식
			String updateSQL = "update emp_copy set salary ="+ args[1] + "*salary where first_name = '" + args[0] + "'";
			Statement st = conn.createStatement();   // conn에 sql문 전송. 즉 DB로 전달.
			int insertRow = st.executeUpdate(updateSQL);  // executeUpdate메서드: 실행할 문장을 담아 DB로 요청하는 메서드.			
			System.out.println(insertRow + "개의 행 수정 완료");

//			executeUpdate메서드(int 타입으로 작업반영된 행개수 리턴) : insert, update, delete사용시 
//			executeQuery메서드(테이블구조의 ResultSet리턴): select 사용시.
			
			// sql문 주의사항: 공백주기, 문장 끝에 ;붙이지 말기(자동으로 드라이버가 붙여준다.)
			// 워크밴치 설정과 jdbc는 별개다. 
			// jdbc에서는 insert, delete, update, select만 하자. create table, drop table등 하지말자. (삭제하면 복구불가)
			// 항상 사용한 뒤에는 연결을 끊어줘야 한다. 
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
