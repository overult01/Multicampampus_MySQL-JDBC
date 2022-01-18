use employeesdb;
-- emp / emp 접속 - employeesdb의 테이블들 이용(EMP_COPY테이블 사용하지 말고 EMPLOYEES  테이블)

-- --기본--
-- 1. 직원 중에서 연봉이 170000 이상인 직원들의 이름, 연봉을 조회하시오.
--   연봉은 급여(salary)에 12를 곱한 값입니다.
-- 단, 이름은 "이름", 연봉은 "월급의 12배"로 출력되도록 조회하시오.

select first_name as 이름, salary * 12 as '월급의 12배'
from employees
where salary*12 >= 170000;

-- 2. 직원 중에서 부서id가 없는 직원의 이름과 급여를 조회하시오.
select first_name, salary, department_id
from employees
where department_id is null;

-- 3. 2004년 이전(2004년 포함)에 입사한 직원의 이름, 급여, 입사일을 조회하시오.
select first_name, salary, hire_date
from employees
where hire_date <= '2004-12-31'
order by 3;

select first_name, salary, hire_date
from employees
where substr(hire_date, 1, 4) <= '2004'
order by 3;


-- 4. departments 테이블에서 부서코드, 부서명을 조회하시오.
desc departments;

select department_id, department_name
from departments;


# 5. jobs 테이블에서 직종코드와 직종명을 조회하시오.
desc jobs;

select job_id, job_title
from jobs;

-- 논리연산자 --
# 1. 80, 50 번 부서에 속해있으면서 급여가 13000 이상인 직원의 이름, 급여, 부서id를 조회하시오.
select first_name, salary, department_id
from employees
where department_id IN(80, 50) and salary>=13000;

# 위와 같음.
select first_name, salary, department_id
from employees
where (department_id = 80 or department_id = 50) and salary>=13000;


# 2. 2005년 이후에 입사한 직원들 중에서(그리고) 급여가 1300 이상 20000 이하인 직원들의 이름, 급여, 부서id, 입사일을 조회하시오.
select first_name, department_id, hire_date from employees
where hire_date >= '2005-01-01' and salary between 13000 and 20000; 


-- SQL 비교연산자 --

# 3. 2005년도 입사한 직원의 정보(이름, 급여, 부서코드, 입사일)만 출력하시오.
select first_name, salary, department_id, hire_date from employees
# where hire_date like '2005%';
# where substr(hire_date, 1, 4) = '2005';
# where instr(hire_date, '2005') = 1;

# 4. 직종이 clerk 군인 직원의 이름, 급여, 직종코드를 조회하시오. (clerk 직종은 job_id에 CLERK을 포함하거나 CLERK으로 끝난다.)
select first_name, salary, job_id
from employees
where job_id like '%clerk%';


# 5. 12월에 입사한 직원의 이름, 급여, 입사일을 조회하시오.
select first_name, salary, hire_date
from employees
where hire_date like '_____12%';

# where instr(substr(hire_date, 6) '12') = 1;


# 6. 이름에 le 가 들어간 직원의 이름, 급여, 입사일을 조회하시오.
select first_name, salary, hire_date
from employees
where instr(first_name, 'le') >= 1;

# 7. 이름이 m으로 끝나는 직원의 이름, 급여, 입사일을 조회하시오.
select first_name, salary, hire_date
from employees
where first_name like '%m';

# 8. 이름의 2번째 글자가 d인 이름, 급여, 입사일을 조회하시오.
select first_name, salary, hire_date
from employees
where first_name like '_d%';

# 9. 커미션을 받는 직원의 이름, 커미션, 급여를 조회하시오.
select first_name, commission_pct, salary
from employees
where commission_pct is not null;

# 10. 커미션을 받지 않는 직원의 이름, 커미션, 급여를 조회하시오.
select first_name, commission_pct, salary
from employees
where commission_pct is null;

# 11. 30, 50, 80 번 부서에 속해있으면서, 
# 급여를 5000 이상 17000 이하를 받는 직원을 조회하시오. 
# 단, 커미션을 받지 않는 직원들은 검색 대상에서 제외시키며, 먼저 입사한 직원이 
# 먼저 출력되어야 하며 입사일이 같은 경우 급여가 많은 직원이 먼저 출력되록 하시오.
select first_name, department_id, commission_pct, salary, hire_date
from employees
where department_id IN (30, 50, 80) 
and salary between 5000 and 17000 
and commission_pct is not null
order by hire_date asc, salary desc;


-- 함수 --
# 1. employees 테이블에서 각 사원의 이름과 직속상사의 사번을 조회한다.
# (직속상사의 사번은 manager_id 컬럼이다). 직속상사가 없으면 BOSS 로 출력한다.

desc employees;

select employee_id, ifnull(job_id, 'BOSS'), first_name, manager_id
from employees;

# 3. EMPLOYEES 테이블의 사원에 대해 직종에 따라 보너스를 지급하려고 한다.
# (직종은 job_id 컬럼이고 programmer 직종은 prog, 
# manager 직종은 mgr, account 직종은 account를 포함한다
# 직종이 programmer 계열이면 보너스는 자신의급여*5
# 직종이 manager 계열이면 보너스는 자신의급여*4
# 직종이 account 계열이면 보너스는 자신의급여*3
# 직종이 clerk 계열이면 보너스는 자신의급여*2
# 그밖의 직종은 자신의급여로 정한다.
# 보너스를 조회하시오.

select job_id,
case 
when job_id like '%prog' then salary*5
when job_id like '%mgr' then salary*4
when job_id like '%account' then salary*3
when job_id like '%clert' then salary*2
end as 보너스
from employees;












