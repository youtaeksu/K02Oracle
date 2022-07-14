/************************
���ϸ� : Or01SelectBasic.sql
ó������ �����غ��� ���Ǿ�(SQL�� Ȥ�� Query��)
�����ڵ� ���̿����� '����'�̶�� ǥ���ϱ⵵ �Ѵ�.
���� : select, where �� ���� �⺻���� DQL�� ����غ���
*************************/


/*
SQl Developer���� �ּ� ����ϱ�
    �������ּ� : �ڹٿ� ������
    ���δ����ּ� : -- ���๮��. ������ 2���� �������� ���
*/

--select�� : ���̺� ����� ���ڵ带 ��ȸ�ϴ� SQL������ DQl���� �ش��Ѵ�.
/*
����]
    select �÷�1, �÷�2, .....[�Ǵ� *]
    from ���̺��
    where ����1 and ����2 or ����3 .....
    order by �������÷� asc(��������), desc(��������) ;
*/
--������̺� ����� ��� ���ڵ带 ������� ��� �÷��� ��ȸ�ϱ� 
select * from employees;


/*
�÷����� �����ؼ� ��ȸ�ϰ� ���� �÷��� ��ȸ�ϱ�
=> �����ȣ, �̸�, �̸���, �μ���ȣ�� ��ȸ�غ���.
*/
select employee_id, first_name, last_name, email, department_id 
from employees;--�ϳ��� �������� ������ ;�� �ݵ�� ����ؾ� �Ѵ�.

--���̺��� ������ �÷��� �ڷ���, ũ�⸦ ����Ѵ�.
desc employees;

/*
�÷��� ������(number)�� ��� ��������� �����ϴ�.
100�� �λ�� ������ �޿��� ��ȸ�Ͻÿ�.
*/
select employee_id, first_name, salary, salary+100 from employees;
--number(����)Ÿ���� �÷������� ������ �� �ִ�.
select employee_id, first_name, salary, salary+commission_pct 
from employees;--Ŀ�̼��� ��������� �����Ƿ� ��κ��� ����� null�� ���´�.

/*
AS(�˸��ƽ�) : ���̺� Ȥ�� �÷��� ��Ī(����)�� �ο��Ҷ� ����Ѵ�.
    ���� ���ϴ� �̸�(����, �ѱ�)���� ������ �� ����� �� �ִ�.
    Ȱ���] �޿�+�������� => Salcomm�� ���� ���·� ��Ī�� �ο��Ѵ�.
*/
select first_name, salary, salary+100 as "�޿�100����" from employees;
select first_name, salary, salary+commission_pct as Salcomm
from employees;--��Ī�� �������� ���°� �����Ѵ�.

--as�� ������ �� �ִ�.
select employee_id "������̵�", first_name "�̸�", last_name "��"
from employees where first_name='William';

--����Ŭ�� �⺻������ ��ҹ��ڸ� �������� �ʴ´�. ������� ��� �Ѵ� ����Ҽ��ִ�.
SELECT employee_id "������̵�", first_name "�̸�", last_name "��"
FROM employees WHERE first_name='William';

--��, ���ڵ��� ��� ��ҹ��ڸ� �����Ѵ�. �Ʒ� SQL�� �����ϸ� �ƹ��� ����� ������ �ʴ´�.
SELecT employee_id "������̵�", first_name "�̸�", last_name "��"
FROM employees WHERE first_name='WILLIAM';

/*
where���� �̿��ؼ� ���ǿ� �´� ���ڵ� �����ϱ�
-> last_name�� smith�� ���ڵ带 �����Ͻÿ�
*/
select * from employees where last_name='Smith';
/*
where���� 2�� �̻��� ������ �ʿ��Ҷ� and Ȥ�� or�� ����� �� �ִ�.
-> last_name�� smith�̸鼭 �޿��� 8000�� ����� �����Ͻÿ�.
*/
select * from employees where last_name='Smith' and salary=8000;
--���� : �÷��� �������ΰ�� �ݵ�� �̱������̼��� ����ؾ� �Ѵ�.
select * from employees where last_name=Smith and salary=8000;--�����߻�
-- �÷��� �������̸� �Ⱦ��°� �⺻�̴�. ������ ������ �ڵ����� ���ŵȴ�.
select * from employees where last_name='Smith' and salary='8000';

