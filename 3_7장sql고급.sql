# 7장

# mysql 데이터 형식
/*
정수 - int(4byte), tinyint(1byte), smallint(2byte), bigint(8byte)
실수 - float(4byte), double(8byte), decimal(전체자릿수, 표현할 자릿수) <- 소수점 몇 자리까지 표현할지 지정   
문자열 - ' ', " " 안에 표현.(둘 다 무관).  char(글쟈수. 바이트 아님) , varchar(글자수. 바이트 아님) 
char(10) : 고정 10자리. "이학생" 저장으로 3자리 써도, 7자리 비어있다. (메모리 낭비)
varchar(10) : 가변길이. "이학생" 저장하면 3자리 사용. null 값 많으면 varchar사용 권장. 
text : 뒤에 문자크기 지정 x. 파일 내용 혹은 게시물 내용 저장 용도로 긴 글자. 대용량 문자열 저장.(저장, 조회시간이 오래 소요)
--> 사실 파일 저장할 때는 db에 파일이름, 경로를 저장하고 실제 파일 내용은 서버컴퓨터에 파일을 저장한다. (따라서 text형태는 잘 사용x)
날짜: date
시간: time
날짜와 시간 함께: datetime(해당지역정보만 나옴), timestamp (해당 지역 정보 + 전세계 표준 시간 변환)
*/


desc employees; # desc: describe의 줄임말
# 	  datetime	decimal(8,2)  decimal(8,2)  smallint(2자리수의 저장이면 smallint)
select hire_date, salary, commission_pct, department_id from employees;  
# datetime(4자리연도 - 2자리 월 - 2자리 일)
# decimal(8,2) -> 정수 6자리, 소수 2자리 표현


# 변수 사용: 데이터값 저장 용도(workbench종료시까지) 
set @a = 100;

select @a + 100;
set @b = "사원정보===>";
select @b, employee_id, first_name from emp_copy;

set @c = @a +50;
set @d = 10;

# prerpare 문 정의 : 같은 sql문을 계속 사용해야 할 때. 
# sql 정의 
prepare mytest from
'select * from emp_copy where employee_id > ? limit ?';

# 실행 ? 값 매핑
execute mytest using @c, @d;

# 함수
#데이터 타입 변환 함수(모두 다 반올림): cast, convert, format(대상, 소수점 자릿수)
# 실수를 정수로 변환
select avg(salary) as 실수평균, 
cast(avg(salary) as signed integer) as 정수평균1, 
convert(avg(salary), signed integer) as 정수평균2,
format(avg(salary),0 ) as 정수평균3
from emp_copy;

set @avg = 8818.5678;
select @avg as 실수평균, 
cast(@avg as signed integer) as 정수평균1,  # '8819'
convert(@avg, signed integer) as 정수평균2, # '8819'
format(@avg,2 ) as 정수평균3  # '8,819'
/* from emp_copy */;  


# cast 함수 이용하지 않고 자동형변환 
select @avg + 1;
select '8818.5678' + 1;  # 문자열(숫자 자동변경) + 숫자.  자바와 달리 문자열이 숫자로.
select '100' + '200';  # 문자열(숫자 자동변경) + 문자열(숫자 자동변경). sql에서 + 는 무조건 산술연산.
select concat('100', '200');  # 문자열결합 

# 일반 문자가 나오기 직전까지만 숫자 자동 변경. 일반 문자로 시작하면 숫자 0 으로 자동 변경.
select '100가' + '200나'; # 100 + 200 # 문자열(숫자 자동변경) + 문자열(숫자 자동변경)
select '가100' + '나200'; # 0 + 0 # 문자열(숫자 자동변경) + 문자열(숫자 자동변경)
select '가100' + '200나'; # 0 + 200  # 문자열(숫자 자동변경) + 문자열(숫자 자동변경)

select 0 = 'mysql100';  # = 는 동등비교이다. 1은 같다라는 뜻.(mysql엔 boolean타입이 없다. F: 0, T: 1)



# 제어흐름 함수: if, ifnull, nullif, case

# 커미션 받는 직원(급여의 20%) / 못받는 직원(null)
# if(논리값 결과 수식, 참 결과, 거짓 결과) 
select commission_pct, if(commission_pct = null, '없음', '있음') from employees;  # 모두 다 있음 이 나온다.(잘못된 결과) # 이유는 아래서.

# is null : null 인지 확인 할 때.  
# select, update, delete + where 컬럼명 is null로 써야.
select commission_pct, if(commission_pct is null, '없음', '있음') from employees;  # 모두 다 있음 이 나온다.
select commission_pct, if(commission_pct is not null, '있음', '없음') from employees;  # 모두 다 있음 이 나온다.

# is not null
# employees 테이블에서 급여, 커미션 조회. 단, 커미션을 못받는 직원은 제외하고 조회.
select salary, commission_pct 
from employees
where commission_pct is not null;

select found_rows(); # 바로 직전의 select문 조회 결과의 수.

# is null
select salary, commission_pct 
from employees
where commission_pct is null;

select found_rows(); # 바로 직전의 select문 조회 결과의 수.


# ifnull 함수	
# ifnull(컬럼명, '다른 값') : 만약에 null 이면 '다른 값'으로 바꿔서 보여줘라.	
select commission_pct, ifnull(commission_pct, '없음') from employees;

