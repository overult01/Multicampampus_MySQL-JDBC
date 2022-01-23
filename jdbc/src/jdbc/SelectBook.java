package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class SelectBook {

	public static void main(String[] args) {
		try {
        	// JDBC 드라이버 로드
			Class.forName("com.mysql.cj.jdbc.Driver");
            
			// DB 연결
			Connection conn =
			DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "12345678");
			System.out.println("mysql db 연결 성공");
			
			// SQL문
			String selectSQL = "select * from book";
            
            // conn에 SQL문 전송. 즉 DB로 전달.
			Statement statement = conn.createStatement();
            
            // 자바에서는 SQL의 조회결과를 ResultSet형태로 반환한다.
            // executeQuery메서드: select문을 실행하는 메서드.
			ResultSet resultset = statement.executeQuery(selectSQL);  		

			int cnt = 0;
			// next메서드: 조회된 결과(ResultSet)에서 행을 이동하는 메서드이다.
			while(resultset.next()) {
            	// getxx메서드: 조회된 결과(ResultSet)에서 컬럼의 값을 가져오는 메서드. get타입("컬럼명")
				String no = resultset.getString("bookNo");
				String title = resultset.getString("bookTitle");
				String author = resultset.getString("bookAuthor");
				String year = resultset.getString("bookYear");
				String price = resultset.getString("bookPrice");
				String publisher = resultset.getString("bookPublisher");
				System.out.println(no + "\t" + title + "\t"+ author + "\t" + year + "\t" + price + "\t" + publisher);
				cnt += 1;
			}
			
			resultset.close();			
			statement.close();
            // DB사용후에는 반드시 연결을 끊어줘야 한다. 그렇지 않으면 다른 쪽에서 연결불가될 수 있다.
			conn.close();
			System.out.println("mysql 연결해제 성공");
		}
        
        // 예외처리
		catch(ClassNotFoundException error) {
			System.out.println("mysql driver 미설치 또는 드라이버 이름 오류");
		}
		catch(SQLException error) {
			error.printStackTrace();  // sql문법오류 일수도, DB연결 오류일수도 있다. 따라서 원인파악 필요.
		}

	}
}