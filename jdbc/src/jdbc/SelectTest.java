package jdbc;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class SelectTest {

	public static void main(String[] args) {

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");

			Connection conn =
			DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "12345678");
			System.out.println("mysql db 연결 성공");
			
			
			String selectSQL = "select * from emp_copy";
			Statement st = conn.createStatement();   // conn에 sql문 전송. 즉 DB로 전달.
			ResultSet rs = st.executeQuery(selectSQL);  // executeQuery메서드: select문에서 사용 .		

			// 조회 행개수를 세는 방법1
			int cnt = 0;
			// next사용 이전: 1행 이전에 위치. next메서드를 써야 1행으로 이동할 수 있다. 만약 결과가 하나면 next메서드 하나만 사용하면 된다.
			while(rs.next()) {
				int id = rs.getInt("employee_id");
				String name = rs.getString("first_name");
				double salary = rs.getDouble("salary");  //자바에서는 소수점 1번째 자리까지만 가져온다. 소수점을 지정하고 싶으면 sql문 자체에 넣어줘야.
				Date hire_date = rs.getDate("hire_date");  // sql패키지의 Date타입 import
				System.out.println(id + "\t" + name + "\t"+ salary + "\t" + hire_date);
				cnt += 1;
			}
			
			System.out.println("조회완료 : 총 "+ cnt + "명 조회");
			
			
			// 조회 행개수를 세는 또 다른 방법2
			// 페이지마다 n행씩 나눠서 보여주고 싶을 때. 몇 페이지까지만 보여줄지 사용자가 선택할 때는, 데이터 개수만 세면 되니까 이 방법 사용.
			// select문에서 where로 조건을 준 상황에서 총 행개수를 알고 싶을 때.
			ResultSet rs2 = st.executeQuery("select count(*) from emp_copy"); // executeQuery는 무조건 resultSet타입으로 전달을 받는다. (int 불가)
			int count = 0;
			while(rs2.next()) {
				count = rs2.getInt("count(*)");   // count(*)열을 컬럼명으로 가져온다.
			}
			System.out.println("조회완료2 : 총 "+ count + "명 조회");  // 위와 같은 결과 출력.

			
		
			rs.close();
			
			st.close();
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
