/******************
파일명 : Or10SubQuery.sql
서브쿼리
설명 : 쿼리문안에 또 다른 쿼리문이 들어가는 형태의 select문
*******************/

/*
단일행 서브쿼리
    형식]
        select * from 테이블명 where 컬럼=(
            select 컬럼 from 테이블명 where 조건
        );
    ※ 괄호안의 서브쿼리는 반드시 하나의 결과를 인출해야 한다. 
*/

/*
시나리오] 사원테이블에서 전체사원의 평균급여보다 낮은 급여를 받는 사원들을 
추출하여 출력하시오.
    출력항목 : 사원번호, 이름, 이메일, 연락처, 급여
*/
--평균급여 구하기:6461
select avg(salary) from employees;
--해당 쿼리문은 문맥상 맞는듯하지만 그룹함수를 단일행에 적용한 잘못된 쿼리문이다. 
select * from employees where salary<avg(salary);--에러발생
--앞에서 구한 평균급여를 조건으로 select문 구성
select * from employees where salary<6461;
--2개의 쿼리문을 하나의 서브쿼리문으로 병합
select * from employees where salary<(select avg(salary) from employees);

/*
시나리오] 전체 사원중 급여가 가장적은 사원의 이름과 급여를 출력하는 
서브쿼리문을 작성하시오.
출력항목 : 이름1, 이름2, 이메일, 급여
*/
--1단계 : 최소급여확인
select min(salary) from employees;
--2단계 : 2100을 받는 직원 인출
select * from employees where salary=2100;
--3단계 : 쿼리문 병합
select * from employees where salary=(select min(salary) from employees);

/*
시나리오] 평균급여보다 많은 급여를 받는 사원들의 명단을 조회할수 있는 
서브쿼리문을 작성하시오.
출력내용 : 이름1, 이름2, 담당업무명, 급여
※ 담당업무명은 jobs 테이블에 있으므로 join해야 한다. 
*/
--1단계:평균급여
select round(avg(salary)) from employees;
--2단계:join
select first_name, last_name, job_title, salary 
from employees inner join jobs using(job_id)
where salary>6462;
--3단계:병합
select first_name, last_name, job_title, salary 
from employees inner join jobs using(job_id)
where salary>(select round(avg(salary)) from employees);


/*
복수행 서브쿼리
    형식]
        select * from 테이블명 where 컬럼 in (
            select 컬럼 from 테이블명 where 조건
        );
    ※ 괄호안의 서브쿼리는 2개 이상의 결과를 인출해야 한다.
*/
/*
시나리오] 담당업무별로 가장 높은 급여를 받는 사원의 명단을 조회하시오.
    출력목록 : 사원아이디, 이름, 담당업무아이디, 급여
*/
--1단계 : 담당업무별 가장 높은 급여 확인
select job_id, max(salary) from employees
group by job_id;
--2단계 : 위의 결과를 단순한 or조건으로 묶어본다. 
select
     employee_id, first_name, job_id, salary
from employees
where 
    (job_id='IT_PROG' and salary=9000) or
    (job_id='AC_MGR' and salary=12008) or
    (job_id='AC_ACCOUNT' and salary=8300) or
    (job_id='ST_MAN' and salary=8200);--원래는 19개의 or절이 필요하지만 4개만 기술함.
--3단계 : 복수행 연산자를 통해 서브쿼리로 병합한다. 
select
     employee_id, first_name, job_id, salary
from employees
where 
    (job_id, salary) in (
        select job_id, max(salary) from employees
        group by job_id
    );


/*
복수행 연산자2 : any
    메인쿼리의 비교조건이 서브쿼리의 검색결과와 하나이상
    일치하면 참이 되는 연산자. 즉 둘중 하나만 만족하면 해당
    레코드를 가져온다. 
*/
/*
시나리오] 전체사원중에서 부서번호가 20인 사원들의 급여보다 높은 급여를 받는 
    직원들을 추출하는 서브쿼리문을 작성하시오. 둘중 하나만 만족하더라도 인출하시오.
*/
--1.20번 부서의 급여를 확인
select first_name, salary from employees where department_id=20;
--2.1의 결과를 단순 쿼리로 작성
select first_name, salary from employees 
where salary>13000 or salary>6000;
--3.둘중 하나만 만족하면 레코드를 인출할것이므로 any를 이용해서 서브쿼리 작성
select first_name, salary from employees 
where salary>any(select salary from employees where department_id=20);
/*
    복수행 연산자 any를 사용하면 2번과 같이 or 조건으로 결과를 연결하게된다.
    6000 또는 13000 이상인 레코드를 인출한다. 
*/

/*
복수행연산자3 : all
    메인 쿼리의 비교조건이 서브쿼리의 검색결과와 모두 일치해야
    레코드를 인출한다. 
*/
/*
시나리오] 전체사원중에서 부서번호가 20인 사원들의 급여보다 높은 급여를 받는 
    직원들을 추출하는 서브쿼리문을 작성하시오. 둘다 만족하는 레코드만 인출하시오.
*/
select first_name, salary from employees 
where salary>all(select salary from employees where department_id=20);
/*
    6000이상이고 동시에 13000보다도 커야하므로 결과적으로 13000이상인
    레코드만 인출하게 된다. 
*/

