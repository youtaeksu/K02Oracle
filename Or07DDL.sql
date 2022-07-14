/*****************************
���ϸ� : Or07DDL.sql
DDL : Data Definition Language(������ ���Ǿ�)
���� : ���̺�, ��� ���� ��ü�� ���� �� �����ϴ� �������� ���Ѵ�.
*****************************/

/*
system�������� ������ �� �Ʒ� ����� �����Ѵ�.
���ο� ����� ������ ������ �� ���ӱ��Ѱ� ���̺���� ���� ������ �ο��Ѵ�.
*/
--study ������ �����ϰ�, �н������ 1234�� �ο��Ѵ�.
create user study identified by 1234;
--������ ������ ������ �ο��Ѵ�.
grant connect, resource to study;


-------------------------------------------------------
--study������ ������ �� �ǽ��� �����մϴ�.

--��� ������ �����ϴ� ������ ���̺�.
select * from dual;

--�ش� ������ ������ ���̺��� ����� ������ �ý������̺�
select * from tab;


/*
���̺����
����]
    create table ���̺�� (
        �÷���1 �ڷ���,
        �÷���2 �ڷ���,
        .....
        primary key(�÷���) ���� �������� �߰�
    );
*/

create table tb_member(
    idx number(10),/* 10�ڸ��� ������ ǥ��*/
    userid varchar2(30),/* ���������� 30byte ���尡��*/
    passwd varchar2(50),
    username varchar2(30),
    mileage number(7,2)/* �Ǽ� ǥ��.��ü 7�ڸ�, �Ҽ� 2�ڸ� ǥ��*/
);
--���� ������ ������ ������ ���̺� ����� Ȯ��
select *from tab;
--���̺��� ����(��Ű��)Ȯ��. �÷���,�ڷ���,ũ�� ���� Ȯ���� �� �ִ�.
desc tb_member;

/*
DDL�� ���Ǿ� -> Table(����/����/����),�����,view 
DML�� ���۾�   
DCL�� �����
(����:DCL-DDL-DML)
*/

/*
���� ������ ���̺� ���ο� �÷� �߰��ϱ�
->tb_member ���̺�  email �÷��� �߰��Ͻÿ�

����]alter table ���̺�� add �߰��� �÷� �ڷ���(ũ��) ��������;
*/
alter table tb_member add email varchar2(100);

/*
���� ������ ���̺� ���ο� �÷� �����ϱ�
->tb_member ���̺���  email �÷��� ����� 200���� Ȯ���Ͻÿ�.
���� �̸��� ����Ǵ� username�÷��� 60���� Ȯ���Ͻÿ�
*/
alter table tb_member modify email varchar2(200);
alter table tb_member modify username varchar2(60);
desc tb_member;
/*
���� ������ ���̺��� �÷������ϱ�
->tb_member���̺��� mileage �÷��� �����Ͻÿ�

����]alter table ���̺�� drop column ������ �÷���;
*/
alter table tb_member drop column mileage;
desc tb_member;

/*
����]���̺� ���Ǽ��� �ۼ��� employees���̺��� �ش� study ������ �״�� 
�����Ͻÿ�.��,���������� ������� �ʽ��ϴ�
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
���̺� �����ϱ�
->employees ���̺��� ���̻� ������� �����Ƿ� �����Ͻÿ�
����]drop table ������ ���̺��
*/
select *from tab;
drop table employees;
select *from tab;--���� �� ���̺� ��� Ȯ��(tb_member ���̺� ������)
desc employees;--��ü�� �������� �ʴ´ٴ� ���� �߻���



--tb_member ���̺� ���ο� ���ڵ� �����ϱ�(DML������ �н��� ����)
insert into tb_member values(1,'hong','1234','ȫ�浿','hong@naver.com');
insert into tb_member values(2,'yu','9876','����','yoo@daum.net');
--���Ե� ���ڵ� Ȯ��
select*from tb_member;
select*from tb_member where idx=2;

--���̺� �����ϱ�1 : ���ڵ���� �Բ� ����
/*
select���� ����۶� where���� ������ ��� ���ڵ带 ����϶��
����̹Ƿ� �Ʒ������� ��� ���ڵ带 �����ͼ� ���纻 ���̺��� �����Ѵ�
��, ���ڵ���� ����ȴ�
*/
create table tb_member_copy
as
select * from tb_member;
--����� ���̺� Ȯ���ϱ�
select * from tb_member_copy;

--���̺� �����ϱ�2 : ���ڵ�� �����ϰ� ���̺� ������ ����

create table tb_member_empty
as
select * from tb_member where 1=0;
desc tb_member_empty;
select * from tb_member_empty;

/*
DDL�� :  ���̺��� ���� �� �����ϴ� ������
    
    (Data Definition Language :  ������ ���Ǿ�)
    ���̺� ���� : create table ���̺��
    ���̺� ����
        �÷��߰� : alter table ���̺�� add�÷���
        �÷����� : alter table ���̺�� modify �÷���
        �÷����� : alter table ���̺�� drop column�÷���
    ���̺� ���� : drop table ���̺��
*/

-------------------------------------------------------

/*
1. ���� ���ǿ� �´� ��pr_dept�� ���̺��� �����Ͻÿ�.
*/


create table pr_dept(
    dno number(2),
    dname varchar2(20),
    loc varchar2(35)
);
select *from tab;
desc pr_dept;


/*
2. ���� ���ǿ� �´� ��pr_emp�� ���̺��� �����Ͻÿ�.
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
3. pr_emp ���̺��� ename �÷��� varchar2(50) �� �����Ͻÿ�.
*/


alter table pr_emp modify ename varchar2(50);
desc pr_emp;


/*
4. 1������ ������ pr_dept ���̺��� dname Į���� �����Ͻÿ�.
*/


alter table pr_dept drop column dname;
desc pr_dept;


/*
5. ��pr_emp�� ���̺��� job �÷��� varchar2(50) ���� �����Ͻÿ�.
*/


alter table pr_emp modify job varchar2(50);
desc pr_emp;
