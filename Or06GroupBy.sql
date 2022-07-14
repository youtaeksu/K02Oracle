/*****************************
���ϸ� : Or06GroupBy.sql
�׷��Լ�(select�� 2��°)
���� : ��ü ���ڵ�(�ο�)���� ������� ����� ���ϱ� ���� �ϳ� �̻���
    ���ڵ带 �׷����� ��� ������ ����� ��ȯ�ϴ� �Լ� Ȥ�� ������
*****************************/
--������̺��� ������ ����
select job_id from employees;--���ڵ� 107�� ����

/*
distinct
    -������ ���� �ִ� ��� �ߺ��� ���ڵ带 ������ �� �ϳ��� ���ڵ常
    �����ͼ� �����ش�.
    -�ϳ��� ������ ���ڵ��̹Ƿ� ������� �����͸� ����� �� ����.

*/
select distinct job_id from employees;

/*
group by
    -������ ���� �ִ� ���ڵ带 �ϳ��� �׷����� ��� �����´�.
    -�������°� �ϳ��� ���ڵ����� �ټ��� ���ڵ尡 �ϳ��� �׷����� ������
    ����̹Ƿ� ������� �����͸� ����� �� �ִ�.
    -�ִ�, �ּ�, ���, �ջ� ���� ������ �����ϴ�.
*/
select job_id, count(*) from employees group by job_id;
--�����ϱ�
select first_name, job_id from employees where job_id='ST_MAN';--5��
select first_name, job_id from employees where job_id='ST_CLERK';--20��

/*
�׷��Լ��� �⺻����
    select
        �÷�1, �÷�2, ... Ȥ�� ��ü(*)
    from
        ���̺��
    where
        ����1 and ����2 or ����3 ...
    group by
        ���ڵ� �׷�ȭ�� ���� �÷���
    having
        �׷쿡�� ã�� ����
    order by
        ������ ���� �÷Ÿ�� ���Ĺ��

�� ������ �������
from(���̺�) -> where(����) -> group by(�׷�ȭ) -> having(�׷�������)
    -> select(�÷�����) -> order by(���Ĺ��)
*/

/*
sum(): �հ踦 ���Ҷ� ����ϴ� �Լ�
    -number Ÿ���� �÷������� ����� �� �ִ�.
    -�ʵ���� �ʿ��� ��� as�� �̿��ؼ� ��Ī�� �ο��Ҽ� �ִ�.
*/
--��ü������ �޿��� �հ踦 ����Ͻÿ�.
select
    sum(salary) sumSalary, to_char(sum(salary), '990,000') sumSalary
from employees;

--10�� �μ��� �ٹ��ϴ� ������� �޿��� �հ�� ������ ����Ͻÿ�.
select
    sum(salary) "�ܼ��հ�", 
    to_char(sum(salary), '990,000') "���ڸ��ĸ�",
    ltrim(to_char(sum(salary), '990,000')) "������������",
    ltrim(to_char(sum(salary), 'L990,000')) "��ȭ��ȣ����"
from employees where department_id=10;


--sum()�� ���� �׷��Լ��� numberŸ���� �÷������� ����� �� �ִ�.
select sum(first_name) from employees;

/*
count() : ���ڵ��� ������ ī��Ʈ�Ҷ� ����ϴ� �Լ�
*/
--������̺� ����� ��ü ������� ����ΰ�?
select count(*) from employees; --���1 : �������
select count(employee_id) from employees; --���2 : ������׾ƴ�
/*
    count()�Լ��� ����ҋ��� �� 2���� ��� ��� ����������
    *�� ����Ұ��� �����Ѵ�. �÷��� Ư�� Ȥ�� �������� ���� ���ظ�
    ���� �����Ƿ� �˻��ӵ��� ������.
*/

/*
count()�Լ���
    ����1 : count(all �÷���)
        => ����Ʈ �������� �÷� ��ü�� ���ڵ带 �������� ī��Ʈ�Ѵ�.
    ����2 : count(distinct �÷���)
        => �ߺ��� ������ ���¿��� ī��Ʈ �Ѵ�.
*/
select
    count(job_id) "��������ü����1", 
    count(all job_id) "��������ü����2",
    count(distinct job_id) "��������������"
from employees;

/*
avg() : ��հ��� ���Ҷ� ����ϴ� �Լ�
*/
--��ü����� ��ձ޿��� �������� ����ϴ� �������� �ۼ��Ͻÿ�.
select
    count(*) "��ü�����",
    sum(salary) "�޿����հ�",
    sum(salary) / count(*) "��ձ޿�1(�������)",
    avg(salary) "��ձ޿�2",
    trim(to_char(avg(salary), '$999,000'))
from employees;

