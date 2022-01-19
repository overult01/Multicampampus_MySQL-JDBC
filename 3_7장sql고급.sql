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

# insert: 지정된 위치에 지정한 개수만큼 문자열 삭제 후 채워넣기 
select insert('abcde', 2, 3, 'xxxxxxx');   # 'axxxxxxxe'
select insert('abcde', 2, 5, '****');
# repeat: 문자열을 지정한 개수만큼 반복하기 
select repeat("a", 5);  # 'aaaaa'
select repeat("a", char_length('agdgeg'));  # 'aaaaaa'

# pw 변수의 모든 값을 '*' 암호화하여 출력할 것
set @pw = 11551;

select insert(@pw, 2, char_length(@pw)-1, repeat("*", char_length(@pw)-1));

# 1**** 로 출력하기 
select insert(@pw, 2, char_length(@pw)-1, repeat("*", char_length(@pw)-1));

# 모두 ***** 로 출력하기 
select insert(@pw, 1, char_length(@pw), repeat("*", char_length(@pw)));

# left right: 일부 개수만 가져오기
select left('가나다라', 3), right('가나다라',1);

# upper, lower: 대, 소문자 변경
select upper('abcDE'), lower('abcDE');  # 'ABCDE', 'abcde'

# lpad, rpad: 문자열 왼, 오른쪽에 지정한 개수만큼 지정 문자 붙이기(insert와는 달리 원래 있던 문자열이 없어지지 않음)
select lpad('abc', 10, '#'), rpad('abc', 10, '#'), insert('abc', 1, 2, '#');

use employees;
select salary, lpad(salary, 5, " ") from employees;

# ltrim, rtrim : 왼, 오른쪽의 공백을 제거하라
set @pw = "  이것이 mysql이다     ";
select char_length(@pw), char_length(ltrim(@pw)), char_length(rtrim(@pw));  # '18', '16', '13'

# trim : 왼쪽, 오른쪽, 양쪽 공백 제거
set @pw = "ㅋㅋㅋㅋ웃겨요ㅋㅋㅋㅋ";
# 앞쪽에 있는 문자 없애기: trim(leading 문자열)
select trim(leading 'ㅋ' from @pw); # 웃겨요ㅋㅋㅋㅋ

# 뒤에 있는 문자 없애기: trim(trailing 문자열)
select trim(trailing 'ㅋ' from @pw); # ㅋㅋㅋㅋ웃겨요

# 양쪽에 있는 문자 없애기: trim(both 문자열)
select trim(both 'ㅋ' from @pw); # 웃겨요


# 숫자함수
# abs: 절대값

# mod(수, 나눌 값) 해서 나머지 값 구하기 
# 사번이 3의 배수인 사번 이름 조회 
select employee_id, first_name
from employees
where mod(emloyee_id, 3) = 0;

# round: 반올림, truncate: 버림
select avg(salary) from employees;
select avg(salary),
cast(avg(salary) as signed integer),  # cast는 무조건 정수로만 표현가능하다. # 6461
convert(avg(salary), signed integer),  # 정수 
format(avg(salary), 0),   # 정수 
round(avg(salary), -2),  # 반올림  # 6500
truncate(avg(salary), -2)  # 내림  # 6400
from employees;


# 시스템정보 
select current_user(), database(), version();

# 날짜와 시간
select current_date(), current_time(), curdate(), curtime(), current_timestamp(), now(), sysdate();

# yyyy-mm-dd hh:mm:ss
select cast('2022-01-18' as date);
select cast('2022-01-18' as datetime);
select cast('2022-01-18' as time);  # 시간형식(hh:mm:ss)과 달라서 잘못된 값이 나옴
select cast('2022-01-18 12:34:56' as time);  # 시간형식(hh:mm:ss)
select cast('12:34:56' as time);  # 시간형식(hh:mm:ss)
select cast('20220118123456' as datetime); # 자릿수가 맞으면 구분자가 없어도 연도월일 시분초를 딱 맞춰서 자른다.
select cast('2022/01%18' as datetime); # 자릿수가 맞으면 구분자가 없어도 연도월일 시분초를 딱 맞춰서 자른다.
select cast('2022a01b18' as datetime); # 일반데이터를 구분자 대신 넣으면 null이 나온다. 데이터 형식은 yyyy-mm-dd 8자리데이터. 일반문자는 구분자로 여기지 않는다. (반면, 특수문자는 구분자로 여긴다.)


insert into emp_copy value(500, '이름', 45000, cast('20220118' as date));

# adddate(날짜, 차이값): 미래날짜 계산, subdate(날짜, 차이값): 이전 날짜 계산 
select current_date as 오늘, 
adddate(current_date, interval 1 day) as 내일,
subdate(current_date, interval 1 day) as 어제;

select current_date as 오늘, 
adddate(current_date, interval 1 month) as 다음달,
subdate(current_date, interval 1 month) as 이전달;

select current_date as 오늘, 
adddate(current_date, interval 1 year) as 내년,
subdate(current_date, interval 1 year) as 작년;

# addtime, subtime
select addtime(now(), '2:10:10');

# 날짜 시간에서 원하는 부분만 추출하는 것.
select year(now()), month(now()), day(now());
select date(now()), time(now());

# datediff: 오늘부터 며칠이 경과되었는지
# 참고) xxxdiff: 차이 구하는 함수 
select datediff(current_date, '2002-01-25 00:11:23');  # 7298  # 숫자 형태 리턴
select datediff(current_date, '2002-01-25');  # 7298
select subdate(current_date, interval 30 day);  # '2021-12-19'  # 날짜 형태 리턴 

# 입사한지 며칠되었는지 경과일수 조회
select current_date, hire_date, datediff(current_date, hire_date) as 경과일수
from employees;

# 입사한지 며칠되었는지 경과주수, 경과년수 조회(정수로만 조회. 소수점 이하는 버림)
select current_date, hire_date, 
truncate(datediff(current_date, hire_date)/7, 0) as 경과주수, 
truncate(datediff(current_date, hire_date)/365, 0) as 경과년수
from employees;


# format
# date_format
select date_format(current_date, '%y-%m');  # 소문자 y는 2자리 연도.   # yy-mm
select date_format(current_date, '%Y-%m');  # 대문자 Y는 4자리 연도.   # yyyy-mm
# 연)   %Y : 2022,  %y : 22
# 월)   %m : 01,  %M: JANUARY ,   %c : 1
# 일)   %d : 08,  %D: 08TH    ,   %e : 8
# 시간)  시간: %H , %l(소문자L)
# 분) %i
# 초) %s


# period_diff(년월1, 년월2): 개월수 차이만 구한다. 단 년월이 '202201'형식으로 들어가야 한다.
select period_diff('202201', '202101');  # 12  (개월) 

# 입사한지 며칠되었는지 경과개월수 조회
select truncate(datediff(current_date, hire_date)/365, 0) as 경과년수,
period_diff(date_format(current_date,'%Y%m'), date_format(hire_date, '%Y%m'))
from employees;


--
# 조인: 두 개 이상의join 테이블 합쳐서 조회하기 (열을 합침)

# 양쪽 테이블에 있는 동일한 테이블은 반드시 명시해야 한다. 
select first_name, emp.department_id, dep.department_name
from employees emp inner join departments dep 
on emp.department_id=dep.department_id;

/*
as로 테이블별 별칭도 달 수 있다.

select 컬럼들
from 테이블1 inner join 테이블2 on 조인 조건식
[where 일반 조회조건식]
;
*/


# 부서코드가 50, 80, 100 부서원들에 대해서 이름, 사원의 부서코드, 부서이름 조회
select first_name, emp.department_id, dep.department_name
from employees emp inner join departments dep 
on emp.department_id=dep.department_id  # on뒤에는 조인과 관련된 조건 
where emp.department_id in (50, 80, 100);  # where문에는 조인과 관련 없는 조건 

# 모든 사원의 이름, 부서코드, 부서이름, 근무도시이름 조회
# employees: 사원정보

# 한 번에 여러 테이블 조인 
# 어떤 사원이, 어떤 부서에, 어떤 도시에 있는지 알아보기 
select first_name, e.department_id, department_name, d.location_id, l.city
from employees e 
inner join departments d on e.department_id = d.department_id
inner join locations l on d.location_id = l.location_id
order by first_name;


