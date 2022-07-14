/*
Java에서 처음으로 JDBC프로그래밍 해보기
*/
--우선 system계정을 연결한 후 새로운 계정을 생성한다.
CREATE USER kosmo IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE TO kosmo;

--계정을 생성한 후 접속창에 kosmo 계정을 등록하고 해당 문서에 연결한다.
--회원관리 테이블 : member 생성
CREATE TABLE member
(
	id VARCHAR2(30) NOT NULL,
	pass VARCHAR2(40) NOT NULL,
	name VARCHAR2(50) NOT NULL,
	regidate DATE DEFAULT SYSDATE,
	PRIMARY KEY (id)
);

--더미데이터 입력하기
insert into member (id, pass, name) values ('test4', '1234', '테스트');
select * from member;
commit;

/*
오라클 내부에서 생긴 레코드의 변화는 외부(Java)에서 즉시 확인할 수 없다.
반드시 commit명령을 통해 임시테이블의 내용을 실제 테이블로 옮기는 작업이 필요하다.
즉, insert, update, delete를 수행한 이후에는 commit해야 한다.
*/
insert into member (id, pass, name) values ('dummy', '1234', '나는더미');
select * from member;
commit;

update member set pass='9x9x' where id='test2';
select * from member;
commit;

--해당 계정에 생성된 제약조건 확인
select * from user_constraints;

--like를 이용한 검색 쿼리
select * from member where name like '%수%';




--------------------------------------------------------------
--JDBC > CallableStatement 인터페이스 사용하기

--substr(문자열 혹은 컬럼, 시작인덱스, 길이) : 시작인덱스부터 길이만큼 잘라낸다.
select substr('hongildong',1,1) from dual;
--rpad(문자열 혹은 컬럼, 길이, 문자) : 문자열의 남은 길이만큼을 문자로 채워준다.
select rpad('h', 10, '*') from dual;
--문자열(아이디)의 첫글자를 제외한 나머지 부분을 *로 채워준다.
select rpad(substr('hongildong',1,1), length('hongildong'), '*') from dual;
/*
시나리오]매개변수로 회원아이디(문자열)을 받으면 첫문자를 제외한 나머지부분을
    *로 변환하는 함수를 생성하시오
    실행 예) kosmo -> k****
*/
create or replace function fillAsterik (
    idStr varchar2) /* 매개변수는 문자형으로 설정 */
return varchar2 /* 반환값 문자형으로 설정*/
is retStr varchar2(50); /* 변수생성 : 반환값을 저장할것임 */
begin
    --문자열의 우측부분을 *로 채워준다.
    retStr := rpad(substr(idStr,1,1), length(idStr), '*');
    return retStr;
end;
/

select fillAsterik('hongildong') from dual;
select fillAsterik('nakja') from dual;

select * from employees where employee_id=100;
select fillAsterik(first_name) from employees where employee_id=100;


/*
시나리오] member 테이블에 새로운 회원정보를 입력하는 프로시저를 생성하시오.
    입력값 : 아이디, 패스워드, 이름
*/
create or replace procedure KosmoMemberInsert (
        p_id in varchar2,
        p_pass in varchar2,
        p_name in varchar2, /* Java에서 전달한 인자를 받을 인파라미터 */
        returnVal out number /* 입력성공여부 확인 */
    )
is
begin
    --인파라미터를 통해 insert 쿼리문 작성
    insert into member (id, pass, name)
        values (p_id, p_pass, p_name);
    
    --입력이 정상적으로 처리되었다면...        
    if sql%found then
        --성공한 행의 갯수를 얻어와서 아웃파라미터에 저장한다.
        returnVal := sql%rowcount;
        commit;
    else
        --실패한 경우에는 0을 반환한다.
        returnVal := 0;
    end if;
end;
/
set serveroutput on;
--바인드 변수 생성
select * from user_source where name like upper('%kosmomem%');
var insert_count number;
--프로시저 실행
execute KosmoMemberInsert('pro1','p1234','프로시저1',:insert_count);
--결과확인
print insert_count;
--입력된 회원정보 확인
select * from member;

/*
시나리오] member테이블에서 레코드를 삭제하는 프로시저를 생성하시오.
    매개변수 : In => member_id(아이디)
               Out => returnVal(SUCCESS/FAIL 반환)
*/
create or replace procedure KosmoMemberDelete (
        member_id in varchar2,
        returnVal out varchar2
    )
is --변수가 필요없는 경우 생략가능
begin
    --인파라미터를 통해 delete쿼리문 작성
    delete from member where id=member_id;
    
    if SQL%Found then
        --회원레코드가 정상적으로 삭제되었다면
        returnVal := 'SUCCESS';
        --커밋한다.
        commit;
    else
        --조건에 일치하는 레코드가 없는경우 FAIL을 반환한다.
        returnVal := 'FAIL';
    end if;