/*
rownum : 테이블에서 레코드를 조회한 순서대로 순번이 부여되는 가상의
    컬럼을 말한다. 해당 컬럼은 모든 테이블에 논리적으로 존재한다. 
*/
--모든 계정에 논리적으로 존재하는 테이블
select * from dual;
--레코드의 정렬없이 모든 레코드를 가져와서 rownum을 부여한다.(rownum이 순서대로 나옴)
select first_name, rownum from employees;
--이름의 오름차순으로 정렬한 후 출력한다.(rownum이 섞여져 이상하게 나옴)
select first_name, rownum from employees order by first_name;
/*
    rownum을 우리가 정렬한 순서대로 재부여하기 위해 서브쿼리를 사용한다. 
    from절에는 테이블이 들어와야 하는데, 아래의 서브쿼리에서는 사원테이블의 
    전체레코드를 대상으로 하되 이름으로 정렬된 상태로 레코드를 가져와서 테이블처럼
    사용한다. 
*/
select first_name, rownum from 
    (select * from employees order by first_name asc);

--사원테이블에서 rownum을 통해 정해진 구간을 아래와같이 가져올수 있다. 
select * from 
    (select tb.*, rownum rNum from 
        (select * from employees order by first_name asc) tb)
--where rNum between 1 and 10;
--where rNum between 11 and 20;
where rNum>=21 and rNum<=30;
/*
    between의 구간을 위와같이 변경해주면 해당 페이지의 레코드만 추출하게 된다. 
    위의 구간은 차후 JSP에서 여러가지 변수를 조합하여 계산하게된다. 
    게시판 페이징에서 위 쿼리문을 그대로 사용한다. 

    3.2의 결과 전체를 select절에서 가져온 다음..    
        (2.1의 결과 레코드에 rownum을 부여한다. 정렬한데로 재부여됨. 
            (1.사원테이블의 전체 레코드를 오름차순으로 정렬해서 인출) tb
        )
    4.필요한 부분을 between이나 비교연산자로 구간을 정해 인출한다. 
    1페이지 : 1~10
    2페이지 : 11~20과 같이 구간을 정한다. 
*/

------------------------------------------------------------
--scott 계정에서 진행합니다--
/*
01.사원번호가 7782인 사원과 담당 업무가 같은 사원을 표시(사원이름과 담당 업무)하시오.
*/
--사원번호 구하기:7782
select job from emp where empno=7782;
--담당업무가 같은 사원 표시(사원 이름과 담당업무)
select ename, job
from emp where job='manager';
--쿼리문 병합
select * from emp 
where job = (select job from emp where empno=7782);
--사원 이름과 담당업무
select ename, job
from emp 
where job = (select job from emp where empno=7782);

------------------------------------------------------
select * from emp where empno=7782;--7782사원의 담당업무 확인
select * from emp where job='MANAGER';
select * from emp where job=(select job from emp where empno=7782);


/*
02.사원번호가 7499인 사원보다 급여가 많은 사원을 표시(사원이름과 담당 업무)하시오.
*/

--사원번호가 7499인 사원의 급여
select sal from emp where empno=7499;
--급여 1600, 사원보다 급여가 많은 사원(사원 이름과 담당 업무)
select ename, job, sal
from emp where sal>1600;
--쿼리문 병합
select * from emp
where sal>(select sal from emp where empno=7499);
--사원 이름과 담당업무
select ename, job
from emp
where sal>(select sal from emp where empno=7499);

-----------------------------------------------------------------
select * from emp where empno=7499;--7499의 급여 확인
select * from emp where sal>1600;
select * from emp where sal>(select sal from emp where empno=7499);


/*
03.최소 급여를 받는 사원의 이름, 담당 업무 및 급여를 표시하시오(그룹함수 사용).
*/
--최소 급여를 받는 사원의 이름
select min(sal) from emp;
--최소 급여 : 800인 사원의 이름 담당 업무 및 급여 
select empno, ename, job, sal 
from emp where sal = 800;
--병합
select empno, ename, job, sal
from emp where sal = (select min(sal) from emp);

--------------------------------------------------------------------

select min(sal) from emp;
select * from emp where sal=800;
select empno, ename, job, sal from emp where sal=(select min(sal) from emp);


/*
04.평균 급여가 가장 적은 직급(job)과 평균 급여를 표시하시오.
*/
--각 직급 평균 급여
select job, avg(sal) from emp group by job;
--평균급여가 가장 적은 직급
select job, avg(sal)
from emp group by job
having avg(sal)=(select min(avg(sal)) from emp group by job);