/*
�񱳿����ڸ� ���� �������ۼ�
    : �̻�, ���Ͽ� ���� ���ǿ� >, <= �� ���� �񱳿����ڸ� ����� �� �ִ�.
    ��¥�� ��� ������ ��¥�� ���� ���ǵ� �����ϴ�.
*/
--�޿��� 5000�̸��� ����� ������ �����Ͻÿ�.
select * from employees where salary<5000;
--�Ի����� 04��01��01�� ������ ��� ������ �����Ͻÿ�.
select * from employees where hire_date>='04/01/01';

/*
in������
    : or�����ڿ� ���� �ϳ��� �÷��� �������� ������ ������ �ɰ������
    ����Ѵ�.
    -> �޿��� 4200, 6400, 8000�� ����� ������ �����Ͻÿ�.
*/
--���1 : or�� ����Ѵ�. �̶� �÷����� �ݺ������� ����ؾ� �ϹǷ� �����ϴ�.
select * from employees where salary=4200 or salary=6400 or salary=8000;
--���2 : in�� ����ϸ� �÷����� �ѹ��� ����ϸ� �ǹǷ� ���ϴ�.
select * from employees where salary in (4200, 6400, 8000);

/*
not������
    : �ش� ������ �ƴ� ���ڵ带 �����Ѵ�.
    -> �μ���ȣ�� 50�� �ƴ� ��������� ��ȸ�ϴ� SQL���� �ۼ��Ͻÿ�
*/
select * from employees where department_id<>50;
select * from employees where not (department_id=50);

/*
between and ������
    : �÷��� ������ ���� �˻��Ҷ� ����Ѵ�.
    -> �޿��� 4000~8000 ������ ��������� ��ȸ�Ͻÿ�.
*/
select * from employees where salary>=4000 and salary<=8000;
select * from employees where salary between 4000 and 8000;

/*
distinct
    : �÷����� �ߺ��Ǵ� ���ڵ带 �����Ҷ� ����Ѵ�.
    Ư�� �������� select������ �ϳ��� �÷����� �ߺ��Ǵ� ���� �ִ°��
    �ߺ����� ������ �� ����� ����� �� �ִ�.
    -> ������ ���̵� �ߺ��� ������ �� ����Ͻÿ�
*/
--��ü ����� ���� ���������� �����
select job_id from employees;
--�ߺ��� ���ŵǾ� 19���� ���������� �����
select distinct job_id from employees;

/*
like������
     : Ư�� Ű���带 ���� ���ڿ� �˻��ϱ�
     ����] �÷Ÿ� like '%�˻���%'
     ���ϵ�ī�� ����
        % : ��� ���� Ȥ�� ���ڿ��� ��ü�Ѵ�.
        Ex) D�� ���۵Ǵ� �ܾ� : D% => Da, Dae, Daewoo
            z�� ������ �ܾ� : %Z => aZ, abxZ
            C�� ���ԵǴ� �ܾ� : %C% -> aCb, abCde, vitamin-C
        _ : ����ٴ� �ϳ��� ���ڸ� ��ü�Ѵ�.
        EX) D�� �����ϴ� 3������ �ܾ� : D__ => Dab , Ddd , Dxy
            A�� �߰��� ���� 3������ �ܾ� : _A_ -> aAa, xAy
*/
--first_name�� 'D'�� �����ϴ� ������ �˻��Ͻÿ�.
select * from employees where first_name like '%D%';
--first_name�� ����°���ڰ� a�� ������ �����Ͻÿ�.
select * from employees where first_name like '__a%';
--last_name���� y�� ������ ������ �����Ͻÿ�.
select * from employees where last_name like '%y';
--��ȭ��ȣ�� 1344�� ���Ե� ���� ��ü�� �����Ͻÿ�.
select * from employees where phone_number like '%1344%';

/*
���ڵ� �����ϱ�(Sorting)
    �������� ���� : order by �÷��� asc (Ȥ�� ��������)
    �������� ���� : order by �÷��� desc
    
    2���̻��� �÷����� �����ؾ� �� ��� �޸��� �����ؼ� �����Ѵ�.
    ��, �̶� ���� �Է��� �÷����� ���ĵ� ���¿��� �ι�° �÷��� ���ĵȴ�.
*/
/*
������� ���̺��� �޿��� ���� �������� ���� ������ �������� �����Ͽ� ��ȸ�Ͻÿ�.
������÷� : first_name, salary, email, phone_number
*/
select first_name, salary, email, phone_number from employees
    order by salary asc;
    
/*
�μ���ȣ�� ������������ ������ �� �ش� �μ����� ���� �޿��� �޴� ������ ����
��µǵ��� �ϴ� SQL���� �ۼ��Ͻÿ�.
����׸� : �����ȣ, �̸�, ��, �޿�, �μ���ȣ
*/
select employee_id, first_name, last_name, salary, department_id
from employees
order by department_id desc, salary asc;

/*
is null Ȥ�� is not null
    : ���� null�̰ų� null�� �ƴ� ���ڵ� ��������.
    �÷��� null���� ����ϴ� ��� ���� �Է����� ������ null����
    �Ǵµ� �̸� ������� select �Ҷ� ����Ѵ�.
*/
--���ʽ����� ���� ����� ��ȸ�Ͻÿ�
select * from employees where commission_pct is null;
--��������̸鼭 �޿��� 8000�̻��� ����� ��ȸ�Ͻÿ�
select * from employees where salary>=8000
    and commission_pct is not null;
    
-----------------------------------------------------------------------------
/*
1. ���� �����ڸ� �̿��Ͽ� ��� ����� ���ؼ� $300�� �޿��λ��� �������
�̸�, �޿�, �λ�� �޿��� ����Ͻÿ�.
*/

select * from emp;
select ENAME, SAL, SAL+300 from EMP;
select ENAME, SAL, (SAL+300) AS "RiseSalary" from emp;

/*
2. ����� �̸�, �޿�, ������ ������ �����ͺ��� ���������� ����Ͻÿ�. 
������ ���޿� 12�� ������ $100�� ���ؼ� ����Ͻÿ�.
*/

select ENAME, SAL, SAL*12+100"����" from EMP
    order by SAL desc;
    
select ENAME, SAL, (SAL*12+100)"����"from EMP;
--���Ľ� ���������� �����ϴ� �÷����� ����ϴ°� �⺻�̴�.
select ENAME, SAL, (SAL*12+100)"����"from EMP order by SAL desc;
--���������� �������� �ʴ� �÷��̶�� ���� �״�θ� order by ���� ����Ѵ�.
select ENAME, SAL, (SAL*12+100)"����"from EMP order by (SAL*12+100) desc;
select ENAME, SAL, (SAL*12+100)"����"from EMP order by "����" desc;
/*    
3. �޿���  2000�� �Ѵ� ����� �̸��� �޿��� ������������ �����Ͽ� ����Ͻÿ�
*/

select ENAME, SAL from EMP
    where SAL>=2000
    order by ENAME desc, SAL desc;

/*
4. �����ȣ��  7782�� ����� �̸��� �μ���ȣ�� ����Ͻÿ�.
*/

select ENAME, DEPTNO, from EMP where EMPNO=7782;

/*
5. �޿��� 2000���� 3000���̿� ���Ե��� �ʴ� ����� �̸��� �޿��� ����Ͻÿ�.
*/

