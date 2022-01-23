

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class EmpDeptTest {

	public static void main(String[] args) {
		EmpDeptTest t = new EmpDeptTest();
		ArrayList<Employee> list = t.selectEmp("12");
		for(Employee e : list) {
			System.out.println(e);
		}
	}//main
	
	ArrayList<Employee> selectEmp(String month){
		ArrayList<Employee> list = new ArrayList<Employee>();
		try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/employeesdb", "emp", "emp");
		String selectSQL = "select employee_id, first_name, salary, date_format(hire_date, '%Y년도%m월%d일') as hire_date from  employees "
				+ " where hire_date like '_____" + month + "%'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(selectSQL);
		
		while(rs.next()) {
			int id = rs.getInt("employee_id");
			String name = rs.getString("first_name");
			double salary = rs.getDouble("salary"); 
			String hire_date = rs.getString("hire_date");
			//System.out.println(id + "\t" + name + "\t" + salary + "\t" + hire_date);
			Employee e = new Employee(id, name, salary, hire_date);
			list.add(e);
			
		}
		rs.close();
		st.close();
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
		return list;
	}

}//EmpDeptTest end

class Employee{
	int employee_id;
	String first_name;
	double salary;
	String hire_date;
	
	public Employee(int employee_id, String first_name, double salary, String hire_date) {
		super();
		this.employee_id = employee_id;
		this.first_name = first_name;
		this.salary = salary;
		this.hire_date = hire_date;
	}

	@Override
	public String toString() {
		return "Employee [employee_id=" + employee_id + ", first_name=" + first_name + ", salary=" + salary
				+ ", hire_date=" + hire_date + "]";
	} 
	
}
