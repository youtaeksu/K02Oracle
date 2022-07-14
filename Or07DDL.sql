/*****************************
파일명 : Or07DDL.sql
DDL : Data Definition Language(데이터 정의어)
설명 : 테이블, 뷰와 같은 객체를 생성 및 변경하는 쿼리문을 말한다.
*****************************/

/*
system계정으로 연결한 후 아래 명령을 실행한다.
새로운 사용자 계정을 생성한 후 접속권한과 테이블생성 등의 권한을 부여한다.
*/
--study 계정을 생성하고, 패스워드는 1234로 부여한다.
create user study identified by 1234;
--생성한 계정에 권한을 부여한다.
grant connect, resource to study;


-------------------------------------------------------
--study계정을 연결한 후 실습을 진행합니다.

--모든 계정에 존재하는 논리적인 테이블.
select * from dual;

--해당 계정에 생성된 테이블의 목록을 저장한 시스템테이블
select * from tab;


/*
테이블생성
형식]
    create table 테이블명 (
        컬럼명1 자료형,
        컬럼명2 자료형,
        .....
        primary key(컬럼명) 등의 제약조건 추가
    );
*/

create table tb_member(
    idx number(10),/* 10자리의 정수를 표현*/
    userid varchar2(30),/* 문자형으로 30byte 저장가능*/
    passwd varchar2(50),
    username varchar2(30),
    mileage number(7,2)/* 실수 표현.전체 7자리, 소수 2자리 표현*/
);
--현재 접속한 계정에 생성된 테이블 목록을 확인
select *from tab;
--테이블의 구조(스키마)확인. 컬럼명,자료형,크기 등을 확인할 수 있다.
desc tb_member;

/*
DDL문 정의어 -> Table(생성/수정/삭제),사용자,view 
DML문 조작어   
DCL문 제어어
(순서:DCL-DDL-DML)
*/

/*
기존 생성된 테이블에 새로운 컬럼 추가하기
->tb_member 테이블에  email 컬럼을 추가하시오

형식]alter table 테이블명 add 추가할 컬럼 자료형(크기) 제약조건;
*/
alter table tb_member add email varchar2(100);

/*
기존 생성된 테이블에 새로운 컬럼 수정하기
->tb_member 테이블의  email 컬럼의 사이즈를 200으로 확장하시오.
또한 이름이 저장되는 username컬럼도 60으로 확장하시오
*/
alter table tb_member modify email varchar2(200);
alter table tb_member modify username varchar2(60);
desc tb_member;
/*
기존 생성된 테이블에서 컬럼삭제하기
->tb_member테이블의 mileage 컬럼을 삭제하시오

형식]alter table 테이블명 drop column 삭제할 컬럼명;
*/
alter table tb_member drop column mileage;
desc tb_member;

/*
퀴즈]테이블 정의서로 작성한 employees테이블을 해당 study 계정에 그대로 
생성하시오.단,제략조건은 명시하지 않습니다
*/
create table employees (
    employee_id number(6), 
    first_name varchar2(20), 
    last_naeme varchar2(25), 
    email varchar2(25),
    phone_number varchar2(20),
    hire_date date,
    job_id varchar2(10),
    salary number(8,2),
    commission_pct number(2,2),
    manager_id number(6),
    department_id number(4)
);

/*
테이블 삭제하기
->employees 테이블은 더이상 사용하지 않으므로 삭제하시오
형식]drop table 삭제할 테이블명
*/
select *from tab;
drop table employees;
select *from tab;--삭제 후 테이블 목록 확인(tb_member 테이블만 존재함)
desc employees;--객체가 존재하지 않는다는 오류 발생됨



--tb_member 테이블에 새로운 레코드 삽입하기(DML문에서 학습할 예정)
insert into tb_member values(1,'hong','1234','홍길동','hong@naver.com');
insert into tb_member values(2,'yu','9876','유비','yoo@daum.net');
--삽입된 레코드 확인
select*from tb_member;
select*from tb_member where idx=2;

--테이블 복사하기1 : 레코드까지 함께 복사
/*
select문을 기술핼때 where절이 없으면 모든 레코드를 출력하라는
명령이므로 아래에서는 모든 레코드를 가져와서 복사본 테이블을 생성한다
즉, 레코드까지 복사된다
*/
create table tb_member_copy
as
select * from tb_member;
--복사된 테이블 확인하기
select * from tb_member_copy;

--테이블 복사하기2 : 레코드는 제외하고 테이블 구조만 복사

create table tb_member_empty
as
select * from tb_member where 1=0;
desc tb_member_empty;
select * from tb_member_empty;

/*
DDL문 :  테이블을 생성 및 조작하는 쿼리문
    
    (Data Definition Language :  데이터 정의어)
    테이블 생성 : create table 테이블명
    테이블 수정
        컬럼추가 : alter table 테이블명 add컬럼명
        컬럼수정 : alter table 테이블명 modify 컬럼명
        컬럼삭제 : alter table 테이블명 drop column컬럼명
    테이블 삭제 : drop table 테이블명
*/

-------------------------------------------------------

/*
1. 다음 조건에 맞는 “pr_dept” 테이블을 생성하시오.
*/


create table pr_dept(
    dno number(2),
    dname varchar2(20),
    loc varchar2(35)
);
select *from tab;
desc pr_dept;


/*
2. 다음 조건에 맞는 “pr_emp” 테이블을 생성하시오.
*/


create table pr_emp(
    eno number(4),
    ename varchar2(10),
    job varchar2(30),
    regist_date date
);
select *from tab;
desc pr_emp;


/*
3. pr_emp 테이블의 ename 컬럼을 varchar2(50) 로 수정하시오.
*/


alter table pr_emp modify ename varchar2(50);
desc pr_emp;


/*
4. 1번에서 생성한 pr_dept 테이블에서 dname 칼럼을 삭제하시오.
*/


alter table pr_dept drop column dname;
desc pr_dept;


/*
5. “pr_emp” 테이블의 job 컬럼을 varchar2(50) 으로 수정하시오.
*/


alter table pr_emp modify job varchar2(50);
desc pr_emp;