end;
/
set serveroutput on;
var delete_var varchar2(10);
execute KosmoMemberDelete('ppp', :delete_var);
execute KosmoMemberDelete('test', :delete_var);
print delete_var;

/*
시나리오] 아이디와 패스워드를 매개변수로 전달받아서 회원인지 여부를
판단하는 프로시저를 작성하시오. 

    매개변수 : 
        In -> user_id, user_pass
        Out -> returnVal
    반환값 : 
        0 -> 회원인증실패(둘다틀림)
        1 -> 아이디는 일치하나 패스워드가 틀린경우
        2 -> 아이디/패스워드 모두 일치하여 회원인증 성공
    프로시저명 : KosmoMemberAuth
*/
create or replace procedure KosmoMemberAuth (
    user_id in varchar2,
    user_pass in varchar2,
    returnVal out number
)
is
    -- count(*)를 통해 반환되는 값을 저장한다.
    member_count number(1) := 0;
    -- 조회한 회워정보의 패스워드를 저장한다.
    member_pw varchar2(50);
begin
    --해당 아이디가 존재하는지 판단하는 select문 작성
    select count(*) into member_count
    from member where id=user_id;
    
    --회원아이디가 존재하는 경우
    if member_count=1 then
        --패스워드 확인을 위해 두번째 쿼리를 실행
        select pass into member_pw 
            from member where id=user_id;
        
        --인파라미터로 전달된 비번과 DB에서 가져온 비번을 비교
        if member_pw=user_pass then
            returnVal := 2; --아이디/비번 모두 일치
        else
            returnVal := 1; --비번틀림
        end if;
    else
        returnVal := 0; --회원정보가 없음
    end if;
end;
/
--둘다일치, 아이디만 일치, 정보없음의 3가지 케이스를 모두 테스트 해볼것
variable member_auth number;
execute KosmoMemberAuth('test', '1234', :member_auth);
print member_auth;

execute KosmoMemberAuth('yugyeom', '1234패스워드틀림', :member_auth); 
print member_auth;

execute KosmoMemberAuth('yugyeom아이디틀림', '1234패스워드틀림', :member_auth); 
print member_auth;




/*
JSP에서 JDBC 실습하기
-새로운 계정 생성 및 권한 부여하기
*/

--System계정으로 변경한 후 계정생성과 권한을 부여해 주세요.

--계정 생성
CREATE USER musthave IDENTIFIED BY 1234;
--Role(롤)을 통해서 접속권한과 테이블생성 권한 부여
GRANT CONNECT, RESOURCE TO musthave;

--새 계정으로 오라클 접속
conn musthave/1234;

--테이블 목록 조회
select * from tab;

/* 실수로 system계정에 테이블을 생성했다면 삭제합니다. */
drop table member;
drop table board;
drop sequence seq_board_num;

--musthave 계정으로 변경한 후 테이블 및 외래키를 생성해 주세요.

--회원관리 테이블
create table member (
    id varchar2(10) not null,
    pass varchar2(10) not null,
    name varchar2(30) not null,
    regidate date default sysdate not null,
    primary key (id)
);

--게시판 테이블(모델1 방식에서 사용)
create table board (
    num number primary key,
    title varchar2(200) not null,
    content varchar2(2000) not null,
    id varchar2(10) not null,
    postdate date default sysdate not null,
    visitcount number(6)
);

--board테이블이 member테이블을 참조하는 외래키(참조키) 생성
alter table board
    add constraint board_mem_fk foreign key (id)
    references member (id);
    
--시퀀스 생성(게시판 일련번호 입력시 자동증가값으로 사용함)
create sequence seq_board_num
    increment by 1
    start with 1
    minvalue 1
    nomaxvalue 
    nocycle
    nocache;
    
--더미 데이터 입력하기
insert into member (id, pass, name) values ('musthave','1234','머스트해브');
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '제목2입니다', '내용2입니다', 'musthave', sysdate, 0);
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '제목3입니다', '내용3입니다', 'musthave', sysdate, 0);
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '제목4입니다', '내용4입니다', 'musthave', sysdate, 0);
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '제목5입니다', '내용5입니다', 'musthave', sysdate, 0);
commit;



/*
JSP Model1 방식의 회원제 게시판 개발하기 
*/
--목록(List) : 게시물 카운트하기
--게시물 전체 카운트
select count(*) from board;
--검색했을때의 카운트
select count(*) from board where title like '%제목3%';

--목록(List) : 게시물 출력하기
--  최근에 작성한 게시물을 상단에 노출하기 위해 일련번호(num)의 내림차순으로 정렬한다.
select * from board order by num desc;
--검색어가 있는 경우
select * from board where title like '%제목3%' order by num desc;
select * from board where content like '%내용4%' order by num desc;

