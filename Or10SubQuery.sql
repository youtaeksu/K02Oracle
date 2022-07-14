/******************
���ϸ� : Or10SubQuery.sql
��������
���� : �������ȿ� �� �ٸ� �������� ���� ������ select��
*******************/

/*
������ ��������
    ����]
        select * from ���̺�� where �÷�=(
            select �÷� from ���̺�� where ����
        );
    �� ��ȣ���� ���������� �ݵ�� �ϳ��� ����� �����ؾ� �Ѵ�. 
*/

/*
�ó�����] ������̺��� ��ü����� ��ձ޿����� ���� �޿��� �޴� ������� 
�����Ͽ� ����Ͻÿ�.
    ����׸� : �����ȣ, �̸�, �̸���, ����ó, �޿�
*/
--��ձ޿� ���ϱ�:6461
select avg(salary) from employees;
--�ش� �������� ���ƻ� �´µ������� �׷��Լ��� �����࿡ ������ �߸��� �������̴�. 
select * from employees where salary<avg(salary);--�����߻�
--�տ��� ���� ��ձ޿��� �������� select�� ����
select * from employees where salary<6461;
--2���� �������� �ϳ��� �������������� ����
select * from employees where salary<(select avg(salary) from employees);

/*
�ó�����] ��ü ����� �޿��� �������� ����� �̸��� �޿��� ����ϴ� 
������������ �ۼ��Ͻÿ�.
����׸� : �̸�1, �̸�2, �̸���, �޿�
*/
--1�ܰ� : �ּұ޿�Ȯ��
select min(salary) from employees;
--2�ܰ� : 2100�� �޴� ���� ����
select * from employees where salary=2100;
--3�ܰ� : ������ ����
select * from employees where salary=(select min(salary) from employees);

/*
�ó�����] ��ձ޿����� ���� �޿��� �޴� ������� ����� ��ȸ�Ҽ� �ִ� 
������������ �ۼ��Ͻÿ�.
��³��� : �̸�1, �̸�2, ��������, �޿�
�� ���������� jobs ���̺� �����Ƿ� join�ؾ� �Ѵ�. 
*/
--1�ܰ�:��ձ޿�
select round(avg(salary)) from employees;
--2�ܰ�:join
select first_name, last_name, job_title, salary 
from employees inner join jobs using(job_id)
where salary>6462;
--3�ܰ�:����
select first_name, last_name, job_title, salary 
from employees inner join jobs using(job_id)
where salary>(select round(avg(salary)) from employees);


/*
������ ��������
    ����]
        select * from ���̺�� where �÷� in (
            select �÷� from ���̺�� where ����
        );
    �� ��ȣ���� ���������� 2�� �̻��� ����� �����ؾ� �Ѵ�.
*/
/*
�ó�����] ���������� ���� ���� �޿��� �޴� ����� ����� ��ȸ�Ͻÿ�.
    ��¸�� : ������̵�, �̸�, ���������̵�, �޿�
*/
--1�ܰ� : �������� ���� ���� �޿� Ȯ��
select job_id, max(salary) from employees
group by job_id;
--2�ܰ� : ���� ����� �ܼ��� or�������� �����. 
select
     employee_id, first_name, job_id, salary
from employees
where 
    (job_id='IT_PROG' and salary=9000) or
    (job_id='AC_MGR' and salary=12008) or
    (job_id='AC_ACCOUNT' and salary=8300) or
    (job_id='ST_MAN' and salary=8200);--������ 19���� or���� �ʿ������� 4���� �����.
--3�ܰ� : ������ �����ڸ� ���� ���������� �����Ѵ�. 
select
     employee_id, first_name, job_id, salary
from employees
where 
    (job_id, salary) in (
        select job_id, max(salary) from employees
        group by job_id
    );


