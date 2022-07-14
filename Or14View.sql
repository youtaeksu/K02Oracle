/*************************
���ϸ� : Or14View.sql
View(��)
���� : View�� ���̺�κ��� ������ ������ ���̺�� ���������δ� �������� �ʰ�
    �������� �����ϴ� ���̺��̴�.
*************************/

--hr�������� �ǽ��մϴ�. 

/*
���� ����
����]
    create [or replace] view ���̸�[(�÷�1, �÷�2....)]
    as
    select * from ���̺�� where ����
        Ȥ�� join���� ������
*/


/*
�ó�����] hr������ ������̺��� �������� ST_CLERK�� ����� ������
        ��ȸ�� �� �ִ� View�� �����Ͻÿ�.
        ����׸� : ������̵�, �̸�, �������̵�, �Ի���, �μ����̵�
*/
--1�ܰ� : ���ǵ��� select�ϱ�
select 
    employee_id, first_name, last_name, job_id, hire_date, department_id
from employees where job_id='ST_CLERK';--20������
--2�ܰ� : �� �����ϱ�
create view view_employees
as
    select 
        employee_id, first_name, last_name, job_id, hire_date, department_id
    from employees where job_id='ST_CLERK';    
--3�ܰ� : ������ �並 ���� ������� Ȯ���ϱ�    
select * from view_employees;
--�����ͻ������� ������ �� Ȯ���ϱ� : �������� �״�� ����ȴ�. 
select * from user_views;


/*
�� �����ϱ� 
    : �� �������忡 or replace �� �߰��Ѵ�. 
    �ش� �䰡 �����ϸ� �����ǰ�, ���� �������� ������ ���Ӱ� �����ȴ�. 
    ���� ó�� �並 �����Ҷ����� or replace�� ����ص� �����ϴ�. 
*/
create or replace view view_employees (id, fname, lname, jobid, hdate, depid)
as
    select 
        employee_id, first_name, last_name, job_id, hire_date, department_id
    from employees where job_id='ST_CLERK';    
/*
     �� ������ �÷����� �����ϸ� ��ġ ��Ī�� �ذ�ó�� ���� ���̺��� 
     �÷����� ������ �� �ִ�. 
*/    
select * from view_employees;


/*
����] ������ ������ view_employees �並 �Ʒ� ���ǿ� �°� �����Ͻÿ�
      �������̵� ST_MAN�� ����� �����ȣ, �̸�, �̸���, �Ŵ������̵�
      ��ȸ�� �� �ֵ��� �����Ͻÿ�.
      ���� �÷����� e_id, name, email, m_id�� �����Ѵ�. ��, �̸��� first_name��
      last_name�� ����� ���·� ����Ͻÿ�
*/
--������ ���Ǵ�� select�� ����
select employee_id, concat(first_name||' ', last_name), email, manager_id
from employees where job_id='ST_MAN';
--��Ī�� �ο��Ͽ� �� ����
create or replace view view_employees (e_id, name, email, m_id)
as 
    select employee_id, concat(first_name||' ', last_name), email, manager_id
    from employees where job_id='ST_MAN';
--�並 ���ؼ� ��� Ȯ��
select * from view_employees;


/*
����] �����ȣ, �̸�, ������ ����Ͽ� ����ϴ� �並 �����Ͻÿ�.
�÷��� �̸��� emp_id, l_name, annual_sal�� �����Ͻÿ�.
�������� -> (�޿�+(�޿�*���ʽ���))*12
���̸� : v_emp_salary
��, ������ ���ڸ����� �ĸ��� ���ԵǾ�� �Ѵ�. 
*/
select
    employee_id, last_name, (salary+(salary*nvl(commission_pct,0)))*12
from employees;
/*
    ���ʽ����� null�� ��� ������ ������ �ʰ� null�� ��µǹǷ� nvl()�Լ���
    �̿��ؼ� 0���� ��ȯ�� �� ����Ѵ�. ���� to_char()�� trim()�Լ��� ����
    ���ڼ��İ� ������ �����Ѵ�. 
*/
create or replace view v_emp_salary (emp_id, l_name, annual_sal)
as
    select
        employee_id, last_name, 
        trim(to_char((salary+(salary*nvl(commission_pct,0)))*12, '$999,000'))
    from employees; 

select * from v_emp_salary;


/*
-������ ���� View ����
�ó�����] ������̺�� �μ����̺�, �������̺��� �����Ͽ� ���� ���ǿ� �´� �並 
�����Ͻÿ�.
����׸� : �����ȣ, ��ü�̸�, �μ���ȣ, �μ���, �Ի�����, ������
���Ǹ�Ī : v_emp_join
�����÷� : empid, fullname, deptid, deptname, hdate, locname
�÷��� ������� : 
	fullname => first_name+last_name 
	hdate => 0000��00��00��
    locname => XXX���� YYY (ex : Texas���� Southlake)	
*/
--1.select�� ����
select
    employee_id, first_name||' '||last_name, department_id,
    to_char(hire_date, 'yyyy"��"mm"��"dd"��"'),
    state_province||'�� ��'||city
from employees 
    inner join departments using(department_id)
    inner join locations using(location_id);
--2.View����
create or replace view v_emp_join (empid, fullname, deptid, deptname, hdate, locname)
as 
    select
        employee_id, first_name||' '||last_name, department_id, department_name,
        to_char(hire_date, 'yyyy"��"mm"��"dd"��"'),
        state_province||'�� ��'||city
    from employees 
        inner join departments using(department_id)
        inner join locations using(location_id);
--3.������ �������� view�� ���� ������ ��ȸ        
select * from v_emp_join;



