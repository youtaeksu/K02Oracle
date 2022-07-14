/************************
파일명 : Or01SelectBasic.sql
처음으로 실행해보는 질의어(SQL문 혹은 Query문)
개발자들 사이에서는 '시퀄'이라고 표현하기도 한다.
설명 : select, where 등 가장 기본적인 DQL문 사용해보기
*************************/


/*
SQl Developer에서 주석 사용하기
    블럭단위주석 : 자바와 동일함
    라인단위주석 : -- 실행문장. 하이픈 2개를 연속으로 사용
*/

--select문 : 테이블에 저장된 레코드를 조회하는 SQL문으로 DQl문에 해당한다.
/*
형식]
    select 컬럼1, 컬럼2, .....[또는 *]
    from 테이블명
    where 조건1 and 조건2 or 조건3 .....
    order by 정렬할컬럼 asc(오름차순), desc(내림차순) ;
*/
--사원테이블에 저장된 모든 레코드를 대상으로 모든 컬럼을 조회하기 
select * from employees;


/*
컬럼명을 지정해서 조회하고 싶은 컬럼만 조회하기
=> 사원번호, 이름, 이메일, 부서번호만 조회해보자.
*/
select employee_id, first_name, last_name, email, department_id 
from employees;--하나의 쿼리문이 끝날때 ;을 반드시 기술해야 한다.

--테이블의 구조와 컬럼별 자료형, 크기를 출력한다.
desc employees;

/*
컬럼이 숫자형(number)인 경우 산술연산이 가능하다.
100불 인상된 직원의 급여를 조회하시오.
*/
select employee_id, first_name, salary, salary+100 from employees;
--number(숫자)타입의 컬럼끼리도 연산할 수 있다.
select employee_id, first_name, salary, salary+commission_pct 
from employees;--커미션은 영업사원만 있으므로 대부분의 결과는 null로 나온다.

/*
AS(알리아스) : 테이블 혹은 컬럼에 별칭(별명)을 부여할때 사용한다.
    내가 원하는 이름(영문, 한글)으로 변경한 후 출력할 수 있다.
    활용법] 급여+성과급율 => Salcomm과 같은 형태로 별칭을 부여한다.
*/
select first_name, salary, salary+100 as "급여100증가" from employees;
select first_name, salary, salary+commission_pct as Salcomm
from employees;--별칭은 영문으로 쓰는걸 권장한다.

--as는 생략할 수 있다.
select employee_id "사원아이디", first_name "이름", last_name "성"
from employees where first_name='William';

--오라클은 기본적으로 대소문자를 구분하지 않는다. 예약어의 경우 둘다 사용할수있다.
SELECT employee_id "사원아이디", first_name "이름", last_name "성"
FROM employees WHERE first_name='William';

--단, 레코드인 경우 대소문자를 구분한다. 아래 SQL을 실행하면 아무런 결과가 나오지 않는다.
SELecT employee_id "사원아이디", first_name "이름", last_name "성"
FROM employees WHERE first_name='WILLIAM';

/*
where절을 이용해서 조건에 맞는 레코드 추출하기
-> last_name이 smith인 레코드를 추출하시오
*/
select * from employees where last_name='Smith';
/*
where절에 2개 이상의 조건이 필요할때 and 혹은 or를 사용할 수 있다.
-> last_name이 smith이면서 급여가 8000인 사원을 추출하시오.
*/
select * from employees where last_name='Smith' and salary=8000;
--주의 : 컬럼이 문자형인경우 반드시 싱글쿼테이션을 사용해야 한다.
select * from employees where last_name=Smith and salary=8000;--에러발생
-- 컬럼이 숫자형이면 안쓰는게 기본이다. 하지만 쓰더라도 자동으로 제거된다.
select * from employees where last_name='Smith' and salary='8000';

/*
비교연산자를 통한 쿼리문작성
    : 이상, 이하와 같은 조건에 >, <= 와 같은 비교연산자를 사용할 수 있다.
    날짜인 경우 이후의 날짜와 같은 조건도 가능하다.
*/
--급여가 5000미만인 사원의 정보를 추출하시오.
select * from employees where salary<5000;
--입사일이 04년01월01일 이후인 사원 정보를 추출하시오.
select * from employees where hire_date>='04/01/01';

/*
in연산자
    : or연산자와 같이 하나의 컬럼에 여러개의 값으로 조건을 걸고싶을때
    사용한다.
    -> 급여가 4200, 6400, 8000인 사원의 정보를 추출하시오.
*/
--방법1 : or를 사용한다. 이때 컬럼명을 반복적으로 기술해야 하므로 불편하다.
select * from employees where salary=4200 or salary=6400 or salary=8000;
--방법2 : in을 사용하면 컬럼명은 한번만 기술하면 되므로 편리하다.
select * from employees where salary in (4200, 6400, 8000);

