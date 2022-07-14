/************************
���ϸ� : Or04TypeConvert.sql
����ȯ�Լ� / ��Ÿ�Լ�
���� : ������Ÿ���� �ٸ� Ÿ������ ��ȯ�ؾ� �Ҷ� ����ϴ� �Լ��� ��Ÿ�Լ�
*************************/
/*
sysdate : ���糯¥�� �ð��� �� ������ ��ȯ���ش�. �ַ� �Խ����̳� ȸ�����Կ���
    ���ο� �Խù��� ������ �Է��� ��¥�� ǥ���ϱ� ���� ���ȴ�.
*/
select sysdate from dual;

/*
��¥���� : ����Ŭ�� ��ҹ��ڸ� �������� �����Ƿ�, ���Ĺ��� ���� �������� �ʴ´�.
    ���� mm�� MM�� ������ ����� ����Ѵ�.
*/
select to_char(sysdate, 'yyyy/mm/dd') from dual;
select to_char(sysdate, 'YY-MM-DD') from dual;

--���糯¥�� "������ 0000��00��00�� �Դϴ�" �� ���� ���·� ����Ͻÿ�.
select 
    to_char(sysdate, '������ yyyy��mm��dd�� �Դϴ�') "�����ɱ�?"
from dual;--�����߻� : ��¥������ �ν��� �� �����ϴ�.
/*
-(������), /(������) ���� ���ڴ� �ν����� ���ϹǷ�, ���Ĺ��ڸ� ������
������ ���ڿ��� "(���������̼�)���� ������� �Ѵ�.
���Ĺ��ڸ� ���δ°� �ƴԿ� �����ؾ��Ѵ�.
*/
select 
    to_char(sysdate, '"������ "yyyy"��"mm"��"dd"�� �Դϴ�"') "�����ȴ�"
from dual;

select
    to_char(sysdate, 'day') "����(ȭ����)",
    to_char(sysdate, 'dy') "����(ȭ)",
    to_char(sysdate, 'mon') "��(4��)",
    to_char(sysdate, 'mm') "��(04��)",
    to_char(sysdate, 'month') "��",
    to_char(sysdate, 'yy') "���ڸ��⵵",
    to_char(sysdate, 'dd') "�������ڷ�ǥ��",
    to_char(sysdate, 'ddd') "1���߸��°��"
from dual;

/*
�ó�����] ������̺��� ����� �Ի����� ������ ���� ����� �� �ֵ���
    ������ �����Ͻÿ�.
    ���] 0000��00��00��0����
*/
select
    first_name, hire_date,
    to_char(hire_date, 'yyyy"�� "mm"�� "dd"�� "dy"����"') "�Ի���"
from employees;

/*
�ð�����
����ð��� 00:00:00 ���·� ǥ���ϱ�
*/
select
    to_char(sysdate, 'HH:MI:SS'), to_char(sysdate, 'hh:mi:ss')
    , to_char(sysdate, 'hh24:mi:ss')
from dual;
--���糯¥�� �ð��� �Ѳ����� ǥ���Ѵ�.
select
    to_char(sysdate, 'yyyy-mm-dd hh:mi:ss') "����ð�"
from dual;

/*
��������
    0 : ������ �ڸ����� ��Ÿ���� �ڸ����� ���� �ʴ°�� 0���� �ڸ��� ä���.
    9 : 0�� ����������, �ڸ����� �����ʴ� ��� �������� ä���.
*/
select 
    /* 0�� �������� ����ϸ� �ڸ����� ���ڶ� ��� 0�� ä������.*/
    to_char(123, '0000'),
    /* 9�� �������� ����ϸ� ������ ����Ƿ� trim���� ������ �� �ִ�.*/
    to_char(123, '9999'), trim(to_char(123, '9999'))
from dual;
--���ڿ� ���ڸ����� �ĸ� ǥ���ϱ�
/*
�ڸ����� Ȯ���� ����ȴٸ� 0�� ����ϰ�, �ڸ����� �ٸ� �κп����� 9��
����Ͽ� ������ �����ϰ�, ������ trim()���� �����ϴ°� �����̴�.
*/
select
    12345,
    to_char(12345, '000,000'), to_char(12345, '999,999'),
    ltrim(to_char(12345, '999,999')),
    ltrim(to_char(12345, '990,000'))
from dual;
--��ȭǥ�� : L => �� ���� �´� ��ȭǥ�ð� �ȴ�. �츮����� ������ ǥ�õ�.
select to_char(1000000, 'L9,999,000') from dual;

