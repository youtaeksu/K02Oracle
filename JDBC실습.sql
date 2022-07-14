/*
Java���� ó������ JDBC���α׷��� �غ���
*/
--�켱 system������ ������ �� ���ο� ������ �����Ѵ�.
CREATE USER kosmo IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE TO kosmo;

--������ ������ �� ����â�� kosmo ������ ����ϰ� �ش� ������ �����Ѵ�.
--ȸ������ ���̺� : member ����
CREATE TABLE member
(
	id VARCHAR2(30) NOT NULL,
	pass VARCHAR2(40) NOT NULL,
	name VARCHAR2(50) NOT NULL,
	regidate DATE DEFAULT SYSDATE,
	PRIMARY KEY (id)
);

--���̵����� �Է��ϱ�
insert into member (id, pass, name) values ('test4', '1234', '�׽�Ʈ');
select * from member;
commit;

/*
����Ŭ ���ο��� ���� ���ڵ��� ��ȭ�� �ܺ�(Java)���� ��� Ȯ���� �� ����.
�ݵ�� commit����� ���� �ӽ����̺��� ������ ���� ���̺�� �ű�� �۾��� �ʿ��ϴ�.
��, insert, update, delete�� ������ ���Ŀ��� commit�ؾ� �Ѵ�.
*/
insert into member (id, pass, name) values ('dummy', '1234', '���´���');
select * from member;
commit;

update member set pass='9x9x' where id='test2';
select * from member;
commit;

--�ش� ������ ������ �������� Ȯ��
select * from user_constraints;

--like�� �̿��� �˻� ����
select * from member where name like '%��%';




--------------------------------------------------------------
--JDBC > CallableStatement �������̽� ����ϱ�

--substr(���ڿ� Ȥ�� �÷�, �����ε���, ����) : �����ε������� ���̸�ŭ �߶󳽴�.
select substr('hongildong',1,1) from dual;
--rpad(���ڿ� Ȥ�� �÷�, ����, ����) : ���ڿ��� ���� ���̸�ŭ�� ���ڷ� ä���ش�.
select rpad('h', 10, '*') from dual;
--���ڿ�(���̵�)�� ù���ڸ� ������ ������ �κ��� *�� ä���ش�.
select rpad(substr('hongildong',1,1), length('hongildong'), '*') from dual;
/*
�ó�����]�Ű������� ȸ�����̵�(���ڿ�)�� ������ ù���ڸ� ������ �������κ���
    *�� ��ȯ�ϴ� �Լ��� �����Ͻÿ�
    ���� ��) kosmo -> k****
*/
create or replace function fillAsterik (
    idStr varchar2) /* �Ű������� ���������� ���� */
return varchar2 /* ��ȯ�� ���������� ����*/
is retStr varchar2(50); /* �������� : ��ȯ���� �����Ұ��� */
begin
    --���ڿ��� �����κ��� *�� ä���ش�.
    retStr := rpad(substr(idStr,1,1), length(idStr), '*');
    return retStr;
end;
/

select fillAsterik('hongildong') from dual;
select fillAsterik('nakja') from dual;

select * from employees where employee_id=100;
select fillAsterik(first_name) from employees where employee_id=100;


/*
�ó�����] member ���̺� ���ο� ȸ�������� �Է��ϴ� ���ν����� �����Ͻÿ�.
    �Է°� : ���̵�, �н�����, �̸�
*/
create or replace procedure KosmoMemberInsert (
        p_id in varchar2,
        p_pass in varchar2,
        p_name in varchar2, /* Java���� ������ ���ڸ� ���� ���Ķ���� */
        returnVal out number /* �Է¼������� Ȯ�� */
    )
is
begin
    --���Ķ���͸� ���� insert ������ �ۼ�
    insert into member (id, pass, name)
        values (p_id, p_pass, p_name);
    
    --�Է��� ���������� ó���Ǿ��ٸ�...        
    if sql%found then
        --������ ���� ������ ���ͼ� �ƿ��Ķ���Ϳ� �����Ѵ�.
        returnVal := sql%rowcount;
        commit;
    else
        --������ ��쿡�� 0�� ��ȯ�Ѵ�.
        returnVal := 0;
    end if;