/*
not연산자
    : 해당 조건이 아닌 레코드를 추출한다.
    -> 부서번호가 50이 아닌 사원정보를 조회하는 SQL문을 작성하시오
*/
select * from employees where department_id<>50;
select * from employees where not (department_id=50);

/*
between and 연산자
    : 컬럼의 구간을 정해 검색할때 사용한다.
    -> 급여가 4000~8000 사이의 사원정보를 조회하시오.
*/
select * from employees where salary>=4000 and salary<=8000;
select * from employees where salary between 4000 and 8000;

/*
distinct
    : 컬럼에서 중복되는 레코드를 제거할때 사용한다.
    특정 조건으로 select했을때 하나의 컬럼에서 중복되는 값이 있는경우
    중복값을 제거한 후 결과를 출력할 수 있다.
    -> 담당업무 아이디를 중복을 제거한 후 출력하시오
*/
--전체 사원에 대한 담당업무명이 인출됨
select job_id from employees;
--중복이 제거되어 19개의 담당업무명이 인출됨
select distinct job_id from employees;

/*
like연산자
     : 특정 키워드를 통한 문자열 검색하기
     형식] 컬렴명 like '%검색어%'
     와일드카드 사용법
        % : 모든 문자 혹은 문자열을 대체한다.
        Ex) D로 시작되는 단어 : D% => Da, Dae, Daewoo
            z로 끝나는 단어 : %Z => aZ, abxZ
            C가 포함되는 단어 : %C% -> aCb, abCde, vitamin-C
        _ : 언더바는 하나의 문자를 대체한다.
        EX) D로 시작하는 3글자의 단어 : D__ => Dab , Ddd , Dxy
            A가 중간에 들어가는 3글자의 단어 : _A_ -> aAa, xAy
*/
--first_name이 'D'로 시작하는 직원을 검색하시오.
select * from employees where first_name like '%D%';
--first_name의 세번째문자가 a인 직원을 추출하시오.
select * from employees where first_name like '__a%';
--last_name에서 y로 끝나는 직원을 추출하시오.
select * from employees where last_name like '%y';
--전화번호에 1344가 포함된 직원 전체를 인출하시오.
select * from employees where phone_number like '%1344%';

/*
레코드 정렬하기(Sorting)
    오름차순 정렬 : order by 컬럼명 asc (혹은 생략가능)
    내림차순 정렬 : order by 컬럼명 desc
    
    2개이상의 컬럼으로 정렬해야 할 경우 콤마로 구분해서 정렬한다.
    단, 이때 먼저 입력한 컬럼으로 정렬된 상태에서 두번째 컬럼이 정렬된다.
*/
/*
사원정보 테이블에서 급여가 낮은 순서에서 높은 순서로 나오도록 정렬하여 조회하시오.
출력할컬럼 : first_name, salary, email, phone_number
*/
select first_name, salary, email, phone_number from employees
    order by salary asc;
    
/*
부서번호를 내림차순으로 정렬한 후 해당 부서에서 낮은 급여를 받는 직원이 먼저
출력되도록 하는 SQL문을 작성하시오.
출력항목 : 사원번호, 이름, 성, 급여, 부서번호
*/
select employee_id, first_name, last_name, salary, department_id
from employees
order by department_id desc, salary asc;

/*
is null 혹은 is not null
    : 값이 null이거나 null이 아닌 레코드 가져오기.
    컬럼중 null값을 허용하는 경우 값을 입력하지 않으면 null값이
    되는데 이를 대상으로 select 할때 사용한다.
*/
--보너스율이 없는 사원을 조회하시오
select * from employees where commission_pct is null;
--영업사원이면서 급여가 8000이상인 사원을 조회하시오
select * from employees where salary>=8000
    and commission_pct is not null;
    
-----------------------------------------------------------------------------
/*
1. 덧셈 연산자를 이용하여 모든 사원에 대해서 $300의 급여인상을 계산한후
이름, 급여, 인상된 급여를 출력하시오.
*/

select * from emp;
select ENAME, SAL, SAL+300 from EMP;
select ENAME, SAL, (SAL+300) AS "RiseSalary" from emp;

/*
2. 사원의 이름, 급여, 연봉을 수입이 많은것부터 작은순으로 출력하시오. 
연봉은 월급에 12를 곱한후 $100을 더해서 계산하시오.
*/

select ENAME, SAL, SAL*12+100"연봉" from EMP
    order by SAL desc;
    