--������(SALES)�� ��ձ޿��� ���ΰ���?
--1.�μ����̺��� �������� �μ���ȣ�� �������� Ȯ���Ѵ�.
/*
    �����˻��� ��ҹ��� Ȥ�� ������ ���Ե� ��� ��� ���ڵ忡 ����
    ���ڿ��� Ȯ���ϴ°��� �Ұ����ϹǷ� �ϰ����� ��Ģ�� ������ ����
    upper()�� ���� ��ȭ�Լ��� ����Ͽ� �˻��ϴ°��� ����.
*/
select * from departments where lower(department_name)='sales';
select * from departments where department_name=initcap('sales');
select * from departments where lower(department_name)=lower('sales');--���������
--�տ��� �μ���ȣ�� 80�ΰ��� Ȯ���� �� ���� ������ �ۼ�
select
    ltrim(to_char(avg(salary), '$999,000.00'))
from employees where department_id=80;

/*
min(), max() �Լ� : �ִ밪, �ּҰ��� ã���� ����ϴ� �Լ�
*/
--������̺��� ���� ���� �޿��� ���ΰ���?
select min(salary) from employees;

--������̺��� ���� ���� �޿��� �޴� ����� �����ΰ���?
---�Ʒ� �������� �����߻���. �׷��Լ��� �Ϲ��÷��� ����� �� ����.
select first_name, salary from employees where salary=min(salary);

--������̺��� ���� ���� �޿��� 2100�� �޴� ����� �����Ѵ�.
select first_name, salary from employees where salary=2100;

/*
    ����� ���� ���� �޿��� min()���� ���Ҽ� ������ ���� ���� �޿��� 
    �޴� ����� �Ʒ��� ���� ���������� ���� ���� �� �ִ�.
    ���� ������ ���� ���������� ������� ���θ� �����ؾ� �Ѵ�.
*/
select first_name, salary from employees where salary=(
    select min(salary) from employees
);

/*
group by�� : �������� ���ڵ带 �ϳ��� �׷����� �׷�ȭ�Ͽ� ������
    ����� ��ȯ�ϴ� ������.
    �� distinct �� �ܼ��� �ߺ����� ������.
*/
--������̺��� �� �μ��� �޿��� �Ѱ�� ���ΰ���?
--group by�� ���ٸ� �Ʒ��Ͱ��� �� �μ����� �հ踦 ���ؾ� �Ұ��̴�.
select sum(salary) from employees where department_id=60;--IT�μ��� �޿��հ�
select sum(salary) from employees where department_id=100;--Finance�μ��� �޿��հ�
--step1 : �� �μ��� �׷�ȭ �ϱ�
select department_id from employees group by department_id;
--step2 : �� �μ����� �޿��հ� ���ϱ�
select department_id , sum(salary), trim(to_char(sum(salary), '$999,000'))
from employees 
group by department_id
order by sum(salary) desc;

/*
����] ������̺��� �� �μ��� ������� ��ձ޿��� ������ ����ϴ� ��������
�ۼ��Ͻÿ�.
��°�� : �μ���ȣ, �޿�����, �������, ��ձ޿�
��½� �μ���ȣ�� �������� �������� �����Ͻÿ�.
*/

select 
    department_id "�μ���ȣ",
    sum(salary) "�޿�����", 
    count(*) "�����", 
    ltrim(to_char(avg(salary),'999,000')) "��ձ޿�"
from employees group by department_id
order by department_id asc;

/*
�տ��� ����ߴ� �������� �Ʒ��� ���� �����ϸ� ������ �߻��Ѵ�.
group by������ ����� �÷��� select������ ����� �� ������, �׿���
���� �÷��� select������ ����� �� ����.
�׷�ȭ�� ���¿��� Ư�� ���ڵ� �ϳ��� �����ϴ°��� �ָ��ϹǷ� ������ �߻��Ѵ�.
*/
select 
    department_id "�μ���ȣ", sum(salary) "�޿�����",
    first_name
from employees group by department_id
order by department_id asc;

/*
�ó�����] �μ����̵� 50�� ������� ��������, ��ձ޿�, �޿�������
    ������ �߷��ϴ� �������� �ۼ��Ͻÿ�.
*/
select 
    count(*) "��������",
    round(avg(salary)) "��ձ޿�",
    sum(salary) "�޿�����"
from employees 
where department_id=50
group by department_id;

/*
having�� : ���������� �����ϴ� �÷��� �ƴ� �׷��Լ��� ���� ��������
    ������ �÷��� ������ �߰��Ҷ� ����Ѵ�.
    �ش� ������ where���� �߰��ϸ� ������ �߻��Ѵ�.
*/

/*
�ó�����] ������̺��� �� �μ����� �ٹ��ϰ� �ִ� ������ �������� �������
    ��ձ޿��� ������ ����ϴ� �������� �ۼ��Ͻÿ�.
    ��, ������� 10�� �ʰ��ϴ� ���ڵ常 �����Ͻÿ�.
*/
select
    department_id, job_id, count(*), avg(salary)