select first_name, department_id
from employees
where department_id is null;


# inner join : join에 참여한 모든 테이블에 존재하는 레코드만 조인. (교집합). join이라고만 써도 inner join이라고 합니다.

# outer join : 합침합. 조인의 조건에 만족되지 않는 행까지도 포함시킨다. 

# left outer join: 왼쪽 테이블의 데이터는 모두 조회되어야 한다. 왼쪽 전체 + 교집합 
# 사원 이름, 부서코드, 부서이름 조회하되 부서코드없는 직원도 포함해서 조회
select  first_name, e.department_id, department_name
from employees e left outer join departments d on e.department_id = d.department_id
order by 1;   # 부서가 없는 Kimberely 포함

# 부서코드가 없는 사원은 부서id를 -, 부서명을 '미정'으로 표시.
select first_name, ifnull(e.department_id, '-'), ifnull(department_name, '미정')
from employees e left outer join departments d on e.department_id = d.department_id;


# right outer join: 오른쪽 테이블의 데이터는 모두 조회되어야 한다. 오른쪽 전체 + 교집합 
# 사원 이름, 부서코드, 부서이름 조회하되 부서원 없는 부서도 포함해서 조회
select ifnull(first_name, '부서원 없음'), e.department_id, department_name
from employees e right outer join departments d on e.department_id = d.department_id;  # 부서원이 없는 부서도 출력되었다. 

select found_rows();  # 122개


# full outer join: mysql에서는 미지원. 전체 합집합.


# cross join: 되도록 하지말자. 지양. 의도적으로 대량 데이터들이 필요한 경우에만 사용한다. (예외적 사용)
# 곱집합. 한 쪽 테이블의 모든 행들과 다른 쪽 테이블의 모든 행을 조인시킨다. 기존 조인에서 on 생략하면 된다.
# 만약 테이블a에 n개 행, 테이블b에 m개 행이 있다면 결과는 n * m개
select first_name, emp.department_id, dep.department_name
from employees emp inner join departments dep;  # 부서 id마다 부서명을 알 수 없어 사실상 의미 없는 조인이다. 
# on emp.department_id=dep.department_id;


# self join : 자기 자신의 테이블을 조인한다. 컬럼명 앞에 별칭을 반드시 사용. 필수.
# inner join 
select me.first_name, me.manager_id, man.employee_id, man.first_name
from employees me inner join employees man on me.manager_id = man.employee_id;
select found_rows();  # 106

# self join : 자기 자신의 테이블을 조인한다. 컬럼명 앞에 별칭을 반드시 사용. 필수.
# outer 조인(보통 ifnull함수와 자주 사용)
select me.first_name, me.manager_id, man.employee_id, man.first_name, ifnull(man.first_name, "사장님")
from employees me left outer join employees man on me.manager_id = man.employee_id;
select found_rows();  # 107

# 자신의 직속 상사보다 많은 급여를 받는 사원의 이름, 사원의 급여, 직속상사의 급여 조회
# 셀프조인 실습
select emp.first_name, emp.salary, manager.salary
from employees emp inner join employees manager on emp.manager_id = manager.employee_id
where emp.salary > manager.salary;  # 2건이 출력된다. Lisa, Elien 

--
# UNION : 레코드, 행, row 합침 (컬럼을 합치는 건 조인)
# UNION : 두 개의 테이블에서 중복값이 있으면 1개만 가져온다.
# UNION ALL : 중복허용

# 사전준비 
# 50번 부서원의 모든 컬럼을 복사하여 emp_dept_50 테이블 생성
create table emp_dept_50 (select * from employees where department_id = 50);

# manager 직종 사원의 모든 컬럼 복사하여 emp_job_man 테이블 생성
create table emp_job_man (select * from employees where job_id like '%MAN%');

# a, b회사가 병합해서 테이블이 각각 있었는데 통합할 것. (행을 합치는 것이다. 예를 들어 사원 30명 + 사원 50명)
# union : 두 개의 테이블에서 중복값이 있으면 1개만 가져온다.
select employee_id, first_name, department_id, job_id from emp_dept_50
union
select employee_id, first_name, department_id, job_id from emp_job_man;

# union이라서 중복값은 1개만 가져온 것이다. 
select found_rows();  # 52


