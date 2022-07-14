/*******************************
파일명 : Or13DCL.sql
DCL : Data Control Language(데이터 제어어)
사용자권한
설명 : 새로운 사용자계정을 생성하고 시스템권한을 부여하는 방법을 학습
*******************************/

/*
[사용자계정 생성 및 권한설정]
해당 내용은 DBA권한이 있는 최고관리자(sys, system)로 접속한 후
실행해야 한다. 
사용자 계정 생성후 접속 테스트는 CMD(명령프롬프트)에서 진행한다. 
*/


/*
1]사용자 계정 생성 및 암호설정
형식]
    create user 아이디 identified by 패스워드;
*/
create user test_user1 identified by 1234;
--#계정을 생성한 직후 cmd에서 sqlplus명령으로 접속시 login denied 에러발생됨
--#즉, 접속권한이 없어 접속이 되지 않는다. 


/*
2]생성된 사용자 계정에 권한 혹은 역할 부여
형식]
    grant 시스템권한1, 2, ... N
        to 사용자계정명
            [with grant 옵션];
*/
--접속권한 부여 : create session을 test_user1에 부여한다. 
grant create session to test_user1 ;
--권한 부여후 접속은 성공했다. 하지만 테이블생성은 안된다. 

--테이블 생성 권한 부여
grant create table to test_user1;
--#테이블 생성시 테이블 스페이스가 없어 오류 발생됨

/*
테이블 스페이스란?
    디스크 공간을 소비하는 테이블과 뷰, 그리고 그 밖의 다른 데이터베이스
    객체들이 저장되는 장소이다. 예를 들어 오라클을 최초로 설치하면
    hr계정의 데이터를 저장하는 user라는 테이블 스페이스가 자동으로 생성된다. 
*/
--테이블 스페이스 조회하기
desc dba_tablespaces;
select tablespace_name, status, contents from dba_tablespaces;

--테이블 스페이스별 사용 가능한 공간 확인하기
select 
    tablespace_name, sum(bytes), max(bytes),
    to_char(sum(bytes), '9,999,999,000'),
    to_char(max(bytes), '9,999,999,000')
from dba_free_space
group by tablespace_name;

--앞에서 생성한 test_user1 사용자의 테이블스페이스 확인하기
select username, default_tablespace from dba_users
where username in upper('test_user1');--system 테이블 스페이스 임을 확인

--테이블 스페이스 영역 할당
alter user test_user1 quota 2m on system;
/*
    test_user1이 system 테이블 스페이스에 테이블을 생성할 수 있도록
    2m의 용량을 할당한다. 
*/
--cmd 에서 테이블 생성이 되는지 확인해본다.(생성됨)


--2번째 사용자 추가 : 테이블 스페이스를 users로 지정하여 생성한다. 
create user test_user2 identified by 1234 default tablespace users;
grant create session to test_user2;--접속 권한 부여
grant create table to test_user2;--테이블생성 권한 부여
/*# 테이블을 생성하면 users 테이블스페이스에 대한 권한이 없어 생성되지 않는다. */

--앞에서 지정한데로 테이블스페이스 users를 사용하고 있다. 
select username, default_tablespace from dba_users
where username in upper('test_user2');
--users 테이블스페이스에 10m의 공간을 할당한다. 
alter user test_user2 quota 10m on users;
/*# 테이블이 정상적으로 생성된다. */

/*
이미 생성된 사용자의 디폴트 테이블스페이스를 변경하고 싶을때는 
alter user명령을 사용한다. 
*/
select username, default_tablespace from dba_users
where username in upper('test_user1');--테이블스페이스 system 확인

alter user test_user1 default tablespace users;--users로 변경

select username, default_tablespace from dba_users
where username in upper('test_user1');--users로 확인됨
/*
    cmd에서 test_user1로 접속한 후 테이블을 생성하면 오류가 발생한다. 
    앞에서 부여한 테이블 스페이스 공간은 system에서 할당되었으므로 
    users에 별도로 부여한 후 테이블을 생성해야 한다.(여러분이 직접 해보세요) 
*/

/*
3]암호변경
    alter user 사용자계정 identified by 변경할비번;
*/
alter user test_user1 identified by 4321;
/*# 암호가 변경되었으므로 cmd에서 1234로 접속되지 않는다. */




/*
4] Role(롤)을 통한 여러가지 권한을 동시에 부여하기
    : 여러 사용자가 다양한 권한을 효과적으로 관리할 수 있도록
    관련된 권한끼리 묶어놓은것을 말한다. 
※우리는 실습을 위해 새롭게 생성한 계정에 connect, resource롤을 주로 부여한다.   
*/
grant connect, resource to test_user2;
/*
    # test_user1의 경우 접속권한, 테이블생성권한만 부여했으므로 시퀀스는
    생성할 수 없다. 
    # test_user2는 Role(롤)을 통해 권한을 부여하므로 시퀀스 생성이 가능하다. 
*/

/*
4-1] 롤 생성하기 : 사용자가 원하는 권한을 묶어 새로운 롤을 생성한다. 
*/
create role kosmo_role;

/*
4-2] 생성된 롤에 권한 부여하기
*/
grant create session, create table, create view to kosmo_role;
--새로운 사용자 계정 생성한 후 롤을 통해 권한부여
create user test_user3 identified by 1234;
grant kosmo_role to test_user3;
/*# 접속은 되지만 테이블 스페이스가 없어 테이블생성은 안된다. */

/*
4-3] 롤 삭제하기
*/
drop role kosmo_role;
/*
    #test_user3 사용자는 kosmo_role을 통해 권한을 부여받았으므로
    해당 롤을 삭제하면 부여받았던 모든 권한이 회수(revoke)된다. 
    즉, 롤 삭제후에는 접속할 수 없다. 
*/
--# test_user3은 접속 불가..

/*
5] 권한제거(회수)
    형식] revoke 권한 및 역할 from 사용자계정;
*/
revoke create session from test_user1;
--# test_user1은 접속 불가..

/*
6] 사용자 계정 삭제
    형식] drop user 사용자계정 [cascade];
※cascade를 명시하면 사용자계정과 관련된 모든 데이터베이스 스키마가 
데이터사전으로 부터 삭제되고 모든 스키마 객체도 물리적으로 삭제된다. 
*/
--현재 생성된 사용자 목록을 확인할 수 있는 데이터사전
select * from dba_users;
--계정을 삭제하면서 모든 물리적인 스키마까지 같이 삭제한다. 
drop user test_user1 cascade;










