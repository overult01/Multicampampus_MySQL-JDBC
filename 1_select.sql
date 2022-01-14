select count(*) from countries;
select count(*) from departments;
select count(*) from employees;

# 워크벤치가 없을 때
show databases;
show tables;
describe employees;  # employees테이블의 구조를 설명해준다(테이블, 타입, Null 허용여부, primary key 존재여부)


# 순서
-- select
-- from
-- where
-- group by
-- having
-- order by



# select문: 조회  ( select 열이름 as 별칭 from 테이블명; )
select * from employees;
select employee_id as 사번,  last_name as 성, first_name as 이름 from employees;
select employee_id as 사번,  last_name as 성, first_name as 이름 from employees;
select employee_id as 사번,  salary*12 as 연봉 from employees;  # 곱셈을 할 수 있는 타입에서만 곱셈

select job_id from employees;

# distinct: 중복 제거해서 조회.
select job_id from employees;  # 직종별 1번씩 조회 
select distinct job_id from employees;  # 직종별 1번씩 조회 

# where: 조건 지정 
# employees에서 salary가 15000이상이고 20000 미만인 사원의 사번과 급여 조회
select employee_id as 사번, salary as 급여 from employees where salary >= 15000 and salary < 20000; # and를 기호로 쓰지 않는다.

# between ~ and 변경
# employees에서 salary가 15000이상이고 20000 미만인 사원의 사번과 급여 조회
select employee_id as 사번, salary as 급여 from employees where salary between 15000 and 20000;


# employees에서 사번이 100번인 사원의 사번과 급여 조회
select employee_id as 사번, salary as 급여 from employees where employee_id = 100;  # 동일한 것을 = 로 표현하는데 유의


# employees에서 사번이 100 또는 200 또는 250인 사원의 사번과 급여 조회
select employee_id as 사번, salary as 급여 from employees where employee_id = 100 or employee_id = 200 or employee_id = 250;  # 동일한 것을 = 로 표현하는데 유의

# in 변경(목록 연산자) : 동일 컬럼을 or로 연결해서 비교할 때 훨씬 간결하게 사용. 
# employees에서 사번이 100 또는 200 또는 250인 사원의 사번과 급여 조회
select employee_id as 사번, salary as 급여 from employees where employee_id in (100, 200, 250); 

# like 연산자( %: 0개 이상의 모든 문자열, _ : 문자 1개, 자릿수가 지정되어 있을 때 ) 
# first_name에 en이 포함된 사원의 first_name 조회
select first_name from employees where first_name like '%en%';

# first_name에 en으로 끝나는 사원의 first_name 조회
select first_name from employees where first_name like '%en';

# first_name에 en으로 끝나면서 이름이 3글자인 사원의 first_name 조회
select first_name from employees where first_name like '_en';


# order by: 정렬 ( asc: 오름차순. 생략가능 // desc: 내림차순. 큰 것 -> 작은 것 순 정렬 )
# 급여순으로 정렬하여 이름, 급여 역순 조회
select first_name, salary as 월급 from employees order by 월급 desc;

# 급여순으로 정렬하여 이름, 급여 오름차순 조회(만약 급여가 같으면, 이름의 역순으로)
select first_name, salary as 월급 from employees order by 월급, first_name desc;

# 급여순으로 정렬하여 이름, 급여 역순 조회(컬럼 순서 이용) 
select first_name, salary from employees where salary >= 10000 order by 2 asc, 1 desc;


# limit: paging처리( 1페이지 마다 n개씩지정하여, 몇 페이지를 확인할지 지정 ) 
# 급여가 10000이상인 사원을 대상으로 조회하되, 급여가 적은 사원부터 이름, 급여를 조회(컬럼 순서 이용)
select first_name, salary from employees 
where salary >= 10000 order by 2 asc, 1 desc
limit 10, 5; #limit(몇 번부터, 몇 개 출력)

# 서브쿼리: 메인 쿼리 안에서 포함된 내부 쿼리
# 이미 생성되고 데이터 입력된 테이블을 다른 테이블로 복사
create table emp_copy (select * from employees); # 11개 컬럼, 107개 행 복사 
select * from emp_copy;

# 이미 생성되고 데이터 입력된 테이블 중에서 조건을 입력해서 다른 테이블로 복사
create table emp_copy2 (select * from employees where salary >= 20000); # 11개 컬럼, 107개 행 복사 
select * from emp_copy2;