/*
������ ������2 : any
    ���������� �������� ���������� �˻������ �ϳ��̻�
    ��ġ�ϸ� ���� �Ǵ� ������. �� ���� �ϳ��� �����ϸ� �ش�
    ���ڵ带 �����´�. 
*/
/*
�ó�����] ��ü����߿��� �μ���ȣ�� 20�� ������� �޿����� ���� �޿��� �޴� 
    �������� �����ϴ� ������������ �ۼ��Ͻÿ�. ���� �ϳ��� �����ϴ��� �����Ͻÿ�.
*/
--1.20�� �μ��� �޿��� Ȯ��
select first_name, salary from employees where department_id=20;
--2.1�� ����� �ܼ� ������ �ۼ�
select first_name, salary from employees 
where salary>13000 or salary>6000;
--3.���� �ϳ��� �����ϸ� ���ڵ带 �����Ұ��̹Ƿ� any�� �̿��ؼ� �������� �ۼ�
select first_name, salary from employees 
where salary>any(select salary from employees where department_id=20);
/*
    ������ ������ any�� ����ϸ� 2���� ���� or �������� ����� �����ϰԵȴ�.
    6000 �Ǵ� 13000 �̻��� ���ڵ带 �����Ѵ�. 
*/

/*
�����࿬����3 : all
    ���� ������ �������� ���������� �˻������ ��� ��ġ�ؾ�
    ���ڵ带 �����Ѵ�. 
*/
/*
�ó�����] ��ü����߿��� �μ���ȣ�� 20�� ������� �޿����� ���� �޿��� �޴� 
    �������� �����ϴ� ������������ �ۼ��Ͻÿ�. �Ѵ� �����ϴ� ���ڵ常 �����Ͻÿ�.
*/
select first_name, salary from employees 
where salary>all(select salary from employees where department_id=20);
/*
    6000�̻��̰� ���ÿ� 13000���ٵ� Ŀ���ϹǷ� ��������� 13000�̻���
    ���ڵ常 �����ϰ� �ȴ�. 
*/

/*
rownum : ���̺��� ���ڵ带 ��ȸ�� ������� ������ �ο��Ǵ� ������
    �÷��� ���Ѵ�. �ش� �÷��� ��� ���̺� �������� �����Ѵ�. 
*/
--��� ������ �������� �����ϴ� ���̺�
select * from dual;
--���ڵ��� ���ľ��� ��� ���ڵ带 �����ͼ� rownum�� �ο��Ѵ�.(rownum�� ������� ����)
select first_name, rownum from employees;
--�̸��� ������������ ������ �� ����Ѵ�.(rownum�� ������ �̻��ϰ� ����)
select first_name, rownum from employees order by first_name;
/*
    rownum�� �츮�� ������ ������� ��ο��ϱ� ���� ���������� ����Ѵ�. 
    from������ ���̺��� ���;� �ϴµ�, �Ʒ��� �������������� ������̺��� 
    ��ü���ڵ带 ������� �ϵ� �̸����� ���ĵ� ���·� ���ڵ带 �����ͼ� ���̺�ó��
    ����Ѵ�. 
*/
select first_name, rownum from 
    (select * from employees order by first_name asc);

--������̺��� rownum�� ���� ������ ������ �Ʒ��Ͱ��� �����ü� �ִ�. 
select * from 
    (select tb.*, rownum rNum from 
        (select * from employees order by first_name asc) tb)
--where rNum between 1 and 10;
--where rNum between 11 and 20;
where rNum>=21 and rNum<=30;
/*
    between�� ������ ���Ͱ��� �������ָ� �ش� �������� ���ڵ常 �����ϰ� �ȴ�. 
    ���� ������ ���� JSP���� �������� ������ �����Ͽ� ����ϰԵȴ�. 
    �Խ��� ����¡���� �� �������� �״�� ����Ѵ�. 

    3.2�� ��� ��ü�� select������ ������ ����..    
        (2.1�� ��� ���ڵ忡 rownum�� �ο��Ѵ�. �����ѵ��� ��ο���. 
            (1.������̺��� ��ü ���ڵ带 ������������ �����ؼ� ����) tb
        )
    4.�ʿ��� �κ��� between�̳� �񱳿����ڷ� ������ ���� �����Ѵ�. 
    1������ : 1~10
    2������ : 11~20�� ���� ������ ���Ѵ�. 
*/