# null 은 연산해도 null 이다.
# 급여, 커미션 컬럼을 가져와서 급여 * 커미션 보너스 계산
select salary as 급여, commission_pct as 커미션, salary * ifnull(commission_pct, 0) as 올해의보너스
from employees;

# employees 테이블에서 사번, 부서코드 조회하되 부서코드가 null이면 신입사원 조회.
select employee_id, ifnull(department_id, '신입사원') as 부서코드 
from employees;   # 이중에 부서가 null(배정이 안된) 사람이 있다.

select employee_id, if(department_id is null, '신입사원', department_id) as 부서코드 
from employees;   # 위와 동일 

# nullif(2개의 수식의 결과가 같으면 null)
select nullif(100, 200);  # 100. 같지 않으면 첫 번째 값이 반환. 
select nullif(100, 100);  # null 


# case 구문 : when .. then ~
/*
case employee_id
when 1 then '1이다'
when 2 then '2이다'
when 3 then '3이다'
else '1, 2, 3 모두 아니다'
end as 분석 
 */
 
 /*
 employees 테이블에서 급여를 20000이상 받는 직원은 '임원이다'
 15000 이상 20000 미만 받는 직원은 '부장이다'
 10000 이상 15000 미만 받는 직원은 '과장이다'
 5000 이상 10000 미만 받는 직원은 '대리이다'
 나머지는 '사원이다'
 => '직급' 제목 출력
 */
 
 select salary, truncate(salary / 5000, 0 ) from employees;
 
select salary as 급여, 
case truncate(salary / 5000, 0 )
when 4 then '임원이다'
when 3 then '부장이다'
when 2 then '과장이다'
when 1 then '대리이다'
else  '사원이다'
end as 직급 from employees;


select salary as 급여, 
case 	when salary between 20000 and 25000  then "임원이다"
            when salary between 15000 and 20000  then "부장이다"
            when salary between 10000 and 15000  then "과장이다"
            when salary between 5000 and 10000  then "대리이다" 
            else '사원이다'
end  as 직급 from employees;
 
 
 select  
case 7
when 1 then '월'
when 2 then '화'
when 3 then '수'
when 4 then '목'
else  '금토일'
end as 요일;


# 문자형(char, varchar, text)에 적용할 수 있는 함수
select ascii('a'), char(97);

# char_length : 글자수를 세는 함수 
set @teststr = "가나다";
select length(@teststr) as 바이트수,    # 9. mysql은 유니코드 사용(한글: 1글자 당 3바이트. 영문, 숫자: 1바이트)
char_length(@teststr) as 글자수,  # 3
bit_length(@teststr) as 비트수;  # 72

# employees 테이블에서 first_name이 3글자로 이뤄진 사원 조회
select first_name, char_length(first_name) from employees
where char_length(first_name) = 3;

# 두 개의 문자열을 결합( sql에서 + 는 숫자간 연산자로만 사용된다)
select concat('100', '200');  # 100200
select concat_ws('-','100', '200');  # 결합할 때 구분자를 줘라 . # 100-200

# employees 테이블에서 조회
select concat_ws('-', employee_id, first_name, hire_date, salary) as 사원정보
from employees;


# 문자찾기
# elt(숫자, 목록) : 인덱스에 어떤 문자가 있는지 확인.
select elt(2, "일", '둘', '셋');  # 둘
select field (5, "일", '둘', '셋');  # 인덱스(1부터 시작함에 유의) 숫자 리턴 

# find_in_set : 문자열을 ,기준으로 분리되었다고 생각하고, 매개변수 1 찾아서 인덱스 리턴
select find_in_set("수","월요일,화,수,목,금");

# instr : ,를 문자열로 인식. 
select instr("월요일,화,수,목금", "수"); #7 

# locate: 위치찾기
select locate("수", "월화수목금요일");  # 인덱스 리턴.  # 3
# substring(문자열, 시작위치, 가져올 개수): 시작위치부터 개수만큼 문자열 리턴 
select substring('이것이mysql이다', 4, 5);  #mysql

select substring('이것이mysql이다', 4);  # 시작위치부터 끝까지 모든 문자열 리턴.  #mysql이다

# 2002년도 입사자 찾기: datetime 양식 '4자리 연도 - 2자리 월 - 2자리 일 - 2자리 시간 : 2자리 분 : 2자리 초'
select hire_date from employees
where hire_date >= "2002-01-01 00:00:00"
and hire_date < "2003-01-01 00:00:00";

select hire_date from employees
where hire_date like '2002-%';

#instr 함수. 문자함수(날짜 자동 문자 변환) -> 위치반환
select hire_date, instr(hire_date, '2002')
from employees
where instr(hire_date, '2002'); 

# substring 함수로 조회
select hire_date
from employees
where substr(hire_date, 1, 4) = 2002;  # 첫 번째 부터 4개를 가져와 


# 6월 입사자 조회
# instr: 인덱스 반환
select hire_date, instr(hire_date, '06')
from employees
where instr(substr(hire_date,6), '06') = 1;  # 원래: 06년도 06월 입사자는 빠졌다. (instr로 3이 반환되어 걸러졌기 때문)

select found_rows();

# substr: 문자열 반환 
select hire_date, substr(hire_date, 6, 2)
from employees
where substr(hire_date, 6, 2)='06';

select found_rows();

# like
select hire_date
from employees
where hire_date like '_____06%';

select found_rows();
