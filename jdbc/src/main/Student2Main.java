package main;
//메인에서 DAO 호출 -> DAO에서 DB접근해서 데이터 가져옴 -> DTO에서 데이터 받아서 저장하기 위한 테이블만든다. (현재는 생략: -> DAO에서 전달받은 DTO로 DB로 저장)

import dao.Student2DAO;
import dto.Student2DTO;

public class Student2Main {

	public static void main(String[] args) {

		// 명령행 매개변수를 입력받을 수 있는 건 메인메서드를 가진 메인.
		// run configuration -> 박자바 park@c.com 01012345678 it공학 4.5 (id, regdate는 auto_default)
		
		// 1. DTO에 데이터들 입력.(데이터들이 DTO에만 있는 상태.)
		Student2DTO dto = new Student2DTO(args[0], args[1], args[2], args[3], Double.parseDouble(args[4]));
		
		// 2. DAO객체 생성
		Student2DAO dao = new Student2DAO();
		
		// insert
		// 3. 1번에서 DTO만 알고 있는 데이터들을 DAO로 넘겨주기 
//		int insertrows = dao.insertStudent2(dto);
//		System.out.println(insertrows + "개 행 삽입");
		
		// update 
//		major에 "it공학" 레코드의 Major를 아이티로 수정. 
//		dao.updateStudent2("it", "아이티"); // 리턴값 받지 않고 아래서 조회로 대신. 
		
		
		// delete
		dao.deleteStudents2(10);  // id 5번 학생을 삭제. 
		
		// select
		Student2DTO[] arr  = dao.selectStudent2();
		for(Student2DTO result : arr) {
			if(dto != null) {
				System.out.println(result.toString()); //id - name - major 출력
			}
		}

			
		
	}

}
