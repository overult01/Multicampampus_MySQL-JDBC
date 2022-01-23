package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

// jdbc실습 

/*  employees 테이블에서 6월 입사자의 사번, 이름, 급여, 입사일을 조회하여
 * Employee 객체로 생성한 후에 ArrayList로 저장하고 출력하는 자바 프로그램을 구현하시오. */

public class EmpDeptTest {

	public static void main(String[] args) {
		EmpDeptTest t = new EmpDeptTest();
		ArrayList<Employee> list = t.selectEmp("06");
		for(Employee e : list) {
			System.out.println(e.toString());
		}
	}//main
	

	ArrayList<Employee> selectEmp(String month) {
		//Employee들을 담을 배열 
		ArrayList<Employee> list = new ArrayList<Employee>();
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			//DB연결 
			// DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/접속할 DB", "아이디", "비밀번호");		
			Connection conn = 
					DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "12345678");
					System.out.println("==DB연결성공==");
			/*
			// SQL문 
			String selectSQL = 
					"select employee_id, first_name, salary,"
					+ " date_format(hire_date, '%Y년도 %m월 %d일') as hire"
					+ " from employees where hire_date like '_____" + month + "%' "; 
		
			// DB에 SQL문 보내기 
			Statement st = conn.createStatement();
		
			// SQL문 실행명령 
			ResultSet rs = st.executeQuery(selectSQL);
			*/
					
			// preparedStatement 사용하기: 같은 SQL을 반복사용할 시 속도향상
			String selectSQL = 
				"select employee_id, first_name, salary,"
				+ " date_format(hire_date, '%Y년도 %m월 %d일') as hire"
				+ " from employees where substr(hire_date, 6, 2) = ? "; 
			
			PreparedStatement pt = conn.prepareStatement(selectSQL);
			pt.setString(1, month);  // 1번 ? 자리에 month를 넣는다. 
			ResultSet rs = pt.executeQuery();
			
			// 1개 행마다 읽어오기
			while(rs.next()) {
				int id = rs.getInt("employee_id");
				String name = rs.getString("first_name");
				double salary = rs.getDouble("salary"); 
				String hire_date = rs.getString("hire"); 
				
				// while문이 끝나면 4개 변수에 담긴 값들이 없기 때문에 while문 외부의 배열인 list에 담는다. 
				Employee emp = new Employee(id, name, salary, hire_date);
				list.add(emp);
			}
			rs.close();			
			pt.close();
			conn.close(); // 반드시 이 메서드가 끝나기 전에 close하기
			System.out.println("==mysql 연결해제 성공==");
			// 다른 메서드에서 호출해도 결과를 확인할 수 있다. 
			return list;

		} 
		
		catch (Exception e) {
			e.printStackTrace();
			return list; // 실패시 빈 배열 반환
			
		}
	}
	
}//EmpDeptTest end

class Employee{
	
	private int employee_id;
	private String first_name;
	private double salary;
	private String hire_date; 
	

//	String d = rs.getString("hire-date");   // sql의 날짜 데이터도 String 타입으로 받을 수 있다.
	
	//생성자 추가(초기화)
	public Employee(int employee_id, String first_name, double salary, String hire_date) {
	super();
	this.employee_id = employee_id;
	this.first_name = first_name;
	this.salary = salary;
	this.hire_date = hire_date;
}
	
	public String toString() { 
		return employee_id + "\t" + first_name + "\t" + salary + "\t" + hire_date;
	}
}
