/***********���ܼ������***********/
create user kosmo identified by 1234;
grant connect, resource to kosmo;

create table simple_crud (
    idx number not null,
    contents varchar2(300) not null,
    primary key (idx)
);


--���̺� ���ڵ� �Է��ϱ�
--���� : insert into ���̺�� (�÷���) values (�Է°�);
insert into simple_crud (idx, contents) values ('1', 'tax');
select * from simple_crud;
commit;



/*������ ����*/
create table simple_crud 
(
    idx number primary key,
    contents varchar2(300) not null
);



