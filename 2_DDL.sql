# DDL: Data Definifion language 

# 현재 접속 사용자 확인
select current_user;

select current_date();  # 현재 날짜 
select now();  # 현재 날짜 with 시간 

# db 지정
show databases;
use employeesdb;

# 테이블 확인: 자바프로그램(테이블 목록 확인할 때) + mysql 연동s
show databases;

# DML : select, insert, update, delete

# insert into 테이블명 values (값1, 값2, ..)
# insert into 테이블명(열이름) values (값1)
insert into jobs values(1, 2, 3, 4, 5);
insert into jobs values('IT_PROG', 'IT PROGRAMMER', 30000, 40000);
insert into jobs(JOB_ID) values('IT_PROG');  # jobs_id열에 특정 값 삽입 
insert into jobs values('IT_PROG', Null, 30000, Null);  # SQL은 값이없으면 문자, 숫자도 모두 Null (자바는 문자만 Null이었다)

# db 구조 확인 
describe employees;

# 실습
Drop Table emp_copy;

# Create table emp_copy (select 컬럼명 from 테이블명 where 조건식);
Create table emp_copy (select employee_id,first_name, salary, hire_date from employees);

# 1 이사원 15000 '2022-01-17'
describe emp_copy;
insert into emp_copy values(1, '이사원', 15000, '2022-01-17');
select * from emp_copy where employee_id = 1;

# 오늘 날짜를 가져오는 방법 
insert into emp_copy values(2, '김사원', 15000, current_date()); # current_date: 연-월-일 만(시간 제외)  
insert into emp_copy values(3, '최사원', 15000, now());  # now(): 연-월-일-시간  
insert into emp_copy values(4, '박사원', 15000, '2022-01-17');

describe emp_copy;
# insert into emp_copy(employee_id, salary) values(5, 10000);  실행불가. hire_date는 null이면 안된다. 
insert into emp_copy(employee_id, hire_date) values(5, current_date());  # first_name, salary는 null 가능 
insert into emp_copy values(6, null, null, current_date());  # first_name, salary는 null 가능 

select * from emp_copy where employee_id between 1 and 10;

# employee_id를 입력할 때마다 자동으로 1씩 증가하도록. 
Drop Table emp_copy;
# Create table emp_copy (select 컬럼명 from 테이블명 where 조건식);
Create table emp_copy (select employee_id,first_name, salary, hire_date from employees);

# auto_increment: 숫자이고 중복되지 않은 값이 필요할 때, 1씩 증가하여 자동 부여시켜줌. 
create table test(a int auto_increment primary key, b char(3));
insert into test values (null, 'aaa');
insert into test values (null, 'bbb');
insert into test values (null, 'ccc');
select * from test;

# 대량의 샘플 데이터 복사
# 다른 테이블을 복사하여 존재하는 테이블에 복사
# insert into emp_copy (select employee_id, ... where 등록일 오늘);


# 데이터 수정 : update (보통 where절로 조건을 주고 일부분만 변경한다.)
# update 테이블명 set 변경 컬럼명 = 변경값 where 변경할 레코드조건식 limit 몇 개;

# emp_copy 테이블에서 이름에 사원을 포함하는 직원의 급여를 10배 인상
# first_name 사원이 김사원 최사원 사원이 
describe emp_copy;
# set sql_safe_updates = 0;
select * from emp_copy where employee_id > 200;
# 3명만 salary 업데이트 
update emp_copy set salary = salary * 10 where employee_id > 200 limit 3;
select * from emp_copy where employee_id > 200;


# 데이터 삭제 : delete. 데이터 몇 개만 삭제. 테이블은 존재.  
# delete from 테이블명 where 삭제할 레코드 조건식 limit 몇 개;
delete from emp_copy where employee_id > 200 limit 3;
select * from emp_copy where employee_id > 200;
desc emp_copy;

# drop table 테이블이름: 모든 레코드 + 테이블 구조 삭제(복구 불가능)
# truncate table 테이블이름: 모든 레코드 삭제.(복구 불가능) 테이블 구조는 남겨둔다. 

# with CTE절 -> 이후 view로 발전함  
# with 테이블명(컬럼명1, 컬럼명2, 컬럼명3) as 로 별칭주기 
# employees 테이블의 부서별, 직종별 급여 평균을 구하자
with a(b, c, d)   
as
(select department_id, job_id, avg(salary)
from employees
where salary >= 5000
group by department_id, job_id
having avg(salary) >= 4000)
select b, c, d from a order by d desc;

# 바로 직전에 수행된 select문의 레코드 개수를 리턴
select found_rows();

# update, delete -- primary key 조건 수정/ 삭제(테이블 중복 x, not null) 
# update, delete -- primary key 조건 수정/ 삭제 못하게 막아놓은 상태 
# 방법1. update.. limit 개수(숫자) ;
# 방법2. safe mode 해제 