--더미데이터 추가하기
INSERT INTO board VALUES (seq_board_num.nextval, '지금은 봄입니다', '봄의왈츠', 'musthave', sysdate, 0);
INSERT INTO board VALUES (seq_board_num.nextval, '지금은 여름입니다', '여름향기', 'musthave', sysdate, 0);
INSERT INTO board VALUES (seq_board_num.nextval, '지금은 가을입니다', '가을동화', 'musthave', sysdate, 0);
INSERT INTO board VALUES (seq_board_num.nextval, '지금은 겨울입니다', '겨울연가', 'musthave', sysdate, 0);

commit;

--모델1 게시판의 상세보기 처리
--게시물 조회 : 작성자의 이름을 함께 출력하기 위해 조인을 통한 쿼리문을 작성
--1.일련번호 8인 게시물 조회
select * from board where num=8;
--2.작성자 아이디가 musthave이므로 해당 회원을 조회한다.
select * from member where id='musthave';
--3.두개의 테이블을 join한다. board테이블의 모든컬럼과 member테이블의 name컬럼을
--  가져온다.
select B.*, M.name
form board B inner join member M 
    on B.id=m.id
where num=8;

--게시물 조회수 증가
-- : visitcount는 number 타입이므로 사칙연산이 가능하다.
--   기존의 값에 1을 더한 후 업데이트 한다.
update board set visitcount=visitcount+1 where num=8;
select * from board where num=8;

--게시물 수정하기
--1번 게시물에 대한 조회 및 수정
select * from board where num=1;
update board set
    title='수정된제목1', content='수정된 내용1 입니다.'
    where num=1;
commit;

--게시물 삭제하기
select * from board where num=1;
delete from board where num=1;
commit;

--게시판 페이징 구현하기

--정렬없이 모든 게시물 가져오기
select * from board;
--일련번호의 내림차순으로 정렬해서 게시물 가져오기
select * from board order by num desc;
--내림차순으로 정렬한 상태로 rownum을 부여하니 정상적으로 부여되지 않는다.
select num, title, rownum from board order by num desc;
/*
서브쿼리1 : board테이블의 모든 레코드를 내림차순으로 정렬한다.
서브쿼리2 : 쿼리1에서 정렬한 레코드를 기반으로 rownum을 부여한다.
    이렇게 하면 정렬된 장태에서 rownum을 부여할 수 있다.
서브쿼리 : 쿼리2의 결과를 통해 paging기능을 구현할 수 있다.
    rownum을 통해 원하는 구간의 게시물을 select한다.
*/
--서브쿼리3
select * from 
    --서브쿼리2
    (select tb.*, rownum rNum from 
        --서브쿼리1
        (select * from board order by num desc) tb)
--where rNum>=1 and rNum<=10;
where rNum>=11 and rNum<=20;
--rNum을 통해 내가 원하는 구간의 게시물을 가져올수 있다.

--검색어가 있는 경우의 쿼리문
select * from 
    --서브쿼리2
    (select tb.*, rownum rNum from 
        --서브쿼리1
        (select * from board 
            where title like '%글쓰기-8%'
        order by num desc) tb)
--where rNum>=11 and rNum<=20;
where rNum between 1 and 10;


/*******************
파일업로드  구현하기
*******************/
drop table myfile;
create table myfile (
    idx number primary key,
    name varchar2(50) not null,
    title varchar2(200) not null,
    cate varchar2(100),
    ofile varchar2(100) not null,
    sfile varchar2(30) not null,
    postdate date default sysdate not null
);
commit;


--모델2 방식의 파일첨부형 게시판 테이블 생성
create table mvcboard (
    idx number primary key,
    name varchar2(50) not null,
    title varchar2(200) not null,
    content varchar2(2000) not null,
    postdate date default sysdate not null,
    ofile varchar2(200),
    sfile varchar2(30),
    downcount number(5) default 0 not null,
    pass varchar2(50) not null,
    visitcount number default 0 not null
);
commit;

--더미 데이터 입력
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
commit;



--게시물의 갯수 카운트
select count(*) from mvcboard;
--검색어가 있는경우 카운트
select count(*) from mvcboard where name like '%대조영%';
--제목으로 검색
select count(*) from mvcboard where title like '%제목3%';


--모델2 방식의 게시판 페이징 처리하기 쿼리문 작성
select * from 
    (select tb.*, rownum rNum from
        (select * from mvcboard 
           -- where title like '%글쓰기-8%'
        order by idx desc) tb)
where rNum>=4 and rNum<=6;      --2페이지의 게시물
--where rNum between 1 and 3;   --1페이지의 게시물