select count(*) from emp_dept_50; # 45
select count(*) from emp_job_man; # 12

# union : 중복은 1개만 가져온다. (중복불가)
select employee_id, first_name, department_id, job_id from emp_dept_50
union
select employee_id, first_name, department_id, job_id from emp_job_man;

# 교집합은 5개이다.
select dept.employee_id, dept.first_name, dept.department_id, dept.job_id 
from emp_dept_50 dept inner join emp_job_man man on dept.employee_id = man.employee_id;

# union all : 중복도 개별로 가져온다. (중복허용)
select employee_id, first_name, department_id, job_id from emp_dept_50
union all
select employee_id, first_name, department_id, job_id from emp_job_man;

select found_rows();  # 57 (= 52 + 5)

--
# subquery(서브쿼리) : 다른 쿼리(= 메인쿼리) 안에 있는 쿼리. select안에 select.
/*
단일 행 서브쿼리: 서브쿼리 결과로 1개행만 리턴되는 경우. 이럴 땐 동등비교(=).  대소비교할 때는 > <
다중 행 서브쿼리: 서브쿼리 결과로 2개이상 행 리턴되는 경우.  이럴 땐 in연산자 사용.  대소비교할 때는 >all(모든 결과값에 대해서), >any(단 1개 이상에 대해서)
-> 그냥 = 대신 in을 쓰면 해결된다.
*/

# employees 테이블에서 이름이 kelly인 사원과 같은 부서에 근무하는 사원의 이름, 부서 이름 조회
select department_id
from employees
where first_name = 'kelly';

# 서브쿼리 적용
select first_name, department_id
from employees
where department_id = (select department_id from employees where first_name = 'kelly');


# employees 테이블에서 이름이 kelly인 사원과 같은 직종에 근무하는 사원의 이름, 부서 이름 조회
select first_name, job_id
from employees
where job_id = (select job_id from employees where first_name = 'kelly');


# employees 테이블에서 이름이 kelly인 사원보다 높은 연봉을 받는 사원의 이름, 부서 이름 조회

select salary
from employees
where first_name = 'kelly';

select first_name, salary
from employees
where salary > (select salary from employees where first_name = 'kelly');


# employees 테이블에서 이름이 peter인 사원과 같은 부서에 근무하는 사원의 이름, 부서 코드 조회 (오류: peter가 3명이라 department id도 여러개 -> 해결: in)
select first_name, department_id
from employees
where department_id in (select department_id from employees where first_name = "peter");


select salary from employees where first_name = "william";  # '7400.00', '8300.00'


# 다중행 서브쿼리에서 all(결과가 여러개 일때)
# employees 테이블에서 이름이 william인 모든 사원보다 많은 급여를 받는 사원의 이름, 부서 코드 조회
select first_name, salary
from employees
where salary > all (select salary from employees where first_name = "william");

# 다중행 서브쿼리에서 any(결과가 여러개 일때)
# employees 테이블에서 단 1명의 william보다 많은 급여를 받는 사원의 이름, 부서 코드 조회
select first_name, salary
from employees
where salary > any (select salary from employees where first_name = "william");




# not in / in : 서브쿼리 형태에서 사용한다. 
# not in
# 대상은 50번 부서원이면서 manager직종으로 한정하여 대상자 사번, 이름, 부서, 직종을 조회한다.

# in: 양쪽을 모두 만족하는 결과만 가져온다. (교잡합)
select employee_id, first_name, department_id, job_id
from emp_dept_50
where employee_id in (select employee_id from emp_job_man);

# not in: 한쪽의 조건만 만족하고, 다른쪽은 조건은 포함하지 않는 형태이다.
# 재난지원금을 지원하고자 한다.
# 대상은 50번 부서원 가운데 MANAGER 직종은 제외하고
# 대상자 사번과 이름, 부서, 직종을 조회한다.
select employee_id, first_name, department_id, job_id
from emp_dept_50
where employee_id not in (select employee_id from emp_job_man);


# 비교) Union: 두가지 조건 중 하나만 만족해도 가져온다.
select employee_id, first_name, department_id, job_id
from emp_dept_50
union
select employee_id, first_name, department_id, job_id
from emp_job_man;

# in