end;
/
set serveroutput on;
--���ε� ���� ����
select * from user_source where name like upper('%kosmomem%');
var insert_count number;
--���ν��� ����
execute KosmoMemberInsert('pro1','p1234','���ν���1',:insert_count);
--���Ȯ��
print insert_count;
--�Էµ� ȸ������ Ȯ��
select * from member;

/*
�ó�����] member���̺��� ���ڵ带 �����ϴ� ���ν����� �����Ͻÿ�.
    �Ű����� : In => member_id(���̵�)
               Out => returnVal(SUCCESS/FAIL ��ȯ)
*/
create or replace procedure KosmoMemberDelete (
        member_id in varchar2,
        returnVal out varchar2
    )
is --������ �ʿ���� ��� ��������
begin
    --���Ķ���͸� ���� delete������ �ۼ�
    delete from member where id=member_id;
    
    if SQL%Found then
        --ȸ�����ڵ尡 ���������� �����Ǿ��ٸ�
        returnVal := 'SUCCESS';
        --Ŀ���Ѵ�.
        commit;
    else
        --���ǿ� ��ġ�ϴ� ���ڵ尡 ���°�� FAIL�� ��ȯ�Ѵ�.
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
�ó�����] ���̵�� �н����带 �Ű������� ���޹޾Ƽ� ȸ������ ���θ�
�Ǵ��ϴ� ���ν����� �ۼ��Ͻÿ�. 

    �Ű����� : 
        In -> user_id, user_pass
        Out -> returnVal
    ��ȯ�� : 
        0 -> ȸ����������(�Ѵ�Ʋ��)
        1 -> ���̵�� ��ġ�ϳ� �н����尡 Ʋ�����
        2 -> ���̵�/�н����� ��� ��ġ�Ͽ� ȸ������ ����
    ���ν����� : KosmoMemberAuth
*/
create or replace procedure KosmoMemberAuth (
    user_id in varchar2,
    user_pass in varchar2,
    returnVal out number
)
is
    -- count(*)�� ���� ��ȯ�Ǵ� ���� �����Ѵ�.
    member_count number(1) := 0;
    -- ��ȸ�� ȸ�������� �н����带 �����Ѵ�.
    member_pw varchar2(50);
begin
    --�ش� ���̵� �����ϴ��� �Ǵ��ϴ� select�� �ۼ�
    select count(*) into member_count
    from member where id=user_id;
    
    --ȸ�����̵� �����ϴ� ���
    if member_count=1 then
        --�н����� Ȯ���� ���� �ι�° ������ ����
        select pass into member_pw 
            from member where id=user_id;
        
        --���Ķ���ͷ� ���޵� ����� DB���� ������ ����� ��
        if member_pw=user_pass then
            returnVal := 2; --���̵�/��� ��� ��ġ
        else
            returnVal := 1; --���Ʋ��
        end if;
    else
        returnVal := 0; --ȸ�������� ����
    end if;
end;
/
--�Ѵ���ġ, ���̵� ��ġ, ���������� 3���� ���̽��� ��� �׽�Ʈ �غ���
variable member_auth number;
execute KosmoMemberAuth('test', '1234', :member_auth);
print member_auth;

execute KosmoMemberAuth('yugyeom', '1234�н�����Ʋ��', :member_auth); 
print member_auth;

execute KosmoMemberAuth('yugyeom���̵�Ʋ��', '1234�н�����Ʋ��', :member_auth); 
print member_auth;




/*
JSP���� JDBC �ǽ��ϱ�
-���ο� ���� ���� �� ���� �ο��ϱ�
*/

--System�������� ������ �� ���������� ������ �ο��� �ּ���.

--���� ����
CREATE USER musthave IDENTIFIED BY 1234;
--Role(��)�� ���ؼ� ���ӱ��Ѱ� ���̺���� ���� �ο�
GRANT CONNECT, RESOURCE TO musthave;