select ENAME, SAL, (SAL*12+100)"연봉"from EMP;
--정렬시 물리적으로 존재하는 컬럼명을 사용하는게 기본이다.
select ENAME, SAL, (SAL*12+100)"연봉"from EMP order by SAL desc;
--물리적으로 존재하지 않는 컬럼이라면 계산식 그대로를 order by 절에 기술한다.
select ENAME, SAL, (SAL*12+100)"연봉"from EMP order by (SAL*12+100) desc;
select ENAME, SAL, (SAL*12+100)"연봉"from EMP order by "연봉" desc;
/*    
3. 급여가  2000을 넘는 사원의 이름과 급여를 내림차순으로 정렬하여 출력하시오
*/

select ENAME, SAL from EMP
    where SAL>=2000
    order by ENAME desc, SAL desc;

/*
4. 사원번호가  7782인 사원의 이름과 부서번호를 출력하시오.
*/

select ENAME, DEPTNO, from EMP where EMPNO=7782;

/*
5. 급여가 2000에서 3000사이에 포함되지 않는 사원의 이름과 급여를 출력하시오.
*/

select ENAME, SAL from EMP where not SAL between 2000 and 3000 
    order by SAL asc;
select ENAME, SAL from EMP where not (SAL between 2000 and 3000);
select ENAME, SAL from EMP where not (SAL>=2000 and SAL<=3000);
    

/*
6. 입사일이 81년2월20일 부터 81년5월1일 사이인 사원의 이름, 담당업무, 입사일을 출력하시오.
*/

select ENAME, JOB, HIREDATE from EMP
    where HIREDATE between '81/02/20' and '81/05/01';
select ENAME, JOB, HIREDATE from EMP
    where HIREDATE>='81/02/20' and HIREDATE<='81/05/01';

/*
7. 부서번호가 20 및 30에 속한 사원의 이름과 부서번호를 출력하되 이름을 기준(내림차순)으로 출력하시오
*/

select ENAME, DEPTNO from EMP where DEPTNO between 20 and 30 order by ENAME desc;

select ENAME, DEPTNO from EMP where DEPTNO=20 or DEPTNO=30 order by ENAME desc;
select ENAME, DEPTNO from EMP where DEPTNO in (20,30) order by ENAME desc;
/*
8. 사원의 급여가 2000에서 3000사이에 포함되고 부서번호가 20 또는 30인 사원의 이름,
급여와 부서번호를 출력하되 이름순(오름차순)으로 출력하시오
*/

select ENAME, SAL, DEPTNO from EMP 
where SAL between 2000 and 3000 and DEPTNO between 20 and 30
    order by ENAME asc;
    
select ENAME, SAL, DEPTNO from EMP
    where (SAL between 2000 and 3000) and DEPTNO in (20,30)
    order by ENAME asc;
/*
9. 1981년도에 입사한 사원의 이름과 입사일을 출력하시오. (like 연산자와 와일드카드 사용)
*/

select ENAME, HIREDATE from EMP where HIREDATE like '%81%';


/*
10. 관리자가 없는 사원의 이름과 담당업무를 출력하시오. 
*/

select ENAME, JOB from EMP where MGR is null;


/*
11. 커미션을 받을수 있는 자격이 되는 사원의 이름, 급여, 커미션을
출력하되 급여 및 커미션을 기준으로 내림차순으로 정렬하여 출력하시오.
*/ -- 값이 0인것은 where로 

select ENAME, SAL, COMM 
from EMP where COMM is not null
   order by SAL DESC, COMM desc;


/*
12. 이름의 세번째 문자가 R인 사원의 이름을 표시하시오.
*/

select ENAME from EMP where ENAME like '__R%';



/*
13. 이름에 A와 E를 모두 포함하고 있는 사원의 이름을 표시하시오.
*/

select ENAME from EMP where ENAME like '%A%' and ENAME like '%E%';
/*
아래와 같은 경우 A와 E가 포함되긴 하나 순서가 있으므로 E로 시작하고 A가 나오는
이름은 검색되지 않는다. */
--select ENAME FROM EMP where ENAME like '%A%E%'; 순서가 있을때


/*
14. 담당업무가 사무원(CLERK) 또는 영업사원(SALESMAN)이면서 
급여가 $1600, $950, $1300 이 아닌 사원의 이름, 담당업무, 급여를 출력하시오. 
*/

select ENAME, JOB, SAL
from EMP 
where JOB in ('CLERK','SALESMAN') and SAL not in (1600, 950, 8000);

/*
15. 커미션이 $500 이상인 사원의 이름과 급여 및 커미션을 출력하시오. 
*/

select ENAME, SAL, COMM from EMP where COMM>=500;