from employees
/**where count(*)>10***/
group by department_id, job_id
having count(*)>10
order by department_id;
/*
    �����κ� ������� ������ �����ϴ� �÷��� �ƴϹǷ� 
    where���� ���� ������ �߻��Ѵ�. �̷� ��쿡�� having����
    ������ �߰��ؾ� �Ѵ�.
    ex) �޿��� 3000�� ���      => ���������� ������
        ��ձ޿��� 3000�� ���  => �׷��Լ��� ���� �˼��ִ� ������(��������)
*/

/*
����] �������� ����� �����޿��� ����Ͻÿ�.
    ��, �����ڰ� ���� ����� �����޿��� 3000�̸��� �׷��� ���ܽ�Ű��
    ����� �޿��� ������������ �����Ͽ� ����Ͻÿ�.
*/
select
    job_id, min(salary)
from employees
where manager_id is not null
group by job_id
having not min(salary)<3000
order by min(salary) desc;
/*
    ���������� �޿��� ������������ �����϶�� ���û����� ������, 
    ���� select�Ǵ� �׸��� �޿��� �ּҰ��̹Ƿ� order by������ min(salary)��
    ����ؾ� �Ѵ�.
*/

---------------------------------------------------------------------------
/*
1. ��ü ����� �޿��ְ��, ������, ��ձ޿��� ����Ͻÿ�. 
�÷��� ��Ī�� �Ʒ��� ���� �ϰ�, ��տ� ���ؼ��� �������·� �ݿø� �Ͻÿ�.
��Ī) �޿��ְ�� -> MaxPay
�޿������� -> MinPay
�޿���� -> AvgPay
*/


select 
min(salary) as "MINPAY",
max(salary) as "MAXPAY", 
round(avg(salary)) as "AvgPay"
from employees;

--round(), to_char() : �ݿø� ó�� �Ǿ� ��µ�
--trunc() : �Ҽ� ���ϸ� �߶� ��µ�. �ݿø����� ����.
select
    max(salary)MaxPay, min(salary) MinPay, avg(salary) AvgPay1,
    round(avg(salary)) AvgPay2, to_char(avg(salary), '99,000') AvgPay3,
    trunc(avg(salary)) AvgPay3 --<����ó��
from employees;


/*
2. �� ������ �������� �޿��ְ��, ������, �Ѿ� �� ��վ��� ����Ͻÿ�. 
�÷��� ��Ī�� �Ʒ��� �����ϰ� ��� ���ڴ� to_char�� �̿��Ͽ� 
���ڸ����� �ĸ��� ��� �������·� ����Ͻÿ�.
��Ī) �޿��ְ�� -> MaxPay
�޿������� -> MinPay
�޿���� -> AvgPay
�޿��Ѿ� -> SumPay
����) employees ���̺��� job_id�÷��� �������� �Ѵ�.
*/

select
job_id,
    to_char(max(salary), '999,000') MaxPay, 
    to_char(min(salary), '999,000') MinPay, 
    to_char(sum(salary), '999,000') SumPay,
    to_char(round(avg(salary)), '999,000') AvgPay
    from employees
    group by job_id
    order by SumPay asc;

--group by������ ����� �÷��� select������ ������ �� �ִ�.
select
    max(salary) MaxPay, min(salary) MinPay, 
    avg(salary) AvgPay, sum(salary) SumPay
from employees group by job_id;


/*
3. count() �Լ��� �̿��Ͽ� �������� ������ ������� ����Ͻÿ�.
����) employees ���̺��� job_id�÷��� �������� �Ѵ�.
*/


select job_id, 
count(*) "�����հ�"
from employees
group by job_id;

--���������� �����ϴ� �÷��� �ƴ϶�� �Լ� Ȥ�� ������ �״�� order by���� ����ϸ�ȴ�.
--������ �ʹ� ��ٸ� ��Ī�� ����ص� �ȴ�.
select
    job_id, count(*) "�����"
from employees group by job_id
/*order by count(*) desc;*/
order by "�����" desc;


/*
4. �޿��� 10000�޷� �̻��� �������� �������� �հ��ο����� ����Ͻÿ�.
*/

select 
    job_id, count(*) "�������հ��ο�"
from employees where salary>=10000
group by job_id;



/*
5. �޿��ְ�װ� �������� ������ ����Ͻÿ�. 
*/

select 
max(salary) - min(salary)"�ְ��ּұ޿���"
from employees;

/*
6. �� �μ��� ���� �μ���ȣ, �����, �μ� ���� ��� ����� ��ձ޿��� ����Ͻÿ�.
��ձ޿��� �Ҽ��� ��°�ڸ��� �ݿø��Ͻÿ�.
*/


select
department_id,
count(*),
to_char(avg(salary), '999,000.00') as "��ձ޿�"
from employees
group by department_id,salary
order by department_id asc;


select
    department_id, count(*), avg(salary),
    to_char(avg(salary), '999,000.00') "��ձ޿�1",
    round(avg(salary),2) "��ձ޿�2"
from employees group by department_id;
order by department_id asc;
