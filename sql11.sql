-- hr 계정, group by, join, sub query 연습

-- 1. 직원 이름(first/last)과 부서이름 출력
select e.first_name || ' ' || e.last_name as NAME,
       d.department_name
from employees e, departments d
where e.department_id = d.department_id
order by e.employee_id;

select e.first_name || ' ' || e.last_name as NAME,
       d.department_name
from employees e inner join departments d
        on e.department_id = d.department_id
order by e.employee_id;

-- 2. 위 결과에서 부서번호가 없는 직원도 출력
select e.first_name || ' ' || e.last_name as NAME,
       d.department_name
from employees e, departments d
where e.department_id = d.department_id(+)
order by e.employee_id;

select e.first_name || ' ' || e.last_name as NAME,
       d.department_name
from employees e 
    left outer join departments d
        on e.department_id = d.department_id
order by e.employee_id;

-- 3. 직원 이름과 직책이름(job_title)을 출력
select e.first_name || ' ' || e.last_name as name,
       j.job_title
from employees e, jobs j
where e.job_id = j.job_id
order by e.employee_id;

select distinct job_id from employees;

select e.first_name || ' ' || e.last_name as name,
       j.job_title
from employees e inner join jobs j
        on e.job_id = j.job_id
order by e.employee_id;

-- 4. 직원 이름과 그 직원이 근무하는 도시 이름(city)를 출력
select e.first_name || ' ' || e.last_name as name, l.city
from employees e, departments d, locations l
where e.department_id = d.department_id
  and d.location_id = l.location_id
order by e.employee_id;

select e.first_name || ' ' || e.last_name as name, l.city
from employees e
    inner join departments d on e.department_id = d.department_id
    inner join locations l on d.location_id = l.location_id
order by e.employee_id;

-- 5. 위 결과에서 근무하는 도시를 알 수 없는 직원도 출력
select e.first_name || ' ' || e.last_name as name, l.city
from employees e, departments d, locations l
where e.department_id = d.department_id(+)
  and d.location_id = l.location_id(+)
order by e.employee_id;

select e.first_name || ' ' || e.last_name as name, l.city
from employees e
    left outer join departments d on e.department_id = d.department_id
    left outer join locations l on d.location_id = l.location_id
order by e.employee_id;

-- 6. 2008년에 입사한 직원들의 이름을 출력
select first_name||' '||last_name as name, hire_date, department_id
from employees
where to_char(hire_date, 'YYYY') = '2008'
order by employee_id;

-- 7. 2008년에 입사한 직원들의 부서이름, 부서별 인원수 출력
select e.department_id, d.department_name, count(*)
from employees e, departments d
where e.department_id = d.department_id
  and to_char(e.hire_date, 'YYYY') = '2008'
group by e.department_id, d.department_name;

select e.department_id, d.department_name, count(*)
from employees e join departments d
        on e.department_id = d.department_id
where to_char(e.hire_date, 'YYYY') = '2008'
group by e.department_id, d.department_name;

-- 8. 2008년에 입사한 직원들의 부서이름, 부서별 인원수 출력
-- 단, 부서별 인원수가 5명 이상인 경우만 출력.
select e.department_id, d.department_name, count(*)
from employees e, departments d
where e.department_id = d.department_id
  and to_char(e.hire_date, 'YYYY') = '2008'
group by e.department_id, d.department_name
having count(*) >= 5;

select e.department_id, d.department_name, count(*)
from employees e join departments d
        on e.department_id = d.department_id
where to_char(e.hire_date, 'YYYY') = '2008'
group by e.department_id, d.department_name
having count(*) >= 5;

-- 9. 부서번호, 부서별 급여 평균을 출력
select department_id, round(avg(salary), 1) as avg_sal
from employees
group by department_id
order by department_id;

-- 10. 부서별 급여 평균이 최대인 부서의 부서번호, 급여 평균을 출력
-- 부서별 급여 평균의 최댓값
select max(avg(salary)) from employees group by department_id;

select department_id, round(avg(salary), 1) as avg_sal
from employees
group by department_id
having avg(salary) = (
    select max(avg(salary)) from employees group by department_id
);

-- 11. 부서별 급여 평균이 최대인 부서의 부서이름, 급여 평균을 출력
select d.department_name, round(avg(salary), 1) as avg_sal
from employees e, departments d
where e.department_id = d.department_id
group by d.department_name
having avg(e.salary) = (
    select max(avg(salary)) from employees group by department_id
);

select d.department_name, round(avg(e.salary), 1) as avg_sal
from employees e join departments d
        on e.department_id = d.department_id
group by d.department_name
having avg(e.salary) = (
    select max(avg(salary)) from employees group by department_id
);

-- ROLLUP
select department_id, count(*)
from employees
group by department_id
order by department_id;

select department_id, count(*)
from employees
group by rollup(department_id)
order by department_id;

select department_id, job_id, count(*)
from employees
group by department_id, job_id
order by department_id, job_id;

select department_id, job_id, count(*)
from employees
group by rollup(department_id, job_id)
order by department_id, job_id;

-- 12. 사번, 국가이름, 급여를 출력
select e.employee_id, c.country_name, e.salary
from employees e, departments d, locations l, countries c
where e.department_id = d.department_id
  and d.location_id = l.location_id
  and l.country_id = c.country_id
order by e.employee_id;

select e.employee_id, c.country_name, e.salary
from employees e 
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    join countries c on l.country_id = c.country_id
order by e.employee_id;

-- 13. 국가이름, 국가별 급여 합계을 출력
select c.country_name, sum(e.salary)
from employees e, departments d, locations l, countries c
where e.department_id = d.department_id
  and d.location_id = l.location_id
  and l.country_id = c.country_id
group by c.country_name;

select c.country_name, sum(e.salary)
from employees e 
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    join countries c on l.country_id = c.country_id
group by c.country_name;

-- 14. 사번, 직책이름, 급여를 출력
select e.employee_id, j.job_title, e.salary
from employees e, jobs j
where e.job_id = j.job_id
order by e.employee_id;

select e.employee_id, j.job_title, e.salary
from employees e join jobs j
        on e.job_id = j.job_id
order by e.employee_id;

-- 15. 직책 이름, 직책별 급여 합계을 출력
select j.job_title, sum(e.salary)
from employees e, jobs j
where e.job_id = j.job_id
group by j.job_title;

select j.job_title, sum(e.salary)
from employees e join jobs j
    on e.job_id = j.job_id
group by j.job_title;

-- 16. 국가이름, 직책이름, 국가별 직책별 급여 합계을 출력
select c.country_name, j.job_title, sum(e.salary)
from employees e, jobs j, departments d, locations l, countries c
where e.job_id = j.job_id
  and e.department_id = d.department_id
  and d.location_id = l.location_id
  and l.country_id = c.country_id
group by c.country_name, j.job_title
order by c.country_name, j.job_title;

select c.country_name, j.job_title, sum(e.salary)
from employees e
    join jobs j on e.job_id = j.job_id
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    join countries c on l.country_id = c.country_id
group by c.country_name, j.job_title
order by c.country_name, j.job_title;

-- 17. 국가이름, 직책이름, 국가별 직책별 급여 합계을 출력.
-- 미국에서, 국가별 직책별 급여 합계가 50,000 이상인 레코드만 출력.
select c.country_name, j.job_title, sum(e.salary)
from employees e, jobs j, departments d, locations l, countries c
where e.job_id = j.job_id
  and e.department_id = d.department_id
  and d.location_id = l.location_id
  and l.country_id = c.country_id
  and c.country_id = 'US'
group by c.country_name, j.job_title
having sum(e.salary) >= 50000
order by c.country_name, j.job_title;

select c.country_name, j.job_title, sum(e.salary)
from employees e
    join jobs j on e.job_id = j.job_id
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    join countries c on l.country_id = c.country_id
where c.country_id = 'US'
group by c.country_name, j.job_title
having sum(e.salary) >= 50000
order by c.country_name, j.job_title;