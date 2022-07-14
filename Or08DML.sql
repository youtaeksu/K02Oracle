/*****************************
���ϸ� : Or08DML.sql
DML : Date Manipulation Language(������ ���۾�)
���� : ���ڵ带 �����Ҷ� ����ϴ� ������. �տ��� �н��ߴ� 
    select���� ����Ͽ� update(���ڵ����), delete(���ڵ����),
    insert(���ڵ��Է�)�� �ִ�.
*****************************/

--study�������� �ǽ��մϴ�.

/*
���ڵ� �Է��ϱ� : insert
    ���ڵ� �Է��� ���� ������ �������� �ݵ�� ' �� ���ξ��Ѵ�.
    �������� ' ���� �׳� ����ȴ�. ���� �������� ' �� ���ΰ� �Ǹ�
    �ڵ����� ����ȯ�Ǿ� �Էµȴ�.
*/
--���ο� ���̺� ����
create table tb_sample (
    dept_no number(10),
    dept_name varchar2(20),
    dept_loc varchar2(15),
    dept_manager varchar2(30)
);
--������ ���̺� ���� Ȯ��
desc tb_sample;


--�������Է�1 : �÷��� ������ �� insert 
insert into tb_sample (dept_no, dept_name, dept_loc, dept_manager)
    values (10, '��ȹ��', '����', '����');
insert into tb_sample (dept_no, dept_name, dept_loc, dept_manager)
    values (20, '������', '����', '����');

--�������Է�2 : �÷� �������� ��ü �÷��� ������� insert
insert into tb_sample values (30, '������', '�뱸', '���');
insert into tb_sample values (40, '�λ���', '�λ�', '��ȿ');

--�Է�Ȯ��
select * from tb_sample;

/*
    ���ݱ����� �۾�(Ʈ�����)�� �״�� �����ϰڴٴ� ������� Ŀ���� ��������
    ������ �ܺο����� ����� ���ڵ带 Ȯ���� �� ����.
    ���⼭ ���ϴ� �ܺζ� Java/JSP�� ���� Oracle�̿��� ���α׷��� ���Ѵ�.
    ��Ʈ������̶� �۱ݰ� ���� �ϳ��� �����۾��� ���Ѵ�.
*/
commit;

--Ŀ�� ���� ���ο� ���ڵ带 �����ϸ� �ӽ����̺� ����ȴ�.
insert into tb_sample values ltrim(50, '������', '����', '���̸�');
--����Ŭ���� Ȯ���ϸ� ���� ���ԵȰ�ó�� ���δ�. ������ ���� �ݿ����� ���� �����̴�.
select * from tb_sample;
--�ѹ� ������� ������ Ŀ�� ���·� �ǵ��� �� �ִ�.
rollback;
--�������� �Է��� '���̸�'�� ���ŵȴ�.
select * from tb_sample;
/*
    rollback ����� ������ Ŀ�� ���·� �ǵ����ش�.
    ��, commit�� ������ ���·δ� �ѹ� �� �� ����.
*/

/*
���ڵ� �����ϱ� : update
    ����] 
        update ���̺��
        set �÷�1=��1, �÷�2=��2, .....
        where ����;
    �������� ���°�� ��� ���ڵ尡 �Ѳ����� �����ȴ�.
    �����̺�� �տ� from�� ���� �ʴ´�.
*/
--�μ���ȣ 40�� ���ڵ��� ������ �̱����� �����Ͻÿ�.
update tb_sample set dept_loc='�̱�' where dept_no=40;
select * from tb_sample;
--������ ������ ���ڵ��� �޳������� '������'���� �����Ͻÿ�.
update tb_sample set dept_manager='������' where dept_loc='����';
select * from tb_sample;
--��� ���ڵ带 ������� ������ '���������'�� �����Ͻÿ�.
update tb_sample set dept_loc='���������';--��ü���ڵ尡 ����̸� where���� �����ʴ´�.
select * from tb_sample;

/*
���ڵ� �����ϱ� : delete
    ����] 
       delete from ���̺�� where ����;
       �ط��ڵ带 �����ϹǷ� delete �ڿ� �÷��� ������� �ʴ´�.
*/
--�μ���ȣ�� 10�� ���ڵ带 �����Ͻÿ�.
delete from tb_sample where dept_no=10;
select * from tb_sample;
--���ڵ� ��ü�� �����Ͻÿ�.
delete from tb_sample;--where���� ������ ��� ���ڵ忡 ����ǹǷ� ���ǿ��
select * from tb_sample;

--�������� Ŀ���ߴ� �������� �ǵ�����.
rollback;
select * from tb_sample;