---------------------------------------------
--직급별 평균급여 인출
select job, avg(sal) from emp group by job;
--에러발생. 그룹함수를 2개 겹쳤기 때문에 job컬럼을 제외해야 한다.
select job, min(avg(sal)) from emp group by job;
--정상실행. 직급중 평균급여가 최소인 레코드 인출
select min(avg(sal)) from emp group by job;
/*
평균급여는 물리적으로 존재하는 컬럼이 아니므로 where 절에는 사용할수없고
having절에 사용해야 한다. 즉, 평균급여가 1017인 직급을 출력하는 방식으로
서브쿼리를 작성해야 한다.
*/
select 
    job, avg(sal)
from emp
group by job
having avg(sal) = (select min(avg(sal)) from emp group by job);

/*
05.각부서의 최소 급여를 받는 사원의 이름, 급여, 부서번호를 표시하시오.
*/
--각부서 최소 급여
select deptno, min(sal) from emp group by deptno;
--사원의 이름, 급여, 부서번호 출력
select ename, sal, deptno
from emp
where
    (deptno = 30 and sal=950) or
    (deptno = 20 and sal=800) or
    (deptno = 10 and sal=1300);
--병합
select ename, sal, deptno 
from emp
where 
(deptno, sal)
   in (select deptno, min(sal) from emp group by deptno);

---------------------------------------------------------

--단순 정렬을 통해 부서별 급여 확인
select deptno, sal from emp order by deptno, sal;
--그룹함수를 통해 부서별 최소급여 확인
select deptno, min(sal) from emp group by deptno;
--단순 or절을 통한 인출
select ename, sal, deptno from emp
    where (deptno = 30 and sal=950) 
        or (deptno = 20 and sal=800) 
        or (deptno = 10 and sal=1300);
--서브쿼리의 복수행 연산자를 통해 쿼리 작성
select ename, sal, deptno from emp
    where (deptno, sal) in (select deptno, min(sal) from emp group by deptno);


   
/*
06.담당 업무가 분석가(ANALYST)인 사원보다 급여가 적으면서 
업무가 분석가(ANALYST)가 아닌 사원들을 표시(사원번호, 이름, 담당업무, 급여)하시오.
*/
--담당 업무가 분석가 급여 //3000
select sal from emp where job = 'ANALYST';
--담당 업무가 분석가가 아닌 사원들 
select empno, ename, job, sal from emp where not(job='ANALYST');
--쿼리문 병합, 분석가인 사원보다 급여가 적음
select empno, ename, job, sal
from emp where sal < all (select sal from emp where job = 'ANALYST');

-------------------------------------------------------------
select * from emp where job='ANALYST';
select * from emp where sal<3000 and job<>'ANALYST';
/*
    ANALYST 직무를 통한 결과가 1개이므로 아래와 같이 단일행 연산자로 서브쿼리를
    만들수 있지만, 만약 결과가 2개이상이라면 복수행 연산자 all 혹은 any를 
    추가해야 한다.
*/
select * from emp where sal<(select sal from emp where job='ANALYST')
    and job<>'ANALYST';
    
/*
07.이름에 K가 포함된 사원과 같은 부서에서 일하는 사원의 사원번호와 
이름을 표시하는 질의를 작성하시오
*/

select * from emp where ename like '%K%';
select * from emp where deptno in (30, 10);
/*
    or조건을 in으로 표현할 수 있으므로, 서브쿼리에서 복수행 연산자인
    in을 사용한다. 2개 이상의 결과를 or로 연결하여 출력하는 기능을 가진다.
*/
select * from emp where deptno in (select deptno from emp where ename like '%K%');


/*
08.부서 위치가 DALLAS인 사원의 이름과 부서번호 및 담당 업무를 표시하시오.
*/

select * from dept where loc = 'DALLAS';
select * from emp where deptno=20;
select * from emp where deptno=(select deptno from dept where loc = 'DALLAS');



/*
09.평균 급여 보다 많은 급여를 받고 이름에 K가 포함된 사원과 
같은 부서에서 근무하는 사원의 사원번호, 이름, 급여를 표시하시오.
*/

--평균급여
select avg(sal) from emp;--2077.xxx
--K가 포함된 사원
select * from emp where ename like '%K%';
--단순 조건으로 쿼리작성
select * from emp
where sal>2077 and deptno in (30,10);
--서브쿼리문으로 작성
select * from emp
where sal>(select avg(sal) from emp) and
    deptno in (select deptno from emp where ename like '%K%');
    

/*
10.담당 업무가 MANAGER인 사원이 소속된 부서와 동일한 부서의 사원을 표시하시오.
*/

select * from emp where job='MANAGER';--10,30,20
select * from emp where deptno in (select deptno from emp where job='MANAGER');



/*
11.BLAKE와 동일한 부서에 속한 사원의 이름과 입사일을 표시하는 질의를 작성하시오(단. BLAKE는 제외)
*/

select * from emp where ename='BLAKE';
select * from emp where deptno=30 and ename<>'BLAKE';
select ename, hiredate from emp
where deptno=(select deptno from emp where ename='BLAKE') and ename<>'BLAKE';

















 
 
 
 
 
