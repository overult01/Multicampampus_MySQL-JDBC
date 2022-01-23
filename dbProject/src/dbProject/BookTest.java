package dbProject;

public class BookTest {

	public static void main(String[] args) {

		BookDTO dto = new BookDTO(args[0] , args[1], args[2], 
				Integer.parseInt(args[3]) , Integer.parseInt(args[4]) , args[5]);
		
		BookDAO dao = new BookDAO();
		dao.insertBook(dto);   

		dao.selectBook();
	}

}