------------------------------------------------------------
--scott �������� �����մϴ�--
/*
01.�����ȣ�� 7782�� ����� ��� ������ ���� ����� ǥ��(����̸��� ��� ����)�Ͻÿ�.
*/
--�����ȣ ���ϱ�:7782
select job from emp where empno=7782;
--�������� ���� ��� ǥ��(��� �̸��� ������)
select ename, job
from emp where job='manager';
--������ ����
select * from emp 
where job = (select job from emp where empno=7782);
--��� �̸��� ������
select ename, job
from emp 
where job = (select job from emp where empno=7782);

------------------------------------------------------
select * from emp where empno=7782;--7782����� ������ Ȯ��
select * from emp where job='MANAGER';
select * from emp where job=(select job from emp where empno=7782);


/*
02.�����ȣ�� 7499�� ������� �޿��� ���� ����� ǥ��(����̸��� ��� ����)�Ͻÿ�.
*/

--�����ȣ�� 7499�� ����� �޿�
select sal from emp where empno=7499;
--�޿� 1600, ������� �޿��� ���� ���(��� �̸��� ��� ����)
select ename, job, sal
from emp where sal>1600;
--������ ����
select * from emp
where sal>(select sal from emp where empno=7499);
--��� �̸��� ������
select ename, job
from emp
where sal>(select sal from emp where empno=7499);

-----------------------------------------------------------------
select * from emp where empno=7499;--7499�� �޿� Ȯ��
select * from emp where sal>1600;
select * from emp where sal>(select sal from emp where empno=7499);


/*
03.�ּ� �޿��� �޴� ����� �̸�, ��� ���� �� �޿��� ǥ���Ͻÿ�(�׷��Լ� ���).
*/
--�ּ� �޿��� �޴� ����� �̸�
select min(sal) from emp;
--�ּ� �޿� : 800�� ����� �̸� ��� ���� �� �޿� 
select empno, ename, job, sal 
from emp where sal = 800;
--����
select empno, ename, job, sal
from emp where sal = (select min(sal) from emp);

--------------------------------------------------------------------

select min(sal) from emp;
select * from emp where sal=800;
select empno, ename, job, sal from emp where sal=(select min(sal) from emp);


/*
04.��� �޿��� ���� ���� ����(job)�� ��� �޿��� ǥ���Ͻÿ�.
*/
--�� ���� ��� �޿�
select job, avg(sal) from emp group by job;
--��ձ޿��� ���� ���� ����
select job, avg(sal)
from emp group by job
having avg(sal)=(select min(avg(sal)) from emp group by job);

---------------------------------------------
--���޺� ��ձ޿� ����
select job, avg(sal) from emp group by job;
--�����߻�. �׷��Լ��� 2�� ���Ʊ� ������ job�÷��� �����ؾ� �Ѵ�.
select job, min(avg(sal)) from emp group by job;
--�������. ������ ��ձ޿��� �ּ��� ���ڵ� ����
select min(avg(sal)) from emp group by job;
/*
��ձ޿��� ���������� �����ϴ� �÷��� �ƴϹǷ� where ������ ����Ҽ�����
having���� ����ؾ� �Ѵ�. ��, ��ձ޿��� 1017�� ������ ����ϴ� �������
���������� �ۼ��ؾ� �Ѵ�.
*/
select 
    job, avg(sal)
from emp
group by job
having avg(sal) = (select min(avg(sal)) from emp group by job);

/*
05.���μ��� �ּ� �޿��� �޴� ����� �̸�, �޿�, �μ���ȣ�� ǥ���Ͻÿ�.
*/
--���μ� �ּ� �޿�
select deptno, min(sal) from emp group by deptno;
--����� �̸�, �޿�, �μ���ȣ ���
select ename, sal, deptno
from emp
where
    (deptno = 30 and sal=950) or
    (deptno = 20 and sal=800) or
    (deptno = 10 and sal=1300);
--����
select ename, sal, deptno 
from emp
where 
(deptno, sal)
   in (select deptno, min(sal) from emp group by deptno);

---------------------------------------------------------

--�ܼ� ������ ���� �μ��� �޿� Ȯ��
select deptno, sal from emp order by deptno, sal;
--�׷��Լ��� ���� �μ��� �ּұ޿� Ȯ��
select deptno, min(sal) from emp group by deptno;
--�ܼ� or���� ���� ����
select ename, sal, deptno from emp
    where (deptno = 30 and sal=950) 
        or (deptno = 20 and sal=800) 
        or (deptno = 10 and sal=1300);
--���������� ������ �����ڸ� ���� ���� �ۼ�
select ename, sal, deptno from emp
    where (deptno, sal) in (select deptno, min(sal) from emp group by deptno);


   
/*
06.��� ������ �м���(ANALYST)�� ������� �޿��� �����鼭 
������ �м���(ANALYST)�� �ƴ� ������� ǥ��(�����ȣ, �̸�, ������, �޿�)�Ͻÿ�.
*/
--��� ������ �м��� �޿� //3000
select sal from emp where job = 'ANALYST';
--��� ������ �м����� �ƴ� ����� 
select empno, ename, job, sal from emp where not(job='ANALYST');
--������ ����, �м����� ������� �޿��� ����
select empno, ename, job, sal
from emp where sal < all (select sal from emp where job = 'ANALYST');

-------------------------------------------------------------
select * from emp where job='ANALYST';
select * from emp where sal<3000 and job<>'ANALYST';
/*
    ANALYST ������ ���� ����� 1���̹Ƿ� �Ʒ��� ���� ������ �����ڷ� ����������
    ����� ������, ���� ����� 2���̻��̶�� ������ ������ all Ȥ�� any�� 
    �߰��ؾ� �Ѵ�.
*/
select * from emp where sal<(select sal from emp where job='ANALYST')
    and job<>'ANALYST';
    
/*
07.�̸��� K�� ���Ե� ����� ���� �μ����� ���ϴ� ����� �����ȣ�� 
�̸��� ǥ���ϴ� ���Ǹ� �ۼ��Ͻÿ�
*/

select * from emp where ename like '%K%';
select * from emp where deptno in (30, 10);
/*
    or������ in���� ǥ���� �� �����Ƿ�, ������������ ������ ��������
    in�� ����Ѵ�. 2�� �̻��� ����� or�� �����Ͽ� ����ϴ� ����� ������.
*/
select * from emp where deptno in (select deptno from emp where ename like '%K%');


/*
08.�μ� ��ġ�� DALLAS�� ����� �̸��� �μ���ȣ �� ��� ������ ǥ���Ͻÿ�.
*/

select * from dept where loc = 'DALLAS';
select * from emp where deptno=20;
select * from emp where deptno=(select deptno from dept where loc = 'DALLAS');



/*
09.��� �޿� ���� ���� �޿��� �ް� �̸��� K�� ���Ե� ����� 
���� �μ����� �ٹ��ϴ� ����� �����ȣ, �̸�, �޿��� ǥ���Ͻÿ�.
*/

--��ձ޿�
select avg(sal) from emp;--2077.xxx
--K�� ���Ե� ���
select * from emp where ename like '%K%';
--�ܼ� �������� �����ۼ�
select * from emp
where sal>2077 and deptno in (30,10);
--�������������� �ۼ�
select * from emp
where sal>(select avg(sal) from emp) and
    deptno in (select deptno from emp where ename like '%K%');
    

/*
10.��� ������ MANAGER�� ����� �Ҽӵ� �μ��� ������ �μ��� ����� ǥ���Ͻÿ�.
*/

select * from emp where job='MANAGER';--10,30,20
select * from emp where deptno in (select deptno from emp where job='MANAGER');



/*
11.BLAKE�� ������ �μ��� ���� ����� �̸��� �Ի����� ǥ���ϴ� ���Ǹ� �ۼ��Ͻÿ�(��. BLAKE�� ����)
*/

select * from emp where ename='BLAKE';
select * from emp where deptno=30 and ename<>'BLAKE';
select ename, hiredate from emp
where deptno=(select deptno from emp where ename='BLAKE') and ename<>'BLAKE';

















 
 
 
 
 