/*
DDL�� :  ���̺��� ���� �� �����ϴ� ������
(Data Definition Language :  ������ ���Ǿ�)
    ���̺� ���� : create table ���̺��
    ���̺� ����
        �÷��߰� : alter table ���̺�� add�÷���
        �÷����� : alter table ���̺�� modify �÷���
        �÷����� : alter table ���̺�� drop column�÷���
    ���̺� ���� : drop table ���̺��
    
DML�� : ���ڵ带 �Է� �� �����ϴ� ������
(Data Manipulation Language : ������ ���۾�)
    ���ڵ��Է� : insert into ���̺�� (�÷�) values (��)
    ���ڵ���� : update ���̺�� set �÷�=�� where ����
    ���ڵ���� : delete from ���̺�� where ����
*/

--------------------------------------------------
/*
1. DDL�� �������� 2������ ���� ��pr_emp�� ���̺� ������ ���� ���ڵ带 �����Ͻÿ�. 
*/
insert into pr_emp (eno, ename, job, regist_date)
values (1, '���¿�', '� �¹�', '1975/11/21');
insert into pr_emp (eno, ename, job, regist_date)
   values (2, '������', '���л� �¹�', '1978/07/23');
    insert into pr_emp (eno, ename, job, regist_date)
    values (3, '�Ѱ���', '� ����', '1982/10/24');
    insert into pr_emp (eno, ename, job, regist_date)
    values (4, '�����', '���л� ����', '1988/05/21');
desc pr_emp;
select*from pr_emp;
--���1
insert into pr_emp (1, '���¿�', '��¹�', to_date('1975/11/21'));
insert into pr_emp (2, '������', '���л� �¹�', to_date('1978/07/23'));
--���2
insert into pr_emp (eno, ename, job, regist_date)
    values (3, '�Ѱ���', '�����', to_date('1982-10-24'));
insert into pr_emp (eno, ename, job, regist_date)
    values (4, '�����', '���л� ����', to_date('1988-05-21'));

/*
2. �� ���̺� ���� ���ǿ� �´� ���ڵ带 �����Ͻÿ�.
��ϳ�¥ : to_date�Լ��� �̿��ؼ� ���糯¥ �������� 7������¥ �Է�
*/
-- sysdate ��ü�� ��¥�����̹Ƿ� �Ʒ� 2���� ��� ��� ������.
--���1
insert into pr_emp(eno, ename, job, regist_date)
    values (5, '������', '������', to_date(sysdate-7));
--���2
insert into pr_emp(eno, ename, job, regist_date)
    values (5, '������', '������', sysdate-7);

/*
3. pr_emp ���̺��� eno�� ¦���� ���ڵ带 ã�Ƽ� job �÷��� ������ ������ ���� �����Ͻÿ�.
*/


select * from pr_emp where mod(eno, 2)=0; 
update pr_emp set job=job||'(¦��)' where mod(eno, 2)=0;

update pr_emp set job=concat(job,'(Ȧ��)') where mod(eno, 2)=1;
select*from pr_emp;


/*
4. pr_emp ���̺��� job �� ���л��� ���ڵ带 ã�� �̸��� �����Ͻÿ�. 
���ڵ�� �����Ǹ� �ȵ˴ϴ�.
*/

select * from pr_emp where job like '%���л�%';
update pr_emp set ename='' where job like '%���л�%';
select * from pr_emp;

/*
5.  pr_emp ���̺��� ������� 10���� ��� ���ڵ带 �����Ͻÿ�.
*/

--10���� ���ڵ带 �����Ѵ�.
select * from pr_emp where to_char(regist_date, 'mm')='10';
select * from pr_emp where substr(regist_date,4,2)='10';
select * from pr_emp where regist_date like '%___10___';
--���ǿ� �´� ���ڵ带 �����Ѵ�.
delete from pr_emp where to_char(regist_date, 'mm')='10';
select * from pr_emp;


/*
6.  pr_emp ���̺��� �����ؼ� pr_emp_clone ���̺��� �����ϵ� ���� ���ǿ� �����ÿ�. 
����1 : ������ �÷����� idx, name, nickname, regidate �Ͱ��� �����ؼ� �����Ѵ�. 
����2 : ���ڵ���� ��� �����Ѵ�. 
*/
--���̺� ����� �÷��� �����Ϸ��� �������̺��� �÷��� 1:1�� ��Ī�Ǵ� �÷���
--������ ���� ����ϸ� �ȴ�.
create table pr_emp_clone (
    idx, name, nickname, regidate
)
as
select * from pr_emp;

select * from pr_emp_clone;


/*
7. 6������ ������ pr_emp_clone ���̺���� pr_emp_rename ���� �����Ͻÿ�.
*/


rename pr_emp_clone to pr_emp_rename;
desc pr_emp_clone;--���̺���� ����Ǿ����Ƿ� ��Ű�� ����
desc pr_emp_rename;

/*
8. pr_emp_rename ���̺��� �����Ͻÿ�
*/

drop table pr_emp_rename;
desc pr_emp_rename;--��Ű�� ����
