/*****************************
파일명 : Or06GroupBy.sql
그룹함수(select문 2번째)
설명 : 전체 레코드(로우)에서 통계적인 결과를 구하기 위해 하나 이상의
    레코드를 그룹으로 묶어서 연산후 결과를 반환하는 함수 혹은 쿼리문
*****************************/
--사원테이블에서 담당업무 인출
select job_id from employees;--레코드 107개 인출

/*
distinct
    -동일한 값이 있는 경우 중복된 레코드를 제거한 후 하나의 레코드만
    가져와서 보여준다.
    -하나의 순수한 레코드이므로 통계적인 데이터를 계산할 수 없다.

*/
select distinct job_id from employees;

/*
group by
    -동일한 값이 있는 레코드를 하나의 그룹으로 묶어서 가져온다.
    -보여지는건 하나의 레코드지만 다수의 레코드가 하나의 그룹으로 묶여진
    결과이므로 통계적인 데이터를 계산할 수 있다.
    -최대, 최소, 평균, 합산 등의 연산이 가능하다.
*/
select job_id, count(*) from employees group by job_id;
--검증하기
select first_name, job_id from employees where job_id='ST_MAN';--5개
select first_name, job_id from employees where job_id='ST_CLERK';--20개

/*
그룹함수의 기본형식
    select
        컬럼1, 컬럼2, ... 혹은 전체(*)
    from
        테이블명
    where
        조건1 and 조건2 or 조건3 ...
    group by
        레코드 그룹화를 위한 컬럼명
    having
        그룹에서 찾을 조건
    order by
        정렬을 위한 컬렴명과 정렬방식

※ 쿼리의 실행순서
from(테이블) -> where(조건) -> group by(그룹화) -> having(그룹의조건)
    -> select(컬럼지정) -> order by(정렬방식)
*/

/*
sum(): 합계를 구할때 사용하는 함수
    -number 타입의 컬럼에서만 사용할 수 있다.
    -필드명이 필요한 경우 as를 이용해서 별칭을 부여할수 있다.
*/
--전체직원의 급여의 합계를 출력하시오.
select
    sum(salary) sumSalary, to_char(sum(salary), '990,000') sumSalary
from employees;

--10번 부서에 근무하는 사원들의 급여의 합계는 얼마인지 출력하시오.
select
    sum(salary) "단순합계", 
    to_char(sum(salary), '990,000') "세자리컴마",
    ltrim(to_char(sum(salary), '990,000')) "좌측공백제거",
    ltrim(to_char(sum(salary), 'L990,000')) "통화기호삽입"
from employees where department_id=10;


--sum()과 같은 그룹함수는 number타입인 컬럼에서만 사용할 수 있다.
select sum(first_name) from employees;

/*
count() : 레코드의 갯수를 카운트할때 사용하는 함수
*/
--사원테이블에 저장된 전체 사원수는 몇명인가?
select count(*) from employees; --방법1 : 권장사항
select count(employee_id) from employees; --방법2 : 권장사항아님
/*
    count()함수를 사용할떄는 위 2가지 방법 모두 가능하지만
    *를 사용할것을 권장한다. 컬럼의 특성 혹은 데이터의 따른 방해를
    받지 않으므로 검색속도가 빠르다.
*/

/*
count()함수의
    사용법1 : count(all 컬럼명)
        => 디폴트 사용법으로 컬럼 전체의 레코드를 기준으로 카운트한다.
    사용법2 : count(distinct 컬럼명)
        => 중복을 제거한 상태에서 카운트 한다.
*/
select
    count(job_id) "담당업무전체갯수1", 
    count(all job_id) "담당업무전체갯수2",
    count(distinct job_id) "순수담당업무갯수"
from employees;

/*
avg() : 평균값을 구할때 사용하는 함수
*/
--전체사원의 평균급여는 얼마인지를 출력하는 쿼리문을 작성하시오.
select
    count(*) "전체사원수",
    sum(salary) "급여의합계",
    sum(salary) / count(*) "평균급여1(직접계산)",
    avg(salary) "평균급여2",
    trim(to_char(avg(salary), '$999,000'))
from employees;

--영업팀(SALES)의 평균급여는 얼마인가요?
--1.부서테이블에서 영업팀의 부서번호가 무엇인지 확인한다.
/*
    정보검색시 대소문자 혹은 공백이 포함된 경우 모든 레코드에 대해
    문자열을 확인하는것은 불가능하므로 일괄적인 규칙의 적용을 위해
    upper()와 같은 변화함수를 사용하여 검색하는것이 좋다.
*/
select * from departments where lower(department_name)='sales';
select * from departments where department_name=initcap('sales');
select * from departments where lower(department_name)=lower('sales');--가장안전함
--앞에서 부서번호가 80인것을 확인한 후 다음 쿼리문 작성
select
    ltrim(to_char(avg(salary), '$999,000.00'))
from employees where department_id=80;

/*
min(), max() 함수 : 최대값, 최소값을 찾을때 사용하는 함수
*/
--사원테이블에서 가장 낮은 급여는 얼마인가요?
select min(salary) from employees;

--사원테이블에서 가장 낮은 급여를 받는 사람은 누구인가요?
---아래 쿼리문은 에러발생됨. 그룹함수를 일반컬럼에 사용할 수 없다.
select first_name, salary from employees where salary=min(salary);

--사원테이블에서 가장 낮은 급여인 2100을 받는 사원을 인출한다.
select first_name, salary from employees where salary=2100;

/*
    사원중 가장 낮은 급여는 min()으로 구할수 있으나 가장 낮은 급여를 
    받는 사람은 아래와 같이 서브쿼리를 통해 구할 수 있다.
    따라서 문제에 따라 서브쿼리를 사용할지 여부를 결정해야 한다.
*/
select first_name, salary from employees where salary=(
    select min(salary) from employees
);

/*
group by절 : 여러개의 레코드를 하나의 그룹으로 그룹화하여 묶여진
    결과를 반환하는 쿼리문.
    ※ distinct 는 단순히 중복값을 제거함.
*/
--사원테이블에서 각 부서별 급여의 한계는 얼마인가요?
--group by가 없다면 아래와같이 각 부서별로 합계를 구해야 할것이다.
select sum(salary) from employees where department_id=60;--IT부서의 급여합계
select sum(salary) from employees where department_id=100;--Finance부서의 급여합계
--step1 : 각 부서를 그룹화 하기
select department_id from employees group by department_id;
--step2 : 각 부서별로 급여합계 구하기
select department_id , sum(salary), trim(to_char(sum(salary), '$999,000'))
from employees 
group by department_id
order by sum(salary) desc;

/*
퀴즈] 사원테이블에서 각 부서별 사원수와 평균급여는 얼마인지 출력하는 쿼리문을
작성하시오.
출력결과 : 부서번호, 급여총합, 사원총합, 평균급여
출력시 부서번호를 기준으로 오름차순 정렬하시오.
*/

select 
    department_id "부서번호",
    sum(salary) "급여총합", 
    count(*) "사원수", 
    ltrim(to_char(avg(salary),'999,000')) "평균급여"
from employees group by department_id
order by department_id asc;

/*
앞에서 사용했던 쿼리문을 아래와 같이 수정하면 에러가 발생한다.
group by절에서 사용한 컬럼은 select절에서 사용할 수 있으나, 그외의
단일 컬럼은 select절에서 사용할 수 없다.
그룹화된 상태에서 특정 레코드 하나만 선택하는것은 애매하므로 에러가 발생한다.
*/
select 
    department_id "부서번호", sum(salary) "급여총합",
    first_name
from employees group by department_id
order by department_id asc;

/*
시나리오] 부서아이디가 50인 사원들의 직원총합, 평균급여, 급여총합이
    얼마인지 추력하는 쿼리문을 작성하시오.
*/
select 
    count(*) "총직원수",
    round(avg(salary)) "평균급여",
    sum(salary) "급여총합"
from employees 
where department_id=50
group by department_id;

/*
having절 : 물리적으로 존재하는 컬럼이 아닌 그룹함수를 통해 논리적으로
    생성된 컬럼의 조건을 추가할때 사용한다.
    해당 조건을 where절에 추가하면 에러가 발생한다.
*/

/*
시나리오] 사원테이블에서 각 부서별로 근무하고 있는 직원의 담당업무별 사원수와
    평균급여가 얼마인지 출력하는 쿼리문을 작성하시오.
    단, 사원수가 10을 초과하는 레코드만 인출하시오.
*/
select
    department_id, job_id, count(*), avg(salary)
from employees
/**where count(*)>10***/
group by department_id, job_id
having count(*)>10
order by department_id;
/*
    담당업부별 사원수는 물리적 존재하는 컬럼이 아니므로 
    where절에 쓰면 에러가 발생한다. 이런 경우에는 having절에
    조건을 추가해야 한다.
    ex) 급여가 3000인 사원      => 물리적으로 존재함
        평균급여가 3000인 사원  => 그룹함수를 통해 알수있는 데이터(논리데이터)
*/

/*
퀴즈] 담당업무별 사원의 최저급여를 출력하시오.
    단, 관리자가 없는 사원과 최저급여가 3000미만인 그룹은 제외시키고
    결과를 급여의 내림차순으로 정렬하여 출력하시오.
*/
select
    job_id, min(salary)
from employees
where manager_id is not null
group by job_id
having not min(salary)<3000
order by min(salary) desc;
/*
    문제에서는 급여의 내림차순으로 정렬하라는 지시사항이 있으나, 
    현재 select되는 항목이 급여의 최소값이므로 order by절에는 min(salary)를
    사용해야 한다.
*/

---------------------------------------------------------------------------
/*
1. 전체 사원의 급여최고액, 최저액, 평균급여를 출력하시오. 
컬럼의 별칭은 아래와 같이 하고, 평균에 대해서는 정수형태로 반올림 하시오.
별칭) 급여최고액 -> MaxPay
급여최저액 -> MinPay
급여평균 -> AvgPay
*/


select 
min(salary) as "MINPAY",
max(salary) as "MAXPAY", 
round(avg(salary)) as "AvgPay"
from employees;

--round(), to_char() : 반올림 처리 되어 출력됨
--trunc() : 소수 이하를 잘라서 출력됨. 반올림되지 않음.
select
    max(salary)MaxPay, min(salary) MinPay, avg(salary) AvgPay1,
    round(avg(salary)) AvgPay2, to_char(avg(salary), '99,000') AvgPay3,
    trunc(avg(salary)) AvgPay3 --<버림처리
from employees;


/*
2. 각 담당업무 유형별로 급여최고액, 최저액, 총액 및 평균액을 출력하시오. 
컬럼의 별칭은 아래와 같이하고 모든 숫자는 to_char를 이용하여 
세자리마다 컴마를 찍고 정수형태로 출력하시오.
별칭) 급여최고액 -> MaxPay
급여최저액 -> MinPay
급여평균 -> AvgPay
급여총액 -> SumPay
참고) employees 테이블의 job_id컬럼을 기준으로 한다.
*/

select
job_id,
    to_char(max(salary), '999,000') MaxPay, 
    to_char(min(salary), '999,000') MinPay, 
    to_char(sum(salary), '999,000') SumPay,
    to_char(round(avg(salary)), '999,000') AvgPay
    from employees
    group by job_id
    order by SumPay asc;

--group by절에서 사용한 컬럼은 select절에서 인출할 수 있다.
select
    max(salary) MaxPay, min(salary) MinPay, 
    avg(salary) AvgPay, sum(salary) SumPay
from employees group by job_id;


/*
3. count() 함수를 이용하여 담당업무가 동일한 사원수를 출력하시오.
참고) employees 테이블의 job_id컬럼을 기준으로 한다.
*/


select job_id, 
count(*) "직원합계"
from employees
group by job_id;

--물리적으로 존재하는 컬럼이 아니라면 함수 혹은 수식을 그대로 order by절에 기술하면된다.
--수식이 너무 길다면 별칭을 사용해도 된다.
select
    job_id, count(*) "사원수"
from employees group by job_id
/*order by count(*) desc;*/
order by "사원수" desc;


/*
4. 급여가 10000달러 이상인 직원들의 담당업무별 합계인원수를 출력하시오.
*/

select 
    job_id, count(*) "업무별합계인원"
from employees where salary>=10000
group by job_id;



/*
5. 급여최고액과 최저액의 차액을 출력하시오. 
*/

select 
max(salary) - min(salary)"최고최소급여차"
from employees;

/*
6. 각 부서에 대해 부서번호, 사원수, 부서 내의 모든 사원의 평균급여를 출력하시오.
평균급여는 소수점 둘째자리로 반올림하시오.
*/


select
department_id,
count(*),
to_char(avg(salary), '999,000.00') as "평균급여"
from employees
group by department_id,salary
order by department_id asc;


select
    department_id, count(*), avg(salary),
    to_char(avg(salary), '999,000.00') "평균급여1",
    round(avg(salary),2) "평균급여2"
from employees group by department_id;
order by department_id asc;