--�� �������� ����Ŭ ����
conn musthave/1234;

--���̺� ��� ��ȸ
select * from tab;

/* �Ǽ��� system������ ���̺��� �����ߴٸ� �����մϴ�. */
drop table member;
drop table board;
drop sequence seq_board_num;

--musthave �������� ������ �� ���̺� �� �ܷ�Ű�� ������ �ּ���.

--ȸ������ ���̺�
create table member (
    id varchar2(10) not null,
    pass varchar2(10) not null,
    name varchar2(30) not null,
    regidate date default sysdate not null,
    primary key (id)
);

--�Խ��� ���̺�(��1 ��Ŀ��� ���)
create table board (
    num number primary key,
    title varchar2(200) not null,
    content varchar2(2000) not null,
    id varchar2(10) not null,
    postdate date default sysdate not null,
    visitcount number(6)
);

--board���̺��� member���̺��� �����ϴ� �ܷ�Ű(����Ű) ����
alter table board
    add constraint board_mem_fk foreign key (id)
    references member (id);
    
--������ ����(�Խ��� �Ϸù�ȣ �Է½� �ڵ����������� �����)
create sequence seq_board_num
    increment by 1
    start with 1
    minvalue 1
    nomaxvalue 
    nocycle
    nocache;
    
--���� ������ �Է��ϱ�
insert into member (id, pass, name) values ('musthave','1234','�ӽ�Ʈ�غ�');
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '����2�Դϴ�', '����2�Դϴ�', 'musthave', sysdate, 0);
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '����3�Դϴ�', '����3�Դϴ�', 'musthave', sysdate, 0);
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '����4�Դϴ�', '����4�Դϴ�', 'musthave', sysdate, 0);
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '����5�Դϴ�', '����5�Դϴ�', 'musthave', sysdate, 0);
commit;



/*
JSP Model1 ����� ȸ���� �Խ��� �����ϱ� 
*/
--���(List) : �Խù� ī��Ʈ�ϱ�
--�Խù� ��ü ī��Ʈ
select count(*) from board;
--�˻��������� ī��Ʈ
select count(*) from board where title like '%����3%';

--���(List) : �Խù� ����ϱ�
--  �ֱٿ� �ۼ��� �Խù��� ��ܿ� �����ϱ� ���� �Ϸù�ȣ(num)�� ������������ �����Ѵ�.
select * from board order by num desc;
--�˻�� �ִ� ���
select * from board where title like '%����3%' order by num desc;
select * from board where content like '%����4%' order by num desc;

--���̵����� �߰��ϱ�
INSERT INTO board VALUES (seq_board_num.nextval, '������ ���Դϴ�', '���ǿ���', 'musthave', sysdate, 0);
INSERT INTO board VALUES (seq_board_num.nextval, '������ �����Դϴ�', '�������', 'musthave', sysdate, 0);
INSERT INTO board VALUES (seq_board_num.nextval, '������ �����Դϴ�', '������ȭ', 'musthave', sysdate, 0);
INSERT INTO board VALUES (seq_board_num.nextval, '������ �ܿ��Դϴ�', '�ܿ￬��', 'musthave', sysdate, 0);

commit;

--��1 �Խ����� �󼼺��� ó��
--�Խù� ��ȸ : �ۼ����� �̸��� �Բ� ����ϱ� ���� ������ ���� �������� �ۼ�
--1.�Ϸù�ȣ 8�� �Խù� ��ȸ
select * from board where num=8;
--2.�ۼ��� ���̵� musthave�̹Ƿ� �ش� ȸ���� ��ȸ�Ѵ�.
select * from member where id='musthave';
--3.�ΰ��� ���̺��� join�Ѵ�. board���̺��� ����÷��� member���̺��� name�÷���
--  �����´�.
select B.*, M.name
form board B inner join member M 
    on B.id=m.id
where num=8;

