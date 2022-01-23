package dto;
//students2테이블 데이터표현용도
public class Student2DTO {
	int id;
	String name;
	String email;
	String phone;
	String major;
	String regdate;
	double score;
	//생성자 오버로딩
	public Student2DTO(String name, String email, String phone, String major, double score) {
		super();
		this.name = name;
		this.email = email;
		this.phone = phone;
		this.major = major;
		this.score = score;
	}
	
	
	public Student2DTO(int id, String name, String major) {
		super();
		this.id = id;
		this.name = name;
		this.major = major;
	}


	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getMajor() {
		return major;
	}
	public void setMajor(String major) {
		this.major = major;
	}
	public String getRegdate() {
		return regdate;
	}
	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}
	public double getScore() {
		return score;
	}
	public void setScore(double score) {
		this.score = score;
	}
	@Override
	public String toString() {
		return id+"-"+name+"-"+major;
	}
	
	
}