/*
���ں�ȯ�Լ�
    to_number() : ������ �����͸� ���������� ��ȯ�Ѵ�.
*/
--�ΰ��� ���ڰ� ���ڷ� ��ȯ�Ǿ� ������ ����� ����Ѵ�.
select to_number('123')+to_number('456') from dual;
--���ڰ� �ƴ� ���ڰ� �����־� �����߻�
select to_number('123a')+to_number('456') from dual;

/*
to_date()
    : ���ڿ� �����͸� ��¥�������� ��ȯ�ؼ� ������ش�. �⺻������
    ��/��/�� ������ �����ȴ�.
*/
select
    to_date('2022-04-19') "��¥�⺻����1",
    to_date('20220419') "��¥�⺻����2",
    to_date('2022/04/19') "��¥�⺻����3"
from dual;
/*
��¥������ ��-��-�� ���� �ƴ� ��쿡�� ����Ŭ�� �ν����� ���Ͽ� ������
�߻��ȴ�. �̶��� ��¥������ �̿��� ����Ŭ�� �ν��� �� �ֵ��� ó���ؾ��Ѵ�.
*/
select to_date('04-19-2022') from dual;--�����߻�

/*
�ó�����] ������ �־��� ��¥������ ���ڿ��� ���� ��¥�� �ν��� �� �ֵ��� 
    �������� �����Ͻÿ�.
    '14-10-2021' => 2021-10-14�� �ν�
    '04-19-2022' => 2022-04-19�� �ν�
*/
select 
    to_date('14-10=2021', 'dd-mm-yyyy') "��¥���ľ˷��ֱ�1",
    to_date('04-19=2022', 'mm-dd-yyyy') "��¥���ľ˷��ֱ�2"
from dual;

/*
����] '2020-10-14 15:30:21'�� ���� ������ ���ڿ��� ��¥�� �ν��� ��
    �ֵ��� �������� �ۼ��Ͻÿ�.
*/
select to_date('2020-10-14 15:30:21') from dual;--�����߻�
--���ڿ��� �̿Ͱ��� �����ϸ� �ǰ�����, ���ڵ尡 100�����̶�� �Ұ����ϴ�.
select to_date('2020-10-14') from dual;
--substr()�� ���� ���ڿ��� ��¥�κи� �߶� ����Ѵ�.
select 
    substr('2020-10-14 15:30:21', 1, 10) "���ڿ��ڸ���",
    to_date(substr('2020-10-14 15:30:21', 1, 10)) "��¥�������κ���"
from dual;

/*
����] ���ڿ� '2021/05/05'�� � �������� ��ȯ�Լ��� ���� ����غ��ÿ�.
    ��, ���ڿ��� ���Ƿ� ������ �� ����.
*/
select  
    to_date('2021/05/05') "1�ܰ�:��¥����Ȯ��",
    to_char(sysdate, 'day') "2�ܰ�:���ϼ���",
    to_char(to_date('2021/05/05'), 'day') "3�ܰ�:����"
from dual;

/*
����] ���ڿ� '2021��01��01��'�� � �������� ��ȯ�Լ��� ���� ����غ��ÿ�.
    �� ���ڿ��� ���Ƿ� ������ �� �����ϴ�.
*/
select  
    to_date('2021��01��01��', 'yyyy"��"mm"��"dd"��"') "1�ܰ�:��¥�κ���",
    to_char(to_date('2021��01��01��', 'yyyy"��"mm"��"dd"��"'), 'day') "2�ܰ�:����"
from dual;

/*
nvl() : null���� �ٸ� �����ͷ� �����ϴ� �Լ�.
    ����] nvl(�÷���, ��ü�Ұ�)
    
�Ʒ��� ���� null�� �÷��� ������ �����ϸ� ����� null�� �ǹǷ� ������ ó����
�ʿ��ϴ�.
*/
--��������� �ƴѰ�� �޿��� null�� ��µȴ�.
select salary+commission_pct from employees;
--null ���� 0���� ������ �� ������ �����ϹǷ� �������� ����� ��µȴ�.
select
    first_name, commission_pct, salary+nvl(commission_pct, 0)
from employees;

/*
decode() : java�� switch���� ����ϰ� Ư������ �ش��ϴ� ��¹���
    �ִ� ��� ����Ѵ�.
    ����] decode(�÷���,
                ��1, ���1, ��2, ���2, .....
                �⺻��)
    �س������� �ڵ尪�� ���ڿ��� ��ȯ�Ͽ� ����Ҷ� ���� ���ȴ�.
*/

/*
�ó�����] ������̺��� �� �μ���ȣ�� �ش��ϴ� �μ����� ����ϴ� ��������
    decode�� �̿��ؼ� �ۼ��Ͻÿ�.
*/
select 
    first_name, last_name, department_id,
    decode(department_id, 
        10, 'Administration',
        20,	'Marketing',
        30,	'Purchasing',
        40,	'Human Resources',
        50,	'Shipping',
        60,	'IT',
        70,	'Public Relations',
        80,	'Sales',
        90,	'Executive',
        100, 'Finance', 
        '�μ���Ȯ�ξȵ�') as department_name
from employees;

/*
case() : java�� if~else���� ����� ��Ȱ�� �ϴ� �Լ�
    ����] case
            when ����1 then ��1
            whhe ����2 then ��2
            .....
            else �⺻��
        end
*/
/*
�ó�����] ������̺��� �� �μ���ȣ�� �ش��ϴ� �μ����� ����ϴ� ��������
    case���� �̿��ؼ� �ۼ��Ͻÿ�.
*/
select first_name, last_name, department_id,
    case
        when department_id=10 then 'Administration'
        when department_id=20 then 'Marketing'
        when department_id=30 then 'Purchasing'
        when department_id=40 then 'Human Resources'
        when department_id=50 then 'Shipping'
        when department_id=60 then 'IT'
        when department_id=70 then 'Public Relations'
        when department_id=80 then 'Sales'
        when department_id=90 then 'Executive'
        when department_id=100 then 'Finance'
        else '�μ���Ȯ�ξȵ�'
    end team_name
from employees;

--------------------------------------------------------------------------------
/*
1. substr() �Լ��� ����Ͽ� ������� �Ի��� �⵵�� �Ի��� �޸� ����Ͻÿ�.
*/

select 
    substr(HIREDATE,1,5) from EMP
        order by HIREDATE desc;


select * from EMP;
select
    HIREDATE,
    substr(HIREDATE, 1, 5) "�Ի���1",
    to_char(HIREDATE, 'yy-mm') "�Ի���2"
from EMP;

/*
2. substr()�Լ��� ����Ͽ� 4���� �Ի��� ����� ����Ͻÿ�. 
��, ������ ������� 4���� �Ի��� ������� ��µǸ� �ȴ�.
*/

select ENAME,
    substr(HIREDATE,4) from  EMP where HIREDATE like '%04%'; 

select * from EMP where substr(HIREDATE, 4, 2)='04';
select * from EMP where to_char(HIREDATE, 'mm')='04';

/*
3. mod() �Լ��� ����Ͽ� �����ȣ�� ¦���� ����� ����Ͻÿ�.
*/

select * from EMP where mod(EMPNO, 2)=0;


/*
4. �Ի����� ������ 2�ڸ�(YY), ���� ����(MON)�� ǥ���ϰ� ������ ���(DY)�� �����Ͽ� ����Ͻÿ�.
*/

select ENAME, HIREDATE,
    to_char(sysdate, 'dy') "����(ȭ)",
    to_char(sysdate, 'mon') "��(4��)",
    to_char(sysdate, 'yy') "���ڸ��⵵"
from EMP;

/*
5. ���� ��ĥ�� �������� ����Ͻÿ�. ���� ��¥���� ���� 1��1���� �� 
����� ����ϰ� TO_DATE()�Լ��� ����Ͽ� ������ ���� ��ġ ��Ű�ÿ�.
��, ��¥�� ���´� ��01-01-2020�� �������� ����Ѵ�. 
�� sysdate - ��01-01-2020�� �̿Ͱ��� ������ �����ؾ��Ѵ�. 
*/
--sysdate - to_date('01-01-2022') �̿Ͱ��� �ϸ� �����߻���

select
    sysdate - to_date('20/01/01') "�⺻��¥���Ļ��",
    to_date('01-01-2020','dd-mm-yyyy') "��¥��������",
    trunc(sysdate - to_date('01-01-2020','dd-mm-yyyy')) "��¥����"
from dual;


/*
6. ������� �޴��� ����� ����ϵ� ����� ���� ����� ���ؼ��� 
NULL�� ��� 0���� ����Ͻÿ�.
*/

select
    ENAME, nvl(mgr,0) "�޴������"
from EMP;

/*
7. decode �Լ��� ���޿� ���� �޿��� �λ��Ͽ� ����Ͻÿ�. 
��CLERK���� 200, ��SALESMAN���� 180, ��MANAGER���� 150, ��PRESIDENT���� 100��
�λ��Ͽ� ����Ͻÿ�.
*/
select 
    ename, sal,
    decode(job,
        'CLERK', sal+200,
        'SALESMAN', sal+180,
        'MANAGER', sal+150,
        'PRESIDENT', sal+100,
        sal) as "�λ�ȱ޿�"
from emp;