select ENAME, SAL from EMP where not SAL between 2000 and 3000 
    order by SAL asc;
select ENAME, SAL from EMP where not (SAL between 2000 and 3000);
select ENAME, SAL from EMP where not (SAL>=2000 and SAL<=3000);
    

/*
6. �Ի����� 81��2��20�� ���� 81��5��1�� ������ ����� �̸�, ������, �Ի����� ����Ͻÿ�.
*/

select ENAME, JOB, HIREDATE from EMP
    where HIREDATE between '81/02/20' and '81/05/01';
select ENAME, JOB, HIREDATE from EMP
    where HIREDATE>='81/02/20' and HIREDATE<='81/05/01';

/*
7. �μ���ȣ�� 20 �� 30�� ���� ����� �̸��� �μ���ȣ�� ����ϵ� �̸��� ����(��������)���� ����Ͻÿ�
*/

select ENAME, DEPTNO from EMP where DEPTNO between 20 and 30 order by ENAME desc;

select ENAME, DEPTNO from EMP where DEPTNO=20 or DEPTNO=30 order by ENAME desc;
select ENAME, DEPTNO from EMP where DEPTNO in (20,30) order by ENAME desc;
/*
8. ����� �޿��� 2000���� 3000���̿� ���Եǰ� �μ���ȣ�� 20 �Ǵ� 30�� ����� �̸�,
�޿��� �μ���ȣ�� ����ϵ� �̸���(��������)���� ����Ͻÿ�
*/

select ENAME, SAL, DEPTNO from EMP 
where SAL between 2000 and 3000 and DEPTNO between 20 and 30
    order by ENAME asc;
    
select ENAME, SAL, DEPTNO from EMP
    where (SAL between 2000 and 3000) and DEPTNO in (20,30)
    order by ENAME asc;
/*
9. 1981�⵵�� �Ի��� ����� �̸��� �Ի����� ����Ͻÿ�. (like �����ڿ� ���ϵ�ī�� ���)
*/

select ENAME, HIREDATE from EMP where HIREDATE like '%81%';


/*
10. �����ڰ� ���� ����� �̸��� �������� ����Ͻÿ�. 
*/

select ENAME, JOB from EMP where MGR is null;


/*
11. Ŀ�̼��� ������ �ִ� �ڰ��� �Ǵ� ����� �̸�, �޿�, Ŀ�̼���
����ϵ� �޿� �� Ŀ�̼��� �������� ������������ �����Ͽ� ����Ͻÿ�.
*/ -- ���� 0�ΰ��� where�� 

select ENAME, SAL, COMM 
from EMP where COMM is not null
   order by SAL DESC, COMM desc;


/*
12. �̸��� ����° ���ڰ� R�� ����� �̸��� ǥ���Ͻÿ�.
*/

select ENAME from EMP where ENAME like '__R%';



/*
13. �̸��� A�� E�� ��� �����ϰ� �ִ� ����� �̸��� ǥ���Ͻÿ�.
*/

select ENAME from EMP where ENAME like '%A%' and ENAME like '%E%';
/*
�Ʒ��� ���� ��� A�� E�� ���ԵǱ� �ϳ� ������ �����Ƿ� E�� �����ϰ� A�� ������
�̸��� �˻����� �ʴ´�. */
--select ENAME FROM EMP where ENAME like '%A%E%'; ������ ������


/*
14. �������� �繫��(CLERK) �Ǵ� �������(SALESMAN)�̸鼭 
�޿��� $1600, $950, $1300 �� �ƴ� ����� �̸�, ������, �޿��� ����Ͻÿ�. 
*/

select ENAME, JOB, SAL
from EMP 
where JOB in ('CLERK','SALESMAN') and SAL not in (1600, 950, 8000);

/*
15. Ŀ�̼��� $500 �̻��� ����� �̸��� �޿� �� Ŀ�̼��� ����Ͻÿ�. 
*/

select ENAME, SAL, COMM from EMP where COMM>=500;