# count(컬럼): 컬럼에서 not null인 데이터 개수 
# count(*): 컬럼에서 모든(null 포함) 데이터 개수 
select count(department_id) from employees; # 부서 id에서 null이 아닌 행개수
select count(*) from employees;

# sum
# 모든 사원의 급여 총합
select sum(salary) from employees; # 691416.00

# avg
# 모든 사원의 급여 평균
select avg(salary) from employees; # 6461.831776

# 최고 급여 조회
select Max(salary) from employees;

# 다중행 함수들 한 번에 출력: 여러 행을 받아서 1개 값을 반환하는 함수들.
select sum(salary), avg(salary), Max(salary), Min(salary) from employees; # 691416.00



# group by: 데이터를 그룹화해준다 
# select로 '조회할 컬럼'을 group by 해야 의미가 있다. 

# 주의: 그룹함수는 결과가 무조건 1개만 나온다. 다른 컴럼과 동시 select 하지 말것. 그룹함수는 그룹함수끼리 조회.

# 단, 그룹함수와 조회 컬럼이 groby by 절 컬럼이 동일하다면 가능
# depart

# 부서별 직종별 급여평균 조회하되 급여평균 높은 부서부터 조회
select department_id, job_id, avg(salary), avg(salary) as A from employees
group by department_id, job_id
order by A desc;

/* 실행되는 순서
1. from 테이블 찾아온다
2. where 조건식 만족한 레코드를 찾아온다 - 그룹함수 조건식 불가 
3. group by 컬럼으로 그룹화한다 - 그룹에 대한 조건이 필요하면 having으로 조건 지정 
4. having 수행한다. 결과 만족하는 레코드를 찾아온다 - 그룹함수 조건식으로 사용한다 
5. select를 수행한다(결과물을 가지고 있는다). 
6. order by 로 순서를 정렬한다.
7. limit 0, 5를 하면 0번인덱스부터 5까지, 개수를 자른다.
8. select를 출력한다.
*/


# 부서별 직종별 급여평균 조회하되 급여총합이 300000이상인 부서만 조회(출력불가)
select department_id, sum(salary)
from employees
where sum(salary) >= 300000
group by department_id;

# having 
# 부서별 직종별 급여평균 조회하되 급여총합이 300000이상인 부서만 조회(group by의 조건은 having) 
select department_id, job_id, sum(salary)
from employees
group by department_id
having sum(salary) >= 300000;

# 사원의 급여가 5000이상인 사원들만을 대상으로 (where)
# 부서별 직종별 급여평균 조회하되 급여총합이 50000이상인 부서만 조회(group by의 조건은 having) 
# 조회되는 순서는 급여 총합이 높은 레코드부터 조회한다. (order by)
# 그룹함수의 조건만 having 절에 사용한다(일반 조건은 where절) 
select department_id, job_id, sum(salary)
from employees
where salary >= 5000
group by department_id, job_id
/*having sum(salary) >= 50000 */
order by sum(salary) desc;


# Rollup: 소합계 구하기. group by 뒤에 붙어서 그룹별 총합 구하기 (with rollup)
# 부서	직종		xxx
# 부서	null	xxx <- 부서별 소합계 구하기 
select department_id, ifnull(job_id,'소계'), sum(salary)
from employees
where salary >= 5000
group by department_id, job_id with rollup;
/*having sum(salary) >= 50000 */


# 날짜, 시간
# datetime 날짜와 시간정보. 
# hire_date은 데이터에서 사원 입사일 정보 컬럼
select hire_date from employees; # '2001-01-13 00:00:00'
desc employees;  # datetime 타입임을 확인: yyyy-mm-dd hh:mi:ss  # 오라클은 연도를 2자리로 한다. 

select current_timestamp();  # 현재 서버 실행 컴퓨터 현재시각 내장함수 

# 입사일이 2005년에 입사한 사원의 이름과 입사일 조회
select first_name, hire_date from employees
where hire_date like '2005%';

# 2005년 입사자 사원의 이름과 입사일 조회
select first_name, hire_date from employees
where hire_date like '2002%';

# 입사일이 6월에 입사한 사원의 이름과 입사일 조회
select first_name, hire_date from employees
where hire_date like '_____06%';

# 날짜도 크기 비교가 가능하다. 순서가 있다.
# 입사일이 2005년 이후에 입사한 사원의 이름, 입사일 조회
select first_name, hire_date from employees
where hire_date >= '2005-01-01 00:00:00'
order by hire_date;