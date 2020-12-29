-- scott 계정
-- join 연습(모든 문장은 Oracle 문법, ANSI 표준 문법 두가지로 작성)

-- 부서번호, 부서이름, 부서별 사원수, 부서별 급여 최솟값, 최댓값, 평균을 출력.
-- 소수점이 있는 경우에는 소수점 한자리까지만 출력.
-- 부서번호 오름차순으로 정렬 출력.
select d.deptno, d.dname, count(e.empno) as 사원수,
       min(e.sal) as 급여최솟값, max(e.sal) as 급여최댓값,
       round(avg(e.sal), 1) as 급여평균
from emp e, dept d
where e.deptno = d.deptno
group by d.deptno, d.dname
order by d.deptno;

select d.deptno, d.dname, count(e.empno) as 사원수,
       min(e.sal) as 급여최솟값, max(e.sal) as 급여최댓값,
       round(avg(e.sal), 1) as 급여평균
from emp e join dept d on e.deptno = d.deptno
group by d.deptno, d.dname
order by d.deptno;

-- 부서번호, 부서이름, 사번, 이름, 직책, 급여를 출력.
-- 부서 테이블의 있는 모든 부서 번호/이름은 출력되어야 함.
-- 부서번호 오름차순으로 정렬 출력.
select d.deptno, d.dname, e.empno, e.ename, e.job, e.sal
from dept d, emp e
where d.deptno = e.deptno(+)  -- left (outer) join
order by d.deptno;

select d.deptno, d.dname, e.empno, e.ename, e.job, e.sal
from emp e, dept d
where e.deptno(+) = d.deptno  -- right (outer) join
order by d.deptno;

select d.deptno, d.dname, e.empno, e.ename, e.job, e.sal
from dept d left join emp e on d.deptno = e.deptno
order by d.deptno;

select d.deptno, d.dname, e.empno, e.ename, e.job, e.sal
from emp e right join dept d on e.deptno = d.deptno
order by d.deptno;

-- 부서번호, 부서이름, 사번, 이름, 매니저 사번, 매니저 이름, 급여, 급여등급을 출력
-- 모든 부서번호가 출력되어야 함(10, 20, 30, 40).
-- 매니저가 없는 사원의 정보도 출력되어야 함(KING).
-- 정렬 순서: 부서번호 -> 사번
select d.deptno, d.dname, e1.empno, e1.ename, e1.mgr, e2.ename, e1.sal, s.grade
from dept d, emp e1, emp e2, salgrade s
where d.deptno = e1.deptno(+)
  and e1.mgr = e2.empno(+)
  and e1.sal between s.losal(+) and s.hisal(+)
order by d.deptno, e1.empno;

select d.deptno, d.dname, e1.empno, e1.ename, e1.mgr, e2.ename, e1.sal, s.grade
from dept d left join emp e1 on d.deptno = e1.deptno
        left join emp e2 on e1.mgr = e2.empno
        left join salgrade s on e1.sal between s.losal and s.hisal
order by d.deptno, e1.empno;

-- 부서 위치, 부서에서 근무하는 사원수를 출력(inner join)
select d.loc, count(e.empno)
from dept d, emp e
where d.deptno = e.deptno
group by d.loc;

select d.loc, count(e.empno)
from dept d join emp e on d.deptno = e.deptno
group by d.loc;

-- 부서 위치, 부서에서 근무하는 사원수를 출력.
-- 사원수가 없는 부서 위치도 출력되어야 함(outer join)
select d.loc, count(e.empno)
from dept d, emp e
where d.deptno = e.deptno(+)
group by d.loc;

select d.loc, count(e.empno)
from dept d left join emp e on d.deptno = e.deptno
group by d.loc;

-- 부서 위치, 부서 위치별 급여 합계를 출력.
-- inner join, outer join 두가지를 비교.
select d.loc, sum(e.sal)
from dept d, emp e
where d.deptno = e.deptno
group by d.loc;

select d.loc, sum(e.sal)
from dept d join emp e on d.deptno = e.deptno
group by d.loc;

select d.loc, sum(e.sal)
from dept d, emp e
where d.deptno = e.deptno(+)
group by d.loc;

select d.loc, sum(e.sal)
from dept d left join emp e on d.deptno = e.deptno
group by d.loc;

-- 사원이름, 급여, 부서위치, 급여등급을 출력.
-- 급여는 3000 이상인 직원들만 출력. 사원이름 오름차순 정렬 출력.
select e.ename, e.sal, d.loc, s.grade
from emp e, dept d, salgrade s
where e.deptno = d.deptno 
  and e.sal between s.losal and s.hisal
  and e.sal >= 3000
order by e.ename;

select e.ename, e.sal, d.loc, s.grade
from emp e join dept d on e.deptno = d.deptno
        join salgrade s on e.sal between s.losal and s.hisal
where e.sal >= 3000
order by e.ename;
