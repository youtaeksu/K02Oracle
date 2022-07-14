/************************
���ϸ� : Or05Date.sql
��¥�Լ�
���� : ��, ��, ��, ��, ��, ���� �������� ��¥������ �����ϰų�
    ��¥�� ����Ҷ� Ȱ���ϴ� �Լ���
*************************/

/*
months_between() : ���糯¥�� ���س�¥ ������ �������� ��ȯ�Ѵ�.
    ����] months_between(���糯¥, ���س�¥[���ų�¥])
*/
--2020��1��1�Ϻ��� ���ݱ��� ���� ��������?
select 
    months_between(sysdate, '2020-01-01') result1,
    months_between(sysdate, to_date('2020��01��01��','yyyy"��"mm"��"dd"��"')) result2,
    ceil(months_between(sysdate, to_date('2020��01��01��','yyyy"��"mm"��"dd"��"'))) result3
from dual;

/*
�ó�����] employees ���̺� �Էµ� �������� �ټӰ������� ����Ͽ�
    ����Ͻÿ�. ����� �ټӰ������� �������� �����Ͻÿ�.
*/

select
    first_name, hire_date,
    months_between(sysdate, hire_date) "�ټӰ�����1",
    trunc(months_between(sysdate, hire_date)) as "�ټӰ�����2"
from employees
/*order by months_between(sysdate, hire_date) asc;*/
    order by "�ټӰ�����1" asc;
/*
select����� �����ϱ� ���� order by�� ����Ҷ� �÷����� ���� ����
2���� ���·� ����� �� �ִ�.
    ���1 : ������ ���Ե� �÷��� �״�� ���
    ���2 : ��Ī�� ���
*/

/*
add_months() : ��¥�� �������� ���� ����� ��ȯ�Ѵ�.
    ����] add_months(���糯¥, ���Ұ�����)
*/
--���縦 �������� 7���� ������ ��¥�� ���Ͻÿ�.
select
    sysdate , 
    add_months(sysdate, 7) "7������"
from dual;

/*
next_day() : ���糯¥�� �������� ���ڷ� �־��� ���Ͽ� �ش��ϴ�
    �̷��� ��¥�� ��ȯ�ϴ� �Լ�
    ����] next_day(���糯¥, '������')
        => ������ �������� �����ΰ���??
�� ��, ������ ������ ��¥�� ��ȸ�� �� ����.
*/
select 
    to_char(sysdate, 'yyyy-mm-dd') "���ó�¥",
    to_char(next_day(sysdate, '������'), 'yyyy-mm-dd') "����������?",
    to_char(next_day(sysdate, '�����'), 'yyyy-mm-dd') "���������?"
from dual;

/*
last_day() : �ش���� ������ ��¥�� ��ȯ�Ѵ�.
*/
select last_day('22/04/01') from dual;--30�� ���
select last_day('22/02/01') from dual;--28�� ���
select last_day('20/04/01') from dual;--2020���� �����̹Ƿ� 29�� ���


--�÷��� date�� ��� ������ ��¥������ �����ϴ�.
select
    sysdate "����",
    sysdate + 1 "����",
    sysdate - 1 "����",
    sysdate +15 "������"
from dual;