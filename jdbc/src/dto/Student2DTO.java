package dto;
// dto: 직접 DB와 연결하는 유일한 클래스 
public class Student2DTO {


	
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
	
	
	// 변수는 보통 디폴트 혹은 Private을 붙인다. public은 안붙인다. 디폴트도 다른 패키지에서 사용할 수 있게 getter. setter 붙인다.
	private int id;  
	private String name;
	private String email;
	private String phone;
	private String major;
	private String regdate;
	private double score;

	
	
	// getter, setter
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
		return id +"\t" + name +"\t" + major;
	}

	
	
}