--�Խù� ��ȸ�� ����
-- : visitcount�� number Ÿ���̹Ƿ� ��Ģ������ �����ϴ�.
--   ������ ���� 1�� ���� �� ������Ʈ �Ѵ�.
update board set visitcount=visitcount+1 where num=8;
select * from board where num=8;

--�Խù� �����ϱ�
--1�� �Խù��� ���� ��ȸ �� ����
select * from board where num=1;
update board set
    title='����������1', content='������ ����1 �Դϴ�.'
    where num=1;
commit;

--�Խù� �����ϱ�
select * from board where num=1;
delete from board where num=1;
commit;

--�Խ��� ����¡ �����ϱ�

--���ľ��� ��� �Խù� ��������
select * from board;
--�Ϸù�ȣ�� ������������ �����ؼ� �Խù� ��������
select * from board order by num desc;
--������������ ������ ���·� rownum�� �ο��ϴ� ���������� �ο����� �ʴ´�.
select num, title, rownum from board order by num desc;
/*
��������1 : board���̺��� ��� ���ڵ带 ������������ �����Ѵ�.
��������2 : ����1���� ������ ���ڵ带 ������� rownum�� �ο��Ѵ�.
    �̷��� �ϸ� ���ĵ� ���¿��� rownum�� �ο��� �� �ִ�.
�������� : ����2�� ����� ���� paging����� ������ �� �ִ�.
    rownum�� ���� ���ϴ� ������ �Խù��� select�Ѵ�.
*/
--��������3
select * from 
    --��������2
    (select tb.*, rownum rNum from 
        --��������1
        (select * from board order by num desc) tb)
--where rNum>=1 and rNum<=10;
where rNum>=11 and rNum<=20;
--rNum�� ���� ���� ���ϴ� ������ �Խù��� �����ü� �ִ�.

--�˻�� �ִ� ����� ������
select * from 
    --��������2
    (select tb.*, rownum rNum from 
        --��������1
        (select * from board 
            where title like '%�۾���-8%'
        order by num desc) tb)
--where rNum>=11 and rNum<=20;
where rNum between 1 and 10;


/*******************
���Ͼ��ε�  �����ϱ�
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


--��2 ����� ����÷���� �Խ��� ���̺� ����
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

--���� ������ �Է�
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
commit;



--�Խù��� ���� ī��Ʈ
select count(*) from mvcboard;
--�˻�� �ִ°�� ī��Ʈ
select count(*) from mvcboard where name like '%������%';
--�������� �˻�
select count(*) from mvcboard where title like '%����3%';


--��2 ����� �Խ��� ����¡ ó���ϱ� ������ �ۼ�
select * from 
    (select tb.*, rownum rNum from
        (select * from mvcboard 
           -- where title like '%�۾���-8%'
        order by idx desc) tb)
where rNum>=4 and rNum<=6;      --2�������� �Խù�
--where rNum between 1 and 3;   --1�������� �Խù�


select * from mvcboard;
--�Խù� �󼼺���
--1.�Ϸù�ȣ�� �ش��ϴ� ���ڵ� ��ȸ
select * from mvcboard where idx=1418;
--2.��ȸ�� ���ڵ忡 ���� ��ȸ�� ����
update mvcboard set visitcount=visitcount+1 where idx=1418;

--���� �ٿ�ε� �� ����
update mvcboard set downcount=downcount+1 where idx=1418;



--�α���(ȸ������)�� ���� ������ �ۼ�
--�ó�����] musthave/1234��� ȸ�������� �ִ��� Ȯ���Ͻÿ�.
select * from member where id='musthave' and pass='1234';
select count(*) from member where id='musthave' and pass='1234';

--�н����� ������ ���� ������ �ۼ�
--�ó�����] 1423�� �Խù��� ��й�ȣ�� 1234���� �����Ͻÿ�.
select * from mvcboard where idx=1423 and pass='1234';

--�Խù� �����ϱ�
--�ó�����] 1424�� �Խù��� �����Ͻÿ�. �н������ '1234'
delete from mvcboard where idx=1424 and pass='12xx';--�����ȵ�. ��й�ȣ Ʋ��.
delete from mvcboard where idx=1424 and pass='1234';--��������.

--�Խù� �����ϱ�
/*
ȸ���� �Խ��ǿ����� �ۼ����� ���̵� �н������� ��Ȱ�� �ϰԵǹǷ�
ȸ�������� �Ǹ� ���� Ȥ�� ����ó���� ���ָ� �ȴ�.
������ ��ȸ���� �Խ��ǿ����� �н����带 ���� ������ �ʼ����̹Ƿ�
������ �н����忡 ���� ������ �ϳ� �� �߰��ؼ� �н����� ������ ����
�Խù��� ���ؼ��� ����ó�� �ɼ��ֵ�� �ؾ��Ѵ�.
*/
update mvcboard set title='�������', content='�������', 
    name='�����̸�', ofile='', sfile=''
