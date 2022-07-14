/***********간단수행과제***********/
create user kosmo identified by 1234;
grant connect, resource to kosmo;

create table simple_crud (
    idx number not null,
    contents varchar2(300) not null,
    primary key (idx)
);


--테이블에 레코드 입력하기
--형식 : insert into 테이블명 (컬럼명) values (입력값);
insert into simple_crud (idx, contents) values ('1', 'tax');
select * from simple_crud;
commit;



/*선생님 교안*/
create table simple_crud 
(
    idx number primary key,
    contents varchar2(300) not null
);



