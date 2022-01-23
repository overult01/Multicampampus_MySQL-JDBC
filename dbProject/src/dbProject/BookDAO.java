package dbProject;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {

	Connection conn = null;
	PreparedStatement pt = null;

	// book 테이블에 데이터 저장
	public void insertBook(BookDTO bookDTO) {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "12345678");
			
			String insertSQL = "insert into book values(?, ?, ?, ?, ?, ?)";
			
			pt = conn.prepareStatement(insertSQL);
			
			pt.setString(1, bookDTO.getBookNo());
			pt.setString(2, bookDTO.getBookTitle());
			pt.setString(3, bookDTO.getBookAuthor());
			pt.setInt(4, bookDTO.getBookYear());
			pt.setInt(5, bookDTO.getBookPrice());
			pt.setString(6, bookDTO.getBookPublisher());
			
			pt.executeUpdate();
			
			pt.close();
			conn.close();

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		finally {
			try {
			conn.close() ;
			}catch(SQLException e) { }
		}
	}
	
	// book 테이블에 있는 모든 데이터 출력
	public void selectBook() {
		List<BookDTO> books = new ArrayList<BookDTO>();
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "12345678");
			
			String selectSQL = "select * from book";
			
			pt = conn.prepareStatement(selectSQL);
			ResultSet rs = pt.executeQuery();
			
			while(rs.next()) {
				BookDTO dto = new BookDTO(rs.getString("bookNo"), rs.getString("bookTitle"), 
						rs.getString("bookAuthor"), rs.getInt("bookYear"), 
						rs.getInt("bookPrice"), rs.getString("bookPublisher"));
				
				books.add(dto);
			}

			for(BookDTO onebook : books) {
				System.out.println(onebook);
			}
			
			pt.close();
			conn.close();

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		finally {
			try {
			conn.close() ;
			}catch(SQLException e) { }
		}
		
	}
}
