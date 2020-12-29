-- hr 계정 사용
-- group by, subquery 연습

-- 1) 부서별 사원수, 급여 최댓값, 최솟값, 합계, 평균, 중앙값, 분산, 표준편차 검색
-- 소수점이 출력되는 경우는 소수점 1자리까지만 표현.
-- 부서번호의 오름차순을 정렬해서 출력
select department_id, 
       count(*) as counts,
       max(salary) as max_sal,
       min(salary) as min_sal,
       sum(salary) as sum_sal,
       round(avg(salary), 1) as avg_sal,
       median(salary) as median_sal,
       round(variance(salary), 1) as var_sal,
       round(stddev(salary), 1) as std_sal
from employees
group by department_id
order by department_id;


-- 2) 직책별 사원수, 급여 최댓값, 최솟값, 합계, 평균, 중앙값, 분산, 표준편차 검색
-- 소수점이 출력되는 경우는 소수점 1자리까지만 표현.
-- 직책의 오름차순을 정렬해서 출력
select job_id, 
       count(*) as counts,
       max(salary) as max_sal,
       min(salary) as min_sal,
       sum(salary) as sum_sal,
       round(avg(salary), 1) as avg_sal,
       median(salary) as median_sal,
       round(variance(salary), 1) as var_sal,
       round(stddev(salary), 1) as std_sal
from employees
group by job_id
order by job_id;

-- 3) 부서별 직책별 사원수, 급여의 평균 검색
-- 부서번호, 직책 순으로 정렬.
select department_id, job_id, count(*), round(avg(salary), 1)
from employees
group by department_id, job_id
order by department_id, job_id;

-- 4) 사번, 이름(first/last name), 입사일, 급여를 입사일 오름차순으로 출력
select employee_id, 
       concat(concat(first_name, ' '), last_name) as name,
       hire_date,
       salary
from employees
order by hire_date;

-- 5) 입사연도별 사원수, 급여의 최댓값, 최솟값, 평균을 입사연도 오름차순으로 출력
select to_char(hire_date, 'YYYY') as year,
       count(*) as counts,
       max(salary) as max_sal,
       min(salary) as min_sal,
       round(avg(salary), 1) as avg_sal
from employees
group by to_char(hire_date, 'YYYY')
order by year;

-- 6) 수당을 받는 직원들의 직책별 사원수, 연봉의 평균을 직책의 오름차순으로 출력
-- 연봉 = salary * 12 * (1 + commission_pct)
select job_id, count(*), avg(salary * 12 * (1 + commission_pct))
from employees
where commission_pct is not null
group by job_id
order by job_id;

-- 7) 부서번호가 90번이 아니고, null이 아닌 사원들 중에서
-- 부서별 인원수가 10명 이상인 부서의
-- 부서별 인원수, 급여의 최솟값, 최댓값, 중앙값을 부서번호 오름차순으로 출력
select department_id, count(*), min(salary), max(salary), median(salary)
from employees
where department_id != 90 and department_id is not null
group by department_id
having count(*) >= 10
order by department_id;

-- 8) 각 부서에서 급여가 가장 작은 사원의 부서번호, 사번, 이름, 급여를
-- 부서번호의 오름차순으로 출력
select department_id, min(salary)
from employees
group by department_id;  -- 부서별 급여 최솟값.

select department_id, employee_id, first_name, last_name, salary
from employees
where (department_id, salary) in (
    select department_id, min(salary) 
    from employees
    group by department_id
)
order by department_id;

-- null: 값이 없음을 의미. 비교 연산(=, !=, >, <, ...)을 수행할 수 없음.
select * from employees where department_id = null;  -- 검색 결과 0건
select * from employees where department_id is null;  -- 검색 결과 1건
-- col in (a, b): col = a or col = b 간단히 표현
select * from employees where department_id in (10, 20);
select * from employees where department_id = 10 or department_id = 20;
-- col in (a, null): col = a or col = null
select * from employees where department_id in (10, null);

-- 9) 각 부서에서 급여가 가장 많은 사원의 부서번호, 사번, 이름, 급여를
-- 부서번호의 오름차순으로 출력
select department_id, employee_id, first_name, last_name, salary
from employees
where (department_id, salary) in (
    select department_id, min(salary) from employees
    group by department_id
)
order by department_id;

-- 10) 10번 부서 매니저의 사번, 이름, 입사일을 출력
select employee_id, first_name, last_name, hire_date
from employees
where employee_id = (
    select manager_id from departments
    where department_id = 10
);

-- 11) 10번 부서가 위치한 도시(city), 주(state_province), 국가코드(country_id)를 출력
select city, state_province, country_id
from locations
where location_id = (
    select location_id from departments
    where department_id = 10
);
