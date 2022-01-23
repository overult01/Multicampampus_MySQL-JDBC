package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dto.Student2DTO;
// 메인에서 DAO 호출 -> DAO에서 DB접근해서 데이터 가져옴 -> DTO에서 데이터 받아서 저장하기 위한 테이블만든다. (현재는 생략: -> DAO에서 전달받은 DTO로 DB로 저장)
public class Student2DAO {
	// students2 테이블의 CRUD하나씩 구현

	
	// insert
	Connection conn = null;  // finally에서 close하기 위해 try문 바깥에 선언. 
	PreparedStatement pt = null;
	
	public int insertStudent2(Student2DTO dto) {

		
		int rows = 0;
		
		try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "12345678");

		//명령행 매개변수 5개 입력 - 이자바 java2@Db.com 01022246788 법학 4.5
		String insertSQL = "insert into students2 values(null, ?, ?, ?, ?, default, ?)";
		
		 pt = conn.prepareStatement(insertSQL);// db전송 구문분석 컴파일-저장
		 //sql 입력파라미터값 설정
		 pt.setString(1, dto.getName());   // DTO객체의 name변수 가져와
		 pt.setString(2, dto.getEmail());   // DTO객체의 name변수 가져와
		 pt.setString(3, dto.getPhone());   // DTO객체의 name변수 가져와
		 pt.setString(4, dto.getMajor());
		 pt.setDouble(5, dto.getScore());
		 
		 rows = pt.executeUpdate();//실행결과리턴
		
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {  // DB는 무조건 연결 해제해야 한다.
			try {

				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			} 	
		}
		
		return rows;
	}
	
	
	// select	
	// student2 테이블의 모든 데이터를 배열 타입으로 가져오기. 
	public Student2DTO[] selectStudent2() {
		// 데이터 저장
		List<Student2DTO> list = new ArrayList<Student2DTO>(); // 리스트가 배열보다 낫다. 
		
		try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "12345678");

		//명령행 매개변수 5개 입력 - 이자바 java2@Db.com 01022246788 법학 4.5
		String selectSQL = "select id, name, major from students2";
		
		pt = conn.prepareStatement(selectSQL);
		ResultSet rs = pt.executeQuery();//실행결과리턴
		
		int index = 0;
		while(rs.next()) {
			Student2DTO dto = new Student2DTO(rs.getInt("id"), rs.getString("name"), rs.getString("major"));
			list.add(dto);
			}
		}
		
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {  // DB는 무조건 연결 해제해야 한다.
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			} 	
		
		}
		// list는 arrayList -> 배열로 바꾸기 
		
		// to Array메서드		
		Student2DTO[] arr = new Student2DTO[list.size()]; 
		arr = list.toArray(arr);

		return arr;		
	}
	
	
	// update 
	public void updateStudent2(String exist, String renew) {

		try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "12345678");

		// main에서 받은 2개값 넣기.
		/* String updateSQL = "update students2 set major = ? where major like ? ";
		
		pt = conn.prepareStatement(updateSQL);
		pt.setString(1, exist);
		pt.setString(2, "%"+renew+"%");

		pt.executeUpdate();  // 리턴값 없어서 
		*/
		
		// update예제 2
		 String updateSQL =
				 "update students2 set major = insert(major, instr(major, ?), char_length(?), ?)"
				 + " where major like ?";
		pt = conn.prepareStatement(updateSQL);

		pt.setString(1, exist);
		pt.setString(2, exist);
		pt.setString(3, renew);
		pt.setString(4, "%"+exist+"%");

		pt.executeUpdate();
		pt.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {  // DB는 무조건 연결 해제해야 한다.
			try {				
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			} 	
		}
		
	}


	public void deleteStudents2(int id) {

		try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "12345678");

		String deleteSQL = "delete from students2 where id = ?";
		pt = conn.prepareStatement(deleteSQL);

		pt.setInt(1, id);

		pt.executeUpdate();
		pt.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {  // DB는 무조건 연결 해제해야 한다.
			try {				
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			} 	
		}
	}
}