where idx=1427 and pass='1234';

commit;



--��Ƽ �Խ��� ���̺�(��1 ������� ����)
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
b_flag : �Խ����� ������ �����ϱ� ���� �÷�
�÷��״� �Ʒ��� ���� �����Ѵ�.
-��������       : notice
-�������亯     : qna
-���ֹ�������   : faq
-��������       : ent
-��������Խ��� : staff
*/
select * from multiboard where b_flag='���� ����';

commit;

/********************************************/
--kosmo �������� �ǽ��մϴ�.

/*
Spring �Խ��� ����1
    -JDBCTemplate(SPRING-JDBC)���� �����Ѵ�.
    -��ȸ���� �亯�� �Խ���
*/
--���̺� ����
create table springboard (
    idx number primary key, /* �Ϸù�ȣ */
    name varchar2(30) not null, /* �ۼ��ڸ� */
    title varchar2(200) not null, /* ���� */
    contents varchar2(4000) not null, /* ���� */
    postdate date default sysdate, /* �ۼ��� */
    hits number default 0, /* ��ȸ�� */
    bgroup number default 0, /* �亯�� �Խ��ǿ��� �Խù��� �׷� */
    bstep number default 0, /* �����۰� �亯���� ���� ���� */
    bindent number default 0, /* �亯���� depth ����. �������� 0���� ������. */
    pass varchar2(30) /* ��й�ȣ */
);


--������ ����
create sequence springboard_seq
    increment by 1
    start with 1
    minvalue 1
    nomaxvalue
    nocycle
    nocache;
    
    
--���̵����� �߰�
/* ������ ����� ���� nextval�� �׻� ���� ������ ��ȣ�� ��ȯ�Ѵ�. ������ �ѹ���(������)
���� 2�� ���Ǹ� ���� ������ ��ȣ�� ��ȯ�Ѵ�. */
insert into springboard values (springboard_seq.nextval, '�ڽ���1',
    '�������Խ��� ù��° �Դϴ�.','�����Դϴ�', sysdate, 0,
    springboard_seq.nextval, 0, 0, '1234');
    
insert into springboard values (springboard_seq.nextval, '�ڽ���2',
    '�������Խ��� �ι�° �Դϴ�.','�����Դϴ�', sysdate, 0,
    springboard_seq.nextval, 0, 0, '1234');

insert into springboard values (springboard_seq.nextval, '�ڽ���3',
    '�������Խ��� ����° �Դϴ�.','�����Դϴ�', sysdate, 0,
    springboard_seq.nextval, 0, 0, '1234');
    
insert into springboard values (springboard_seq.nextval, '�ڽ���4',
    '�������Խ��� �׹�° �Դϴ�.','�����Դϴ�', sysdate, 0,
    springboard_seq.nextval, 0, 0, '1234');
    
insert into springboard values (springboard_seq.nextval, '�ڽ���5',
    '�������Խ��� �ټ���° �Դϴ�.','�����Դϴ�', sysdate, 0,
    springboard_seq.nextval, 0, 0, '1234');

select * from springboard;

commit;
