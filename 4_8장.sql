# 8장_테이블과 뷰
/*
DML: select(조인, 서브쿼리), insert, update, delete
DDL: 테이블 생성 / 수정 / 삭제 (2,3,4장)

*/


/*
create datebase XXX;
create user XXX;  --> 루트 계정만 가능
create table;
*/

# 현재 사용자 확인
select current_user;

# 사용자 생성 (루트 계정에서만 가능)
create user testuser identified by '12345678';
# testuser에게 모든 권한 부여
grant all on *.* to testuser;

# mysql을 터미널에서 접속할 때
# mysql - u testuser -p


use employeesdb;
/*
create table 테이블명 (
	컬럼명1 타입 제약조건,
	컬럼명2 타입 제약조건,
    ... ,
    제약조건 추가
)
*/

create table testtbl(num int);  # testtbl이라는 테이블을 만들고 num이라는 컬럼을 만들었고, 그 타입은 int이다.
select * from testtbl;

drop table testtbl2;

create table testtbl2(
	numcol1 int,
    numcol2 decimal(8, 2),  # 전체 8자리 중에 소수점 2번째 자리까지 입력. 정수 입력해도 0.xx 형식으로 나온다.
    strcol1 char(10),
    strcol2 varchar(10),
    datecol1 date,
    timecol1 time,
    datecol2 datetime);

# 값넣기 
insert into testtbl2 values(1, 2, 'mysql', 'mysql', '2022-01-19', '12:34:56', '2022-01-19 12:34:56');

select * from testtbl2;

# 데이터 구조 확인
desc testtbl2;

# 다음 테이블의 내용을 복사하면서 테이블 생성 - 서브쿼리 사용
create table testtbl3 (select * from testtbl2);
desc testtbl3;

# 다음 테이블의 내용을 복사(이미 생성되어 있는 테이블에) - 서브쿼리 사용
insert into testtbl3 (select * from testtbl2);
desc testtbl3;

# 생성된 테이블에 1개 컬럼 추가
alter table testtbl2 add addcol char(5);
desc testtbl2;

# alter table rename column
# 존재하는 컬럼(이름) 수정
alter table testtbl2 rename column addcol to updatecol;
desc testtbl2;

# alter table modify column
# 존재하는 컬럼(타입) 수정
alter table testtbl2 modify column updatecol int;
desc testtbl2;

# alter table change column
# 존재하는 컬럼(이름, 타입) 한 번에 수정
# alter table testtbl2 change column 이전컬럼명 새로운컬렴명;
alter table testtbl2 change column updatecol changecol date;
desc testtbl2;

# 존재하는 컬럼 삭제
alter table testtbl2 drop column updatecol;
desc testtbl2;

# 테이블
# create table / alter table / drop table 

# 테이블 삭제 3가지
drop table testtbl2;  # 데이터 삭제 + 테이블 삭제
truncate table testtbl2;  # 데이터 삭제o, 테이블 삭제x
# delete from testtbl2 where 삭제할 조건식;  # 만족하는 조건만 삭제, 테이블 삭제x.



/*
데이터 현실세계 데이터 모음 = 데이터 모델링
제악조건 - constraint
학생의 학번은 중복x, not null 표현

<제약조건>
unique: 중복x
not null
primary key 제약조건 = unique(중복x) + not null
foreign key 제약조건: 다른 테이블에 존재하는 데이터만 참조
check 제약조건: '사용자 정의'  aa@bb

default 제약조건
auto increment
*/

use employeesdb;

drop table students;

# 제약조건 설정 테이블
create table students(
	id int primary key auto_increment, 
    name varchar(10) not null,
    email varchar(20) unique,
    phone varchar(11) check(phone like '010%'),   # check(사용자 지정 제약조건)
    regdate date default (current_date),  #default(기본값) #아무것도 입력안해도 값을 insert하는 그 날짜를 기본값으로 해줄게.
    nation char(2),
    constraint foreign key(nation) references countries(country_id)   # 국적은 countries 테이블에 존재하는 country_id로 제한 할 것.  # 원래 이렇게 맨 마지막에 foriegn key를 넣는 것.(중간에 문장이 있어도)
);


# drop table students;

desc students;  # desc명령으로 키 값 확인할 수도 있다. 이게 더 편리하다.
# show keys from students;

# 제약조건 효력 발생 -dml
insert into students values(null, '이학생', 'lee@a.com', '01012345678', default, 'uk');
select * from students;

# 입력 오류
# primary key에 위배
insert into students values(1, '이학생', 'lee@a.com', '01012345678', '컴공', default, 'uk');


/*
create table students(
 id int primary key auto_increment , 
 name varchar(10) not null,
 email varchar(20) unique, 
 phone varchar(11) check(phone like '010%'),
 major varchar(20),
 regdate date default (current_date),
 nation char(2) ,
 constraint foreign key(nation) references countries(country_id) 
 on delete cascade
 on update cascade
 );
*/

# on delete cascade : 부모테이블에서 값이 삭제된다면 자식도 같이 삭제
# on update cascade : 부모테이블에서 값이 삭제된다면 자식도 같이 수정


use employeesdb;
drop table emp_copy;
create table emp_copy(select employee_id, first_name, salary, hire_date from employees where employee_id = 0);
desc emp_copy;
select * from emp_copy;

# 테이블 생성 이후에 추가할 것은 모두 alter
alter table emp_copy add constraint primary key(employee_id) ;
alter table emp_copy modify column employee_id int auto_increment ;
desc emp_copy;

select * from emp_copy;


# update문
# update emp_copy set salary = salary*2
# where first_name = "이사원";

select * from emp_copy
where first_name ='이사원';





















