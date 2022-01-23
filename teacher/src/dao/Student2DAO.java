package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import dto.Student2DTO;

public class Student2DAO {
//sTUDENTS2 테이블 CRUD기능 메소드 구현
	public int insertStudent2(Student2DTO dto){
		Connection conn = null;
		int rows = 0;
		try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "emp");

		String insertSQL = "insert into students2 values(null, ?, ?, ?, ?, default, ?)";
		
		/* update 테이블명 set 변경컬럼명=? where 컬럼명 = ? limit ? */
		/* delete from 테이블명 where 컬럼명 > ? and 컬럼명 < ?*/
		
		PreparedStatement pt = conn.prepareStatement(insertSQL);// db전송 구문분석 컴파일-저장
		 //sql 입력파라미터값 설정
		 pt.setString(1, dto.getName());
		 pt.setString(2, dto.getEmail());
		 pt.setString(3, dto.getPhone());
		 pt.setString(4, dto.getMajor());
		 pt.setDouble(5, dto.getScore());
		 
		 rows = pt.executeUpdate();//실행결과리턴
		 System.out.println(rows + " 개의 행 삽입 완료");
		 // 예외발생-중단되고 catch이동
 		conn.close();// db연결해제(파일;close, 소켓통신:close)
		}
		catch(ClassNotFoundException e) {
			System.out.println("mysql driver 미설치 또는 드라이버이름 오류");
		}
		catch(SQLException e) {
			System.out.println("db접속오류이거나 sql문장오류");
			e.printStackTrace();
		}
		finally {
			try {
			conn.close() ;
			}catch(SQLException e) { }
		}
		
		return rows;
	}//insertStudent2 method
	
	public Student2DTO[] selectStudent2(){
		//STUDENTS2 테이블의 모든 데이터 조회 구현
		Connection conn = null;

		Student2DTO[] ar = new Student2DTO[10];// INSERT / DELETE 레코드수 변경
		try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "emp");

		String selectSQL = "select id, name, major from students2";
		
		PreparedStatement pt = conn.prepareStatement(selectSQL);// db전송 구문분석 컴파일-저장
		 
		 ResultSet rs = pt.executeQuery();//실행결과리턴
		 int index = 0;
		 while(rs.next()) {
			Student2DTO dto = new Student2DTO(rs.getInt("id"), rs.getString("name"), rs.getString("major"));
			/* Student2DTO dto = new Student2DTO();->기본생성자 추가되었다면
			 dto.setId(rs.getInt("id"));
			 dto.setName(rs.getString("name"));
			 dto.setMajor(rs.getString("major"));*/
			ar[index++] = dto;
		 }
		 
		 rs.close();
		 pt.close();
		 // 예외발생-중단되고 catch이동
 		conn.close();// db연결해제(파일;close, 소켓통신:close)
		}
		catch(ClassNotFoundException e) {
			System.out.println("mysql driver 미설치 또는 드라이버이름 오류");
		}
		catch(SQLException e) {
			System.out.println("db접속오류이거나 sql문장오류");
			e.printStackTrace();
		}
		finally {
			try {
			conn.close() ;
			}catch(SQLException e) { }
		}
		
		return ar;
	}//selectStudent2
	
	public void updateStudent2(String old, String new_word){
		Connection conn = null;
		
		try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "emp");

		/*String updateSQL = "update students2 set major =? where major like ?  ";
		
		PreparedStatement pt = conn.prepareStatement(updateSQL);// db전송 구문분석 컴파일-저장
		 //sql 입력파라미터값 설정
		 pt.setString(1, new_word);
		 pt.setString(2, "%" + old + "%");
		 */
		
		 String updateSQL =
				 "update students2 set major = insert(major, instr(major, ?), char_length(?), ?)"
				 + " where major like ?";
		 
		 PreparedStatement pt = conn.prepareStatement(updateSQL);
		 
		 pt.setString(1, old );
		 pt.setString(2, old );
		 pt.setString(3, new_word);
		 pt.setString(4, "%" + old + "%");
		 
		 pt.executeUpdate();//실행결과리턴
		 // 예외발생-중단되고 catch이동
		 pt.close();
 		conn.close();// db연결해제(파일;close, 소켓통신:close)
		}
		catch(ClassNotFoundException e) {
			System.out.println("mysql driver 미설치 또는 드라이버이름 오류");
		}
		catch(SQLException e) {
			System.out.println("db접속오류이거나 sql문장오류");
			e.printStackTrace();
		}
		finally {
			try {
			//pt.close();
			conn.close() ;
			}catch(SQLException e) { }
		}
	}//updateStudent2 method

	public void deleteStudent2(int id){
		Connection conn = null;
		
		try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "emp");

		 String deleteSQL = "delete from students2 where id=?";
		 PreparedStatement pt = conn.prepareStatement(deleteSQL);
		 pt.setInt(1, id);
		 pt.executeUpdate();//실행결과리턴
		 // 예외발생-중단되고 catch이동
		 pt.close();
 		conn.close();// db연결해제(파일;close, 소켓통신:close)
		}
		catch(ClassNotFoundException e) {
			System.out.println("mysql driver 미설치 또는 드라이버이름 오류");
		}
		catch(SQLException e) {
			System.out.println("db접속오류이거나 sql문장오류");
			e.printStackTrace();
		}
		finally {
			try {
			//pt.close();
			conn.close() ;
			}catch(SQLException e) { }
		}
	}//deleteStudent2 method
}