select * from mvcboard;
--게시물 상세보기
--1.일련번호에 해당하는 레코드 조회
select * from mvcboard where idx=1418;
--2.조회된 레코드에 대해 조회수 증가
update mvcboard set visitcount=visitcount+1 where idx=1418;

--파일 다운로드 수 증가
update mvcboard set downcount=downcount+1 where idx=1418;



--로그인(회원인증)을 위한 쿼리문 작성
--시나리오] musthave/1234라는 회원정보가 있는지 확인하시오.
select * from member where id='musthave' and pass='1234';
select count(*) from member where id='musthave' and pass='1234';

--패스워드 검증을 위한 쿼리문 작성
--시나리오] 1423번 게시물의 비밀번호가 1234인지 검증하시오.
select * from mvcboard where idx=1423 and pass='1234';

--게시물 삭제하기
--시나리오] 1424번 게시물을 삭제하시오. 패스워드는 '1234'
delete from mvcboard where idx=1424 and pass='12xx';--삭제안됨. 비밀번호 틀림.
delete from mvcboard where idx=1424 and pass='1234';--삭제성공.

--게시물 수정하기
/*
회원제 게시판에서는 작성자의 아이디가 패스워드의 역활을 하게되므로
회원인증만 되면 수정 혹은 삭제처리를 해주면 된다.
하지만 비회원제 게시판에서는 패스워드를 통한 검증이 필수적이므로
수정시 패스워드에 대한 조건을 하나 더 추가해서 패스워드 검증이 끝난
게시물에 대해서만 삭제처리 될수있드록 해야한다.
*/
update mvcboard set title='제목수정', content='내용수정', 
    name='수정이름', ofile='', sfile=''
where idx=1427 and pass='1234';

commit;



--멀티 게시판 테이블(모델1 방식으로 제작)
create table multiboard (
    num number not null,
    title varchar2(200) not null,
    content varchar2(2000) not null,
    id varchar2(10) not null,
    postdate date default sysdate not null,
    visitcount number(6),
    b_flag char(3) not null, 
    primary key (num)
);
/*
b_flag : 게시판의 종류를 구분하기 위한 컬럼
플래그는 아래와 같이 지정한다.
-공지사항       : notice
-질문과답변     : qna
-자주묻는질문   : faq
-연애톡톡       : ent
-직원전용게시판 : staff
*/
select * from multiboard where b_flag='공지 자유';

commit;

/********************************************/
--kosmo 계정에서 실습합니다.

/*
Spring 게시판 제작1
    -JDBCTemplate(SPRING-JDBC)으로 구현한다.
    -비회원제 답변형 게시판
*/
--테이블 생성
create table springboard (
    idx number primary key, /* 일련번호 */
    name varchar2(30) not null, /* 작성자명 */
    title varchar2(200) not null, /* 제목 */
    contents varchar2(4000) not null, /* 내용 */
    postdate date default sysdate, /* 작성일 */
    hits number default 0, /* 조회수 */
    bgroup number default 0, /* 답변형 게시판에서 게시물의 그룹 */
    bstep number default 0, /* 원본글과 답변글의 정렬 순서 */
    bindent number default 0, /* 답변글의 depth 지정. 원본글은 0으로 지정됨. */
    pass varchar2(30) /* 비밀번호 */
);


--시퀀스 생성
create sequence springboard_seq
    increment by 1
    start with 1
    minvalue 1
    nomaxvalue
    nocycle
    nocache;
    
    
--더미데이터 추가
/* 시퀀스 사용을 위한 nextval은 항상 다음 시퀀스 번호를 반환한다. 하지만 한문장(쿼리문)
에서 2번 사용되면 같은 시퀀스 번호를 반환한다. */
insert into springboard values (springboard_seq.nextval, '코스모1',
    '스프링게시판 첫번째 입니다.','내용입니다', sysdate, 0,
    springboard_seq.nextval, 0, 0, '1234');
    
insert into springboard values (springboard_seq.nextval, '코스모2',
    '스프링게시판 두번째 입니다.','내용입니다', sysdate, 0,
    springboard_seq.nextval, 0, 0, '1234');

insert into springboard values (springboard_seq.nextval, '코스모3',
    '스프링게시판 세번째 입니다.','내용입니다', sysdate, 0,
    springboard_seq.nextval, 0, 0, '1234');
    
insert into springboard values (springboard_seq.nextval, '코스모4',
    '스프링게시판 네번째 입니다.','내용입니다', sysdate, 0,
    springboard_seq.nextval, 0, 0, '1234');
    
insert into springboard values (springboard_seq.nextval, '코스모5',
    '스프링게시판 다섯번째 입니다.','내용입니다', sysdate, 0,
    springboard_seq.nextval, 0, 0, '1234');

select * from springboard;

commit;
