-- scott 계정

-- https://github.com/JakeOh/202011_itw_bd21/blob/main/datasets/call_chicken.csv
-- github 사이트에서 CSV 파일을 다운로드

-- CSV(Comma-Separated Values) 파일:
-- 값들이 comma(,)로 분리되어 저장된 텍스트 파일.
-- CSV 파일의 각 행(row)은 테이블의 row가 됨.
-- CSV 파일의 각 행에서 comma로 구분된 값들은 테이블의 column이 됨.
-- CSV 파일에서 값들은 comma로 구분되는 게 일반적이지만,
-- 때로는 공백(' '), 탭, 콜론(: 또는 ::)으로 값들을 구분하기도 함.

-- 테이블 이름: call_chicken
-- 컬럼: call_date(날짜), call_day, gu, ages, gender, calls(숫자)
create table call_chicken (
    call_date date,
    call_day  varchar2(2),
    gu        varchar2(10),
    ages      varchar2(10),
    gender    varchar2(2),
    calls     number(3)
);

-- 테이블 이름 오른쪽 클릭 -> 데이터 임포트

select * from call_chicken;

-- 1. 통화건수의 최댓값과 최솟값을 찾으세요.
select max(calls), min(calls) from call_chicken;

-- 2. 통화건수가 최댓값 또는 최솟값에 해당하는 레코드(모든 컬럼 값)을 출력하세요.
select * from call_chicken
where calls = (select max(calls) from call_chicken)
   or calls = (select min(calls) from call_chicken);

select sal from emp where deptno = 10;
select * from emp
where sal in (select sal from emp where deptno = 10);

-- Oracle: 합집합(union), 교집합(intersect) 연산
select max(calls) from call_chicken
union
select min(calls) from call_chicken;

select * from call_chicken
where calls in (
    select max(calls) from call_chicken
    union
    select min(calls) from call_chicken
);

-- 3. 요일별 통화건수의 평균을 출력하세요.
select call_day, round(avg(calls), 1) as avg_calls
from call_chicken
group by call_day
order by avg_calls desc;

-- 4. 연령대별 통화건수의 평균을 출력하세요.
select ages, round(avg(calls), 1) as avg_calls
from call_chicken
group by ages
order by avg_calls desc;

-- 5. 요일별, 연령대별 통화건수의 평균을 출력하세요.
select call_day, ages, round(avg(calls), 1) as avg_calls
from call_chicken
group by call_day, ages
order by avg_calls desc;

-- 6. 구별, 성별 통화건수의 평균을 출력하세요.
select gu, gender, round(avg(calls), 1) as avg_calls
from call_chicken
group by gu, gender
order by avg_calls desc;

-- 7. 요일별, 구별, 연령대별 통화건수의 평균을 출력하세요.
select call_day, gu, ages, round(avg(calls), 1) as avg_calls
from call_chicken
group by call_day, gu, ages
order by avg_calls desc;

-- 3 ~ 7 문제의 모든 출력은 통화건수 (평균)의 내림차순으로 정렬해서 출력하고,
-- 소수점이 있는 경우 소수점 이하 1자리까지만 출력하세요.